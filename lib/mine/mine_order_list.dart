import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tobias/tobias.dart';
import 'package:xinxiangqin/activity/my_dialog_contact.dart';
import 'package:xinxiangqin/mine/mine_orderdetail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import '../hongniang/hongniang_success_dialog.dart';
import '../mine/chat_page.dart';
import '../activity/my_dialog_page.dart';
import '../vipcenter/pay_paytype_dialog.dart';

class MineOrderListPage extends StatefulWidget {
  const MineOrderListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MineOrderListPage> {
  Fluwx fluwx = Fluwx();
  Tobias tobias = Tobias();
  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['全部订单','待支付','已完成'];
  int typeSeletRow = 0;

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    initListener();
    // final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    // _coreInstance.login(userID: 'user1li',
    //     userSig: 'eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwqXFqUVGOZlQqeKU7MSCgswUJStDMwMDA1MLMwtTiExqRUFmUSpQ3NTU1AgoBREtycwFiZkbGxiZmhsbGkJNyUwHmhzo5pRZnFtm6elYFGWQEqPvHa5tmOPvFebqGxZk4OLokedflWOQb1JiUODtaqtUCwDCTDG0');
    _getData();
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
              log('支付宝支付');
              Navigator.pop(context);
              orderDic['orderType']==1?createAliOrder(orderDic):createAliOrderHongniang(orderDic);
            },

          );
        }
    );
  }




  initListener()async{

    var cancelable;
    cancelable = fluwx.addSubscriber((res){
      if(res.errCode == 0){
        // 这里建议去额外让后端处理支付结果回调

        // 支付成功则关闭监听 cancel
        cancelable.cancel();
        BotToast.showText(text: '支付成功');

        Future.delayed(const Duration(seconds: 2), () {
          // sureDelete();
         setState(() {
           _pageNo = 1;
           _getData();
         });
        });
      }else{

        BotToast.showText(text: '支付失败');
        Future.delayed(const Duration(seconds: 2), () {
          // sureDelete();
        });
      }
    });


    // var listener = (response) {
    //
    //   if (response is WeChatPaymentResponse) {
    //     if(response.errCode == 0){
    //
    //
    //       if (mounted){
    //         BotToast.showText(text: '支付成功');
    //         getOrderDetailInfo();
    //       }
    //       // fluwx.removeSubscriber(listener);// 取消订阅消息
    //     }else{
    //       if (mounted){
    //         BotToast.showText(text: '支付失败，请重新支付');
    //       }
    //       // fluwx.removeSubscriber(listener);// 取消订阅消息
    //     }
    //   }
    // };
    // fluwx.addSubscriber(listener); // 订阅消息
  }


  showSuccessDialog(){
    showDialog(
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
      'userId':userId,
      'id':orderDic['id'].toString()
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('获取订单信息'+data.toString());
      paymentWechat(data);
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }

  //创建微信的订单红娘
  createWepayOrderHongniang(orderDic)async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'makerProductId':orderDic['orderId'].toString(),
      'terminal':1,
      'payway':'1',
      'deviceType':1,
      'num':orderDic['openNum'],
      'openNum':orderDic['openNum'],
      'money':orderDic['payPrice'],
      'id':orderDic['id'].toString()
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
      'deviceType':1,
      'id':orderDic['id'].toString()
    }, successCallback: (data) async {
      EasyLoading.dismiss();

      toAliPay(data.toString());
    }, failedCallback: (data) {
      log(data.toString());
      EasyLoading.dismiss();
    });
  }


  //创建支付宝的订单红娘
  createAliOrderHongniang(orderDic)async{
    log('获取订单信息传值'+orderDic['id'].toString());
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'makerProductId':orderDic['orderId'].toString(),
      'terminal':1,
      'payway':'2',
      'deviceType':1,
      'num':orderDic['openNum'],
      'openNum':orderDic['openNum'],
      'money':orderDic['payPrice'],
      'id':orderDic['id'].toString()
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
      String aliOrderInfo = '${orderInfo}';
      log('支付宝支付的订单信息'+aliOrderInfo);
      var payResult = await tobias.pay('${orderInfo}',evn: AliPayEvn.online);
      log(payResult.toString());
      if (payResult['result'] != null) {
        if (payResult['resultStatus'] == '9000') {
          log("支付宝支付成功");
          BotToast.showText(text: '支付成功');
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              _pageNo = 1;
              _getData();
            });
          });

        } else if (payResult['resultStatus'] == '6001') {
          // if(mounted){
          //   Navigator.pop(context);
          // }
          BotToast.showText(text: '支付失败');
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("我的订单"),
        titleTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
        ),

      ),
      body: Container(
          color: const Color(0xFFFAFAFA),

          child: Stack(
            children: [
              Container(

                child:
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [

                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.only(left: 15,top: 16,right: 15),
                            height: 43.5,
                            alignment: Alignment.centerLeft,
                            child: Container(

                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  removeBottom: true,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      controller: _scrollController1,
                                      itemBuilder: (BuildContext context, int index) {
                                        return _buildTypeItem(context, index);
                                      },
                                      separatorBuilder: (BuildContext context, int index) {
                                        return Container(
                                          height: 0,
                                        );
                                      },
                                      itemCount: typenameList.length),
                                )),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    dataSource.length!=0?Expanded(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: ListView.separated(
                                controller: _scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildItem(context, index);
                                },
                                separatorBuilder: (BuildContext context, int index) {
                                  return Container(
                                    height: 15,
                                  );
                                },
                                itemCount: dataSource.length),
                          ),
                        ))
                    :Center(
                      child: Image(image: AssetImage('images/home_nodata.png')),
                    ),

                    const SizedBox(height: 30,)
                  ],
                ),
              ),
              // Positioned(
              //   right: 5,
              //   bottom: 23.5,
              //   child:  GestureDetector(
              //       onTap: (){
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (BuildContext ccontext) {
              //               return CreateActivityPage();
              //             }));
              //       },
              //       child:Container(
              //         width: 61,
              //         height: 61,
              //         child: Image(image:AssetImage('images/publishActivity.png'),),
              //       )),
              // )
            ],
          )
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // showTankuang();
        godetail(dataSource[index]);
      },
      child: dataSource.length>0?Container(
          padding: const EdgeInsets.only(left: 15,right: 15),
          decoration: const BoxDecoration(
            // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child:Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(top: 10,left: 10),
                  color: Colors.white,
                  child:  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text('订单号:'+dataSource[index]['no'],style: TextStyle(
                                color: Color(0xff333333),fontSize: 12,fontWeight: FontWeight.w500
                            ),),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(dataSource[index]['payStatus']==false&&dataSource[index]['status']!=40?'待支付':dataSource[index]['payStatus']==false&&dataSource[index]['status']==40?'已取消':'已支付',style: TextStyle(
                                color: Color(0xffFE7A24),fontSize: 15,fontWeight: FontWeight.bold
                            ),),
                          ),
                        ],
                      ),
                      SizedBox(height: 11,),
                      Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7.0), // 设置圆角的半径
                            child: Image(image: AssetImage(dataSource[index]['orderType']==1 ?'images/order/vipcard.png':'images/order/hongniangservice.png'),width: 114.5,height: 71,)
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataSource[index]['orderType']==1 ? '会员':dataSource[index]['orderType']==2 ?'超级推荐'
                                    :dataSource[index]['orderType']==3 ?'活动':'红娘服务',
                                    style: const TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5,),

                                  dataSource[index]['orderType']==1? Text(dataSource[index]['openContent']==null?'有效期：未知':'有效期：'+dataSource[index]['openContent'],
                                    style: const TextStyle(
                                        color: Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),
                                  ):Text('服务时间：'+dataSource[index]['openNum'].toString()+'个月',
                                    style: const TextStyle(
                                        color: Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),
                                  ),

                                  // dataSource[index]['orderType']==1? Text(dataSource[index]['memberEndTime']==null?'有效期至：未知':'有效期至：'+timestampToDateString(dataSource[index]['memberEndTime']),
                                  //   style: const TextStyle(
                                  //       color: Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),
                                  // ):Text('购买次数：'+dataSource[index]['openNum'].toString(),
                                  //   style: const TextStyle(
                                  //       color: Color(0xff666666),fontSize: 12,fontWeight: FontWeight.w500),
                                  // ),
                                  const SizedBox(height: 3,),
                                  Container(
                                      width: MediaQuery.of(context).size.width-40-114.5-20,
                                      margin: EdgeInsets.only(right: 0),
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text('¥'+dataSource[index]['payPrice'].toString(),textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Color(0xffF24C41),fontSize: 17,fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      )
                                  )

                                ],
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          // Container(
                          //   width: 52.5,
                          //   height: 52.5,
                          //   decoration: BoxDecoration(
                          //       color: Colors.yellow,
                          //       borderRadius: BorderRadius.all(Radius.circular(5))),
                          // )
                        ],
                      ),

                      Container(
                        padding: EdgeInsets.only(bottom: 10,top: 10),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //头像集合
                                Container(
                                  child: Image(image: AssetImage('images/order/date.png'),width: 9.5,height: 9.5,),
                                ),
                                SizedBox(width: 8.5,),
                                //多少人
                                Container(

                                  child: Text(
                                    timestampToDateString(dataSource[index]['createTime']),
                                    style: const TextStyle(color: Color(0xff999999), fontSize: 12,fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),

                            dataSource[index]['status']==40?Container(): Row(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    godetail(dataSource[index]);

                                  },
                                  child:  Container(
                                    alignment: Alignment.center,
                                    width: 68.5,
                                    height: 27.5,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(153, 153, 153, 0.4),
                                      borderRadius: BorderRadius.all(Radius.circular(13.75)),
                                    ),
                                    child:  const Text(
                                      '查看详情',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                dataSource[index]['payStatus']==false&&dataSource[index]['status']!=40?SizedBox(width: 17.5,):SizedBox(width: 0,),
                                dataSource[index]['payStatus']==false&&dataSource[index]['status']!=40?
                                    GestureDetector(
                                      onTap: (){
                                        vipOrder(dataSource[index]);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 68.5,
                                        height: 27.5,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffFE7A24),
                                          borderRadius: BorderRadius.all(Radius.circular(13.75)),
                                        ),
                                        child:  const Text(
                                          '去支付',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                :Container(),
                                SizedBox(width: 9.5,),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),

            ],
          )
      ):Container()
    );
  }


  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }


  godetail(infodic)async{
    if (infodic['status']==40){

    }else{
      log('infodicid===='+infodic['id'].toString());
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return MineOrderdetailPage(orderId: infodic['id'].toString(),);
          }));
      setState(() {
        _pageNo=1;
        _getData();
      });
    }
    //NewUserHomePage


  }



  Widget _buildTypeItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _pageNo = 1;
            typeSeletRow = index;
            _getData();
          });
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (BuildContext ccontext) {
          //       return MineOrderdetailPage();
          //     }));

          //评论详情

        },
        child: Container(

          // padding: EdgeInsets.all(10),
          // color: Colors.white,
          child:  Container(
              padding: const EdgeInsets.only(left: 10,right: 64.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    typenameList[index],
                    style: TextStyle(
                        color: typeSeletRow==index?const Color(0xff333333):const Color(0xff999999),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  typeSeletRow==index?Image.asset(
                    'images/myactivity_tip.png',
                    width: 24.5,
                    height: 8,
                  ):Container()
                ],
              )),
        )
    );
  }

  Future<void> _onRefresh() async {
    _pageNo = 1;
    _getData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });
      _pageNo++;
      _getData();
    }
  }

  ///获取数据
  void _getData() async {
    Map<String,dynamic> queryParameters = {};
    if (typeSeletRow==0){
      queryParameters = {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
      };
    }

    if (typeSeletRow==1){
      queryParameters = {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
        'payStatus':false
      };
    }

    if (typeSeletRow==2){
      queryParameters = {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
        'payStatus':true
      };
    }
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBlindTradeOrderPage, queryParameters: queryParameters, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印订单data'+data['list'].toString());
      isLoading = false;
      if (data!= null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
          } else {
            if (data['list'].length == 0) {
              EasyLoading.showToast('没有更多数据了');
            } else {
              dataSource.addAll(data['list']);
            }
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }
}
