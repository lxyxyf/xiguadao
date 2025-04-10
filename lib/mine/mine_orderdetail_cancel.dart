import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:fluwx/fluwx.dart';
import 'package:intl/intl.dart';
// import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tobias/tobias.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import '../vipcenter/pay_paytype_dialog.dart';

class MineOrderdetailCancel extends StatefulWidget {
  String orderId;
  MineOrderdetailCancel({ required this.orderId});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MineOrderdetailCancel> {
  Map<String, dynamic> orderDic = {};
  Fluwx fluwx = Fluwx();
  Tobias tobias = Tobias();
  int priceSelect = 0;
  int perfectSelect = 0;
  int isVip = 0;
  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    initListener();
    getOrderDetailInfo();
  }

  getOrderDetailInfo()async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBlindTradeOrder, queryParameters: {'id':widget.orderId}, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印订单data'+data.toString());
      if (data!= null) {
        setState(() {
          orderDic = data;
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }

  deleteBlindTradeOrder()async{

    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("取消订单"),
          content: const Text("确定取消当前订单吗？"),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: const Text("取消"),
            ),
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
                sureDelete();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  sureDelete()async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.cancelBlindTradeOrder, queryParameters: {'id':widget.orderId}, successCallback: (data) async {
      EasyLoading.dismiss();
      log('取消订单data'+data.toString());
      if (data==true){
        BotToast.showText(text: '取消成功');
        Navigator.pop(context);
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor:  Colors.white,
        body: orderDic['createTime']!=null?Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.white,
          child: Stack(
            children: [

              Container(
                  height: 200,
                  width: screenSize.width,
                  padding: EdgeInsets.only(bottom: 19.5),
                  // height: 180+MediaQuery.of(context).padding.top,
                  // margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      image: DecorationImage(
                        image: AssetImage('images/order/ordertop.png'),
                        fit: BoxFit.fill,
                      )
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top:MediaQuery.of(context).padding.top,left: 15),
                          // color: Colors.white,
                          child: Row(
                            children: [
                              const Icon(Icons.arrow_back_ios,color: Colors.white,),

                              const Text(
                                '订单详情',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 12,),
                      //订单状态
                      Row(
                        children: [
                          SizedBox(width: 25,),
                          Image(image: AssetImage(orderDic['payStatus']==false?'images/order/waitpay.png':'images/order/alreadycomplete.png'),width: 24,height: 24,),
                          SizedBox(width: 7.5,),
                          Text(orderDic['payStatus']==false?'等待买家付款':'已完成',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                        ],
                      ),
                      SizedBox(height: 8,),
                      // Container(
                      //     alignment: Alignment.topLeft,
                      //     margin: EdgeInsets.only(left: 25,right: 25),
                      //     child:Container(
                      //       padding: EdgeInsets.only(left: 12.5,right: 12.5,top: 2,bottom: 2),
                      //       decoration:BoxDecoration(
                      //           borderRadius: BorderRadius.all(Radius.circular(12)),
                      //           color: Color.fromRGBO(255, 255, 255, 0.26)
                      //       ),
                      //       child:
                      //       orderDic['payStatus']==false? Text('剩余23小时29分28秒自动关闭',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                      //       :Text('订单交易完成',style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),),
                      //     )
                      // )

                    ],
                  )
              ),
              Positioned(
                  left: 0,right: 0,
                  top: 167,
                  bottom: 81.5+12.5,
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 25,right: 25),
                    child:Column(
                      children: [
                        //商品信息
                        Container(
                          height: 91,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(

                                      alignment: Alignment.topLeft,
                                      margin: EdgeInsets.only(top: 18),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(7)),
                                        child: Image(image: AssetImage(orderDic['orderType']==1?'images/order/vipcard.png':'images/order/hongniangservice.png'),width: 114.5,height: 71,),
                                      )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 9,top: 18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(orderDic['orderType']==1?'会员':'红娘服务',style:
                                        TextStyle(color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),

                                        SizedBox(height: 4.5,),
                                        Text(orderDic['orderType']==1?'有效期：'+orderDic['openContent']:'服务时间：'+orderDic['productCount'].toString(),style:
                                        TextStyle(color: Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),),

                                        SizedBox(height: 9.5,),
                                        Text('¥'+orderDic['payPrice'].toString(),style:
                                        TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 0),
                                child: Text('X'+orderDic['productCount'].toString(),style:
                                TextStyle(color: Color(0xff999999),fontSize: 12,fontWeight: FontWeight.w500),),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 15,),

                        Divider(
                          color: Color(0xffeeeeee),
                          height: 0.5,
                        ),

                        SizedBox(height: 15,),
                        //订单信息
                        //订单编号
                        Row(
                          children: [
                            Text('订单编号：',style:
                            TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                            Text(orderDic['no'].toString(),style:
                            TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 14,),
                        //创建时间
                        Row(
                          children: [
                            Text('创建时间：',style:
                            TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                            Text(orderDic['createTime']!=null?timestampToDateString(orderDic['createTime']):'',style:
                            TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 14,),
                        //支付方式
                        Row(
                          children: [
                            Text('支付方式：',style:
                            TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                            Text(orderDic['payway'].toString()=='1'?'微信':'支付宝',style:
                            TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 14,),
                        //付款时间
                        Row(
                          children: [
                            Text('付款时间：',style:
                            TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                            Text(orderDic['payTime']!=null?timestampToDateString(orderDic['payTime']):'',style:
                            TextStyle(color: Color(0xff333333),fontSize: 14,fontWeight: FontWeight.bold),)
                          ],
                        ),
                        SizedBox(height: 14,),
                        //商品总额
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('商品总额：',style:
                            TextStyle(color: Color(0xff666666),fontSize: 14,fontWeight: FontWeight.w500),),
                            Text('¥99',style:
                            TextStyle(color: Color(0xffF24C41),fontSize: 17,fontWeight: FontWeight.bold),)
                          ],
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                    ),
                  )
              ),

              //底部
              orderDic['payStatus']==false?Positioned(
                  left: 0,
                  right: 0,
                  bottom: 81.5+12.5,
                  child: Container(
                    height: 1,
                    color: Color.fromRGBO(153, 153, 153, 0.17),
                  )):Container(),

              orderDic['payStatus']==false?Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).viewInsets.bottom+12.5,
                  height: 81.5,
                  child: Container(
                    margin: EdgeInsets.only(left: 15,right: 15,top: 12.5,bottom: 12.5),
                    decoration: BoxDecoration(
                        color: isVip==1?Color.fromRGBO(255, 239, 229, 1):Colors.white,
                        borderRadius:
                        BorderRadius.all(Radius.circular(11))
                    ),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            //取消订单
                            deleteBlindTradeOrder();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 0,right: 0),
                            width: (screenSize.width-30-10.5)/2,
                            height: 55,
                            decoration: BoxDecoration(
                              // color: Color(0xffFE7A24),
                                borderRadius:
                                BorderRadius.all(Radius.circular(11)),
                                border: Border.all(color: Color(0xffFE7A24), width: 1)
                            ),
                            child:Text('取消订单',style: TextStyle(color: Color(0xffFE7A24),fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                          ),
                        ),
                        SizedBox(width: 10.5,),
                        GestureDetector(
                          onTap: (){
                            vipOrder(orderDic);
                          },
                          child:  Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 0,right: 0),
                            width: (screenSize.width-30-10.5)/2,
                            height: 55,
                            decoration: BoxDecoration(
                                color: Color(0xffFE7A24),
                                borderRadius:
                                BorderRadius.all(Radius.circular(11))
                            ),
                            child:Text('去支付',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

                          ),
                        )
                      ],
                    ),
                  )):Container(),

            ],
          ),
        ):Container()

    );
  }

  vipOrder(orderDic)async{
    showPayType(orderDic);
  }

  showPayType(orderDic){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return PayPaytypeDialog(
            price: orderDic['payPrice'].toString(),
            Wepay: (){
              Navigator.pop(context);
              orderDic['orderType']==1?createWepayOrder(orderDic):createWepayOrderHongniang(orderDic);
            },
            Alipay: (){
              Navigator.pop(context);
              log('支付宝支付');
              orderDic['orderType']==1?createAliOrder(orderDic):createAliOrderHongniang(orderDic);
            },

          );
        }
    );
  }


