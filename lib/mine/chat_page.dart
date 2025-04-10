
import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tobias/tobias.dart';

import '../hongniang/hongniang_success_dialog.dart';
import '../message/generateUserSig.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../user/new_userinfo_page.dart';
import '../vipcenter/pay_paytype_dialog.dart';
import 'custommessage.dart';

class ChatPage extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  ChatPage({super.key,required this.userInfoDic});
  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<ChatPage> {
  String myUserid = '';
  String toUserid = '';
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  Map<String, dynamic> serviceData = {};
  String serviceId = '';
  String  servicePrice= '0';
  Tobias tobias = Tobias();
  Fluwx fluwx = Fluwx();
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
    initListener();
    getPointDetailPage();
  }

  ///获取我的服务
  void getPointDetailPage() async {
    Map<String, dynamic> dict = {};
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMyServiceRecord, queryParameters: dict, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
      if (data!= null) {
        setState(() {
          serviceData = data;
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }

  showPayType(){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return PayPaytypeDialog(
            price: servicePrice,
            Wepay: (){
              createWepayOrder();
            },
            Alipay: (){
              createAliOrder();
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
          showSuccessDialog();
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }else{
          BotToast.showText(text: '支付失败，请重新支付');
          // fluwx.removeSubscriber(listener);// 取消订阅消息
        }
      }
    };
    fluwx.addSubscriber(listener); // 订阅消息
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
    log('订单的id'+serviceId.toString());
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'mechanismId': serviceId.toString(),
      'terminal':1,
      'payway':'1',
      'deviceType':1
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
    log('订单的id'+serviceId.toString());
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.createBlindMakerOrder, data: {
      'mechanismId': serviceId.toString(),
      'terminal':1,
      'payway':'2',
      'deviceType':1
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
      var payResult = await tobias.pay(orderInfo.toString(),evn: AliPayEvn.sandbox);
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




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return TIMUIKitChat(
      config: TIMUIKitChatConfig(
          isShowReadingStatus:false
      ),
      messageItemBuilder: MessageItemBuilder(
          customMessageItemBuilder: (message, isShowJump, clearJump) {
            final customElem = message.customElem;
            // if (customElem!=null){
            //   log ('111111111111111111');
            //   log (customElem.data?? '');
            //   log ('2222222222');
            // }

            // final CustomMessage customMessage = getCustomMessageData(message.customElem);
            if (customElem != null) {
              Map<String, dynamic> messageDic = jsonDecode(customElem.data??'');
              if (messageDic['id']!=null){
                serviceId = messageDic['id']!=null?messageDic['id'].toString():'';
                servicePrice = messageDic['price'].toString();
              }
              log(messageDic.toString());
              log(messageDic['title']!=null?messageDic['title'].toString():'无数据');
              // final String option1 = customElem.link ?? "";
              return messageDic['businessID']!=null&&messageDic['businessID']=='order'?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(messageDic['title']!=null?messageDic['title'].toString():'无数据'),
                  GestureDetector(
                    onTap: (){
                      showPayType();
                    },
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xffEAEAEA),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      // width: 50,
                      // height: 50,
                      // padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messageDic['imageUrl']!=null?ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image(image: NetworkImage(messageDic['imageUrl']),width: 60,height: 60,fit: BoxFit.cover,),
                          ):Container(),
                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(messageDic['title']!=null?messageDic['title']:'',style: TextStyle(color:Color(0xff333333),fontSize: 14,fontWeight: FontWeight.w500),),
                              Text(messageDic['price']!=null?'¥'+messageDic['price'].toString():'',style: TextStyle(color:Color(0xffF24C41),fontSize: 14,fontWeight: FontWeight.bold),),
                              Text(messageDic['productDuration']!=null?'时长：'+messageDic['productDuration'].toString()+'个月':'',style: TextStyle(color:Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),

                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
                  :messageDic['businessID']!=null&&messageDic['businessID']=='user'
                  ?Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(messageDic['title']!=null?messageDic['title'].toString():'无数据'),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext ccontext) {
                            return  NewUserinfoPage(userId: messageDic['userId'].toString(),);
                          }));
                    },
                    child: Container(
                      width: 200,
                      padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xffEAEAEA),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // width: 50,
                      // height: 50,
                      // padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messageDic['avatar']!=null?Image(image: NetworkImage(messageDic['avatar']),width: 60,height: 60,fit: BoxFit.cover,):Container(),

                          SizedBox(width: 10,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(messageDic['nickname']!=null?messageDic['nickname']:'',style: TextStyle(color:Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold),),
                              Text(messageDic['sex']!=null&&messageDic['sex'].toString()=='1'?'男':'女',style: TextStyle(color:Color(0xffF24C41),fontSize: 12,fontWeight: FontWeight.w500),)
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
                  :Container(
                height: 30,
                child: Text('自定义消息'),
              );
            }
            return null;
          }
      ),
      onTapAvatar: (String userID, TapDownDetails tapDetails){
        if (userID == '1'){
          return;
        }

        if (userID == '11'){
          return;
        }

        if (userID == '12'){
          return;
        }

        if (serviceData['makerId']!=null){
          if (userID == serviceData['makerId'].toString()){
            return;
          }
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return NewUserinfoPage(userId: userID.toString(),);
            }));
      },
      controller: _chatController,
      // userAvatarBuilder: (BuildContext context, V2TimMessage message){
      //   return ClipRRect(
      //     borderRadius: BorderRadius.circular(20),
      //     child: Image(image: NetworkImage(message.faceUrl.toString()),width: 40,height: 40,fit: BoxFit.cover,),);
      // },

      conversation: V2TimConversation(
        conversationID: "c2c_${widget.userInfoDic['id']}", // 单聊："c2c_${对方的userID}" ； 群聊："group_${groupID}"
        userID: widget.userInfoDic['id'].toString(), // 仅单聊需要此字段，对方userID
        // groupID: "", // 仅群聊需要此字段，群groupID
        showName: widget.userInfoDic['nickname'], // 顶部 AppBar 显示的标题
        type: 1, // 单聊传1，群聊传2
        // 以上是最简化最基础的必要配置，您还可在此指定更多参数配置，根据 V2TimConversation 的注释
      ),
      // ......其他 TIMUIKitChat 的配置参数
    );
  }




}
