import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:screenshot/screenshot.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/tobias.dart';
import 'package:xinxiangqin/hongniang/hongniang_success_dialog.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_tijiao_luyin.dart';

import '../vipcenter/pay_paytype_dialog.dart';

class HongniangFuwudetail extends StatefulWidget {
  String serviceId;
  HongniangFuwudetail({ required this.serviceId});
  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<HongniangFuwudetail> {
  Map<String, dynamic> serviceDic = {};
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  int showdialog = 0;
  double _webHeight = 150;


  Tobias tobias = Tobias();
  Fluwx fluwx = Fluwx();
  final WebViewController _controller = WebViewController();
  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    initListener();
    getServiceDetail();

  }

  void initWebController(data) async{
    _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    _controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            BotToast.showLoading();
          },
          onPageFinished: (String url) {
            refreshHeight();

            BotToast.closeAllLoading();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    _controller.loadHtmlString(data['productIntroduct']);
  }

  refreshHeight()async{
    // var originalHeight = await _controller.runJavaScriptReturningResult("document.documentElement.clientHeight;");
    // log('网页的高度是'+originalHeight.toString());
    // setState(() {
    //   _webHeight = double.parse(originalHeight.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        color:Color(0xfffafafa),
        width: screenSize.width,
        height: screenSize.height,
        child:   serviceDic['name']!=null?Stack(
          children: [
            Positioned(
              top: 0,left: 0,right: 0,bottom: 29.5+55,
                child: Container(
              height: screenSize.height - MediaQuery.of(context).padding.top+40 - 29.5-55+36,
              child: SingleChildScrollView(
                child: Container(
                  width: screenSize.width,
                  child: Stack(
                    children: [
                      Container(

                        height: MediaQuery.of(context).padding.top+40,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: Colors.white,
                            alignment: Alignment.topLeft,
                            // margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                            padding: EdgeInsets.only(bottom: 13.5,top:MediaQuery.of(context).padding.top,left: 15),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_back_ios,color: Color(0xff333333),),

                                const Text(
                                  '商品详情',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),),
                      Container(
                        color:  Color(0xfffafafa),
                        // height: screenSize.height - MediaQuery.of(context).padding.top+40 - 29.5-55 - 100,
                        margin: EdgeInsets.only(left: 0,right: 0,top: MediaQuery.of(context).padding.top+40),
                        child: Column(
                          children: [


                            Container(
                                height: 292,
                                // width: screenSize.width,
                                padding: EdgeInsets.only(top: 15,left: 15,right: 15),
                                color:  Color(0xfffafafa),
                                child: Stack(
                                  children: [

                                    Image(image: NetworkImage(serviceDic['matchmakerCover']),height: 200,width: screenSize.width-30,fit: BoxFit.cover,),

                                    Positioned(
                                        top: 180,
                                        left: 0,right: 0,
                                        child:Container(
                                          height: 80,
                                          padding: EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:BorderRadius.all(Radius.circular(7.5)),

                                          ),

                                          child: Column(
                                            children: [

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        serviceDic['name'],
                                                        style: TextStyle(
                                                            color: Color(0xff333333),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                      SizedBox(height: 5,),

                                                      Text(
                                                        '时长:'+serviceDic['productDuration'].toString()+'个月',
                                                        style: TextStyle(
                                                            color: Color(0xff999999),
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.normal),
                                                      )
                                                    ],
                                                  ),

                                                  Text(
                                                    '￥'+serviceDic['supplyPrice'].toString(),
                                                    style: TextStyle(
                                                        color: Color(0xffF24C41),
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),))
                                  ],
                                )


                            ),


                            Container(
                                alignment: Alignment.topLeft,
                                width: screenSize.width,
                                padding: EdgeInsets.only(bottom: 15),
                                color:  Color(0xfffafafa),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(left: 15,right: 15),
                                  padding: EdgeInsets.only(left: 0,right: 15,bottom: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:BorderRadius.all(Radius.circular(7.5)),

                                  ),
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 15,),

                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: Text(
                                          '商品详情',
                                          style: TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(height: 11,),
                                      Container(
                                        margin: EdgeInsets.all(0),
                                        padding: EdgeInsets.only(left: 10,),
                                        child: Html(
                                            data: serviceDic['productIntroduct'].toString()

                                        ),)
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),],
                  ),
                ),
              ),
            )),

            Positioned(
                bottom: 29.5,
                left: 15,right: 15,
                height: 55,

                child: GestureDetector(
                  onTap: (){

                    showPayType();

                  },
                  child: Container(
                    height: 55,
                    width: screenSize.width-30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffFE7A24),
                      borderRadius:BorderRadius.all(Radius.circular(27.5)),
                    ),
                    child: Text('立即购买',style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),),
                  ),
                )
            ),


          ],
        ):Container()

    );
  }