  initListener(){
    var listener = (response) {

      if (response is WeChatPaymentResponse) {
        if(response.errCode == 0){
          BotToast.showText(text: '支付成功');
          Future.delayed(Duration(seconds: 2), () {
            // 这里是一秒后需要执行的代码
           if (mounted){
             Navigator.pop(context);
           }
          });
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }else{
          if (mounted){
            Navigator.pop(context);
          }

          BotToast.showText(text: '支付失败，请重新支付');
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }
      }
    };
    fluwx.addSubscriber(listener); // 订阅消息
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
    log('支付信息'+orderInfo.toString());
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


  //创建微信的订单会员
  createWepayOrder(orderDic)async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMemberOrder, data: {
      'mechanismId': orderDic['orderId'],
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'userId':userId
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('获取订单信息'+data.toString());
      paymentWechat(data);
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  //创建微信的订单
  createWepayOrderHongniang(orderDic)async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMemberOrder, data: {
      'makerProductId':orderDic['orderId'].toString(),
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'num':orderDic['openNum'],
      'money':orderDic['payPrice'],
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
  createAliOrder(orderDic)async{
    log('支付宝支付1');
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMemberOrder, data: {
      'mechanismId': orderDic['orderId'],
      'terminal':1,
      'payway':'2',
      'deviceType':1
    }, successCallback: (data) async {
      EasyLoading.dismiss();

      toAliPay(data.toString());
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }


  //创建支付宝的订单
  createAliOrderHongniang(orderDic)async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'makerProductId':orderDic['orderId'].toString(),
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'num':orderDic['openNum'],
      'money':orderDic['payPrice'],
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
      log("安装了支付宝");
      String aliOrderInfo = 'app_auth_token = 2021005100614834&${orderInfo}';
      log('支付宝支付的订单信息'+aliOrderInfo);
      var payResult = await tobias.pay('app_auth_token=2021005100614834&${orderInfo}',evn: AliPayEvn.sandbox);
      log(payResult.toString());
      if (payResult['result'] != null) {
        if (payResult['resultStatus'] == '9000') {
          log("支付宝支付成功");
          Navigator.pop(context);

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



  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }

  Future<void> _onRefresh() async {
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {

    });
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
