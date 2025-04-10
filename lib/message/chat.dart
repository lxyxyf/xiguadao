import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_chat_controller.dart';
import 'package:tobias/tobias.dart';

import '../hongniang/hongniang_fuwudetail.dart';
import '../hongniang/hongniang_success_dialog.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../user/new_userinfo_page.dart';
import '../vipcenter/pay_paytype_dialog.dart';


class Chat extends StatefulWidget {
  final V2TimConversation selectedConversation;
  String? _getConvID() {
    return selectedConversation.type == 1
        ? selectedConversation.userID
        : selectedConversation.groupID;
  }

  Chat({Key? key, required this.selectedConversation}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}



class MyActivityListPageState extends State<Chat> {
  final TIMUIKitChatController _chatController = TIMUIKitChatController();
  String serviceId = '';
  String servicePrice = '';
  Tobias tobias = Tobias();
  Fluwx fluwx = Fluwx();
  Map<String, dynamic> serviceData = {};

  final FocusScopeNode focusScopeNode = FocusScopeNode();

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




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return
      TIMUIKitChat(

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
                return messageDic['businessID']!=null&&messageDic['businessID']=='order'
                    ?Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(messageDic['title']!=null?messageDic['title'].toString():'无数据'),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext ccontext) {
                              return  HongniangFuwudetail(serviceId: serviceId,);
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
                ):Container(
                  height: 30,
                  child: Text('自定义消息'),
                );
              }
              return null;
            }
        ),
        conversation: widget.selectedConversation,
        // userAvatarBuilder: (BuildContext context, V2TimMessage message){
        //   return ClipRRect(
        //     borderRadius: BorderRadius.circular(20),
        //     child: message.faceUrl.toString()!=''?Image(image: NetworkImage(message.faceUrl.toString()),width: 40,height: 40,fit: BoxFit.cover,):Container());
        // },
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
      );




  }

  @override
  void dispose() {
    super.dispose();
  }



}