  showPayType(){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return PayPaytypeDialog(
            price: serviceDic['supplyPrice'].toString(),
            Wepay: (){
              initListener();
              Navigator.pop(context);
              createWepayOrder();
            },
            Alipay: (){
              initListener();
              Navigator.pop(context);
              createAliOrder();
            },

          );
        }
    );
  }


  // initListener(){
  //   var listener;
  //  listener = (response) {
  //     if (response is WeChatPaymentResponse) {
  //       if(response.errCode == 0){
  //         // BotToast.showText(text: '支付成功');
  //         Future.delayed(Duration(seconds: 2), () {
  //           // 这里是一秒后需要执行的代码
  //           showSuccessDialog();
  //         });
  //
  //       }else{
  //         BotToast.showText(text: '支付失败，请重新支付');
  //       }
  //     }
  //   };
  //   fluwx.addSubscriber(listener); // 订阅消息
  // }

  initListener()async {
    var cancelable;
    cancelable = fluwx.addSubscriber((res) {
      if (res.errCode == 0) {
        cancelable.cancel();
        BotToast.showText(text: '支付成功');
        Future.delayed(const Duration(seconds: 2), () {
          showSuccessDialog();
        });
        // 这里建议去额外让后端处理支付结果回调

        // 支付成功则关闭监听 cancel


      } else {
        BotToast.showText(text: '支付失败，请重新支付');
      }
    });
  }


  showSuccessDialog(){

    showDialog(
        barrierDismissible:false,
        context:context,
        builder:(context){
          return HongniangSuccessDialog(
              OntapCommit: (){

              }
          );
        }
    );

  }




  paymentWechat(orderInfo) async {
    /// 判断手机上是否安装微信
    bool result = await fluwx.isWeChatInstalled;
    if(result==true){
      log('该手机上安装了微信');
      //请求接口返回订单信息
      payWithWeChat(orderInfo);
    } else {
      log('该手机上未安装微信,请选择其他支付方式');
    }
  }

  payWithWeChat(orderInfo)async{
    fluwx.pay(
        which: Payment(
          appId: orderInfo['appid'],
          partnerId: orderInfo['partnerId'],
          prepayId: orderInfo['prepayId'],
          packageValue: orderInfo['packageValue'],
          nonceStr: orderInfo['noncestr'],
          // 此处为 int 格式，如果后端返回的int格式则不需要进行额外处理
          timestamp: int.parse(orderInfo['timestamp']),
          sign: orderInfo['sign'],
        ));
  }


  //创建微信的订单
  createWepayOrder()async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'makerProductId': widget.serviceId.toString(),
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'productDuration':serviceDic['productDuration'],
      'num':serviceDic['productDuration'],
      'openNum':serviceDic['productDuration'],
      'money':serviceDic['supplyPrice'],
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('获取订单信息'+data.toString());
      paymentWechat(data);
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }





  //创建支付宝的订单
  createAliOrder()async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'makerProductId': widget.serviceId.toString(),
      'terminal':1,
      'payway':'2',
      'deviceType':1,
      'productDuration':serviceDic['productDuration'],
      'num':serviceDic['productDuration'],
      'openNum':serviceDic['productDuration'],
      'money':serviceDic['supplyPrice'],
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('获取订单信息'+data.toString());

      toAliPay(data.toString());
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  //吊起支付宝支付
  void toAliPay(orderInfo) async {
    //检测是否安装支付宝
    var result = await tobias.isAliPayInstalled;
    if(result){

      String orderInfostr = orderInfo.toString()+'&appAuthToken:202412BB0cc9d56c43b24b329092d71971182X87';
      log("安装了支付宝"+orderInfostr);
      var payResult = await tobias.pay(orderInfo.toString(),evn: AliPayEvn.online);
      log(payResult.toString());
      if (payResult['result'] != null) {
        if (payResult['resultStatus'] == '9000') {
          log("支付宝支付成功");
          showSuccessDialog();
        } else if (payResult['resultStatus'] == '6001') {
          log("支付宝支付失败");
          log(payResult['result'].toString());
        } else {
          log("未知错误");
        }
      }else{
        log(payResult.toString());
      }
    } else {
      log("未安装支付宝");
    }
  }





  void getServiceDetail() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMatchmakerProductInfo, queryParameters: {
      'id':widget.serviceId
    },
        successCallback: (data) async {
          log(data.toString());
          setState(() {
            serviceDic = data;

          });
        }, failedCallback: (data) {});
  }


  ImageProvider getImageProvider(String imageUrl) {
    return CachedNetworkImageProvider(
      imageUrl,
    );
  }

  @override
  void dispose() {
    eventTools.off('changeUserInfo');
    super.dispose();
  }
}
