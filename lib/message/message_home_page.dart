import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:xinxiangqin/mine/comment_detail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/utils/utils.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import '../mine/like_receive_page.dart';
import '../mine/comment_list_page.dart';
import '../tools/event_tools.dart';
import 'generateUserSig.dart';
import 'chat.dart';

class MessageHomePage extends StatefulWidget {
  const MessageHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MessageHomePageState();
  }
}

class MessageHomePageState extends State<MessageHomePage> {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  List dataSource = [];
  List superlikeList = [];
  Map<String, dynamic> userDic = {};
  int _pageNo = 1;
  bool loginStatus = false;
  TIMUIKitConversationController _UIKitConversationController = TIMUIKitConversationController();
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    // initChatInfo();
    _coreInstance.init(
        sdkAppID: 1600029298, // Replace 0 with the SDKAppID of your IM application when integrating
        // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
        loglevel: LogLevelEnum.V2TIM_LOG_ALL,
        onTUIKitCallbackListener:  (TIMCallback callbackValue){

          log('聊天错误'+callbackValue.infoRecommendText.toString());
        }, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
        listener: V2TimSDKListener());
    super.initState();
    _scrollController.addListener(_scrollListener);

    _getData();
    initChatInfo();
    getmineinfo();
    getunreadCount();
  }

  getunreadCount()async{
    //获取会话未读总数
    V2TimValueCallback<int> getTotalUnreadMessageCountRes =
        await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getTotalUnreadMessageCount();
    if (getTotalUnreadMessageCountRes.code == 0) {
      //拉取成功
      int? count = getTotalUnreadMessageCountRes.data;//会话未读总数
      if (count!>0){
        eventTools.emit('showMessageHave');
      }else{
        eventTools.emit('showMessageNo');
      }
      print('未读消息数量是'+count.toString());
    }
  }

  getmineinfo()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myInformation, queryParameters: {},
        successCallback: (data) async {
          if (mounted){ setState(() {
            if (data['commentMeFlag']==1||data['likeMeFlag']==1){
              eventTools.emit('showMinePointHave');
            }
            if (data['commentMeFlag']!=1&&data['likeMeFlag']!=1){
              eventTools.emit('showMinePointNo');
            }
          });}
        }, failedCallback: (data) {});
  }

  initChatInfo()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    String usersig = GenerateDevUsersigForTest(sdkappid: 1600029298, key: 'fdb5b8018dfda4cedc7eacd833d709cfca144ea2e614217a3652cef0873f9cfa').genSig(identifier: userId, expire: 86400);
    log('前端生成的'+usersig.toString());
    await _coreInstance.login(userID: userId,userSig: usersig
      // userSig: 'eJwtzEsLgkAYheH-MuuQcZobQqsiA61FGdTsyhmnjyzHK0X03zN1eZ4Xzgcl8cHrTIUCRDyMZsMGbZ4NZDBwW5uK5DClWt8vzoFGgc8xxkxyycZiXg4q0ztjjPRp1AYefxNzTCnlXEwvYPvnVKx9fMzb96a0oVqe7DVSe0kLW8bKrG7FLtNJGoVtd94u0PcHpycypw__'
    );
    setState(() {
      loginStatus = true;
    });

    getmySuperFavoriteList();
    getList();


    // getChat();
    // getList();
  }

  getmySuperFavoriteList()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.mySuperFavoriteList, queryParameters: {
      'userId': sharedPreferences.get('UserId').toString(),
    }, successCallback: (data) async {
      isLoading = false;
      log('我的超级喜欢列表'+data.toString());
      if (data != null) {
        setState(() {
          superlikeList = data;
        });

      }
    }, failedCallback: (data) {});
  }

  getList() async{
    //获取会话列表
    V2TimValueCallback<V2TimConversationResult> getConversationListRes =
        await TencentImSDKPlugin.v2TIMManager
        .getConversationManager()
        .getConversationList(
        count: 100, //分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
        nextSeq: "0"//分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
    );
    if (getConversationListRes.code == 0) {
      //拉取成功
      bool? isFinished = getConversationListRes.data?.isFinished;//是否拉取完
      String? nextSeq = getConversationListRes.data?.nextSeq;//后续分页拉取的游标
      List<V2TimConversation?>? conversationList =
          getConversationListRes.data?.conversationList;//此次拉取到的消息列表
      //如果没有拉取完，使用返回的nextSeq继续拉取直到isFinished为true
      if (!isFinished!) {
        V2TimValueCallback<V2TimConversationResult> nextConversationListRes =
            await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversationList(count: 100, nextSeq: nextSeq = "0");//使用返回的nextSeq继续拉取直到isFinished为true
      }

      getConversationListRes.data?.conversationList?.forEach((element) {
        element?.conversationID;//会话唯一 ID，如果是单聊，组成方式为 c2c_userID；如果是群聊，组成方式为 group_groupID。
        element?.draftText;//草稿信息
        element?.draftTimestamp;//草稿编辑时间，草稿设置的时候自动生成。
        element?.faceUrl;//会话展示头像，群聊头像：群头像；单聊头像：对方头像。
        element?.groupAtInfoList;//群会话 @ 信息列表，通常用于展示 “有人@我” 或 “@所有人” 这两种提醒状态。
        element?.groupID;//当前群聊 ID，如果会话类型为群聊，groupID 会存储当前群的群 ID，否则为 null。
        element?.groupType;//当前群聊类型，如果会话类型为群聊，groupType 为当前群类型，否则为 null。
        element?.isPinned;//会话是否置顶
        element?.lastMessage;//会话最后一条消息
        element?.orderkey;//会话排序字段
        element?.recvOpt;//消息接收选项
        element?.showName;//会话展示名称，群聊会话名称优先级：群名称 > 群 ID；单聊会话名称优先级：对方好友备注 > 对方昵称 > 对方的 userID。
        element?.type;//会话类型，分为 C2C（单聊）和 Group（群聊）。
        element?.unreadCount;//会话未读消息数，直播群（AVChatRoom）不支持未读计数，默认为 0。
        element?.userID;//对方用户 ID，如果会话类型为单聊，userID 会存储对方的用户 ID，否则为 null。
        if (element?.conversationID=='c2c_1'){
          log('444444444');
          _UIKitConversationController.pinConversation(conversationID: 'c2c_1', isPinned: true);
        }
      });
    }
  }

  getUserInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          log('用户信息身份type='+data['nickname'].toString());
          userDic = data;
          //sendKefuMessage(data);
        }, failedCallback: (data) {});
  }

  getChat()async{
    V2TimValueCallback<List<V2TimMessage>> getC2CHistoryMessageListRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .getC2CHistoryMessageList(
      userID: "1", // 单聊用户id
      count: 10, // 拉取数据数量
      lastMsgID: null, // 拉取起始消息id
    );
    if (getC2CHistoryMessageListRes.code == 0) {
      if (getC2CHistoryMessageListRes.toJson()['data'].length==0){
        getUserInfo();

      }else{

      }

      //拉取成功
    }
  }


  sendKefuMessage(data)async{
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
        await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: "你好,我是 "+data['nickname'].toString(), // 文本信息
    );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes =
          await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id!, // 创建的messageid
          receiver: "1", // 接收人id
          groupID: "", // 接收群组id
          priority: MessagePriorityEnum.V2TIM_PRIORITY_DEFAULT, // 消息优先级
          onlineUserOnly:
          false, // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
          isExcludedFromUnreadCount: false, // 发送消息是否计入会话未读数
          isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
          needReadReceipt:
          false, // 消息是否需要已读回执（只有 Group 消息有效，6.1 及以上版本支持，需要您购买旗舰版套餐）
          offlinePushInfo: OfflinePushInfo(), // 离线推送时携带的标题和内容
          cloudCustomData: "", // 消息云端数据，消息附带的额外的数据，存云端，消息的接收者可以访问到
          localCustomData:
          "" // 消息本地数据，消息附带的额外的数据，存本地，消息的接收者不可以访问到，App 卸载后数据丢失
      );
      if (sendMessageRes.code == 0) {
        // 发送成功
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("消息"),
        titleTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.w500),

      ),
      body: loginStatus==true?Container(
        color: Color(0xFFFAFAFA),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding:  EdgeInsets.only(top:15.5,left: 0,right: 0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: TIMUIKitConversation(
              // itemBuilder: ,
              controller: _UIKitConversationController,
              onTapItem: (selectedConv) async{
                // log('对话'+selectedConv.lastMessage!.sender.toString());
                // log('对话userid'+selectedConv.userID.toString());
                if (superlikeList.length==0){

                }else{
                  log('当前选中的用户id是'+selectedConv.userID.toString());
                  if (superlikeList.contains(selectedConv.userID.toString())){

                    V2TimValueCallback<List<V2TimMessage>> getC2CHistoryMessageListRes =
                    await TencentImSDKPlugin.v2TIMManager
                        .getMessageManager()
                        .getC2CHistoryMessageList(
                      userID: selectedConv.userID.toString(), // 单聊用户id
                      count: 10, // 拉取数据数量
                      lastMsgID: null, // 拉取起始消息id
                    );
                    if (getC2CHistoryMessageListRes.code == 0) {
                      log('获取到的该用户的历史聊天记录为'+getC2CHistoryMessageListRes.toJson()['data'].length.toString());
                      if (getC2CHistoryMessageListRes.toJson()['data'].length>1){


                      }else if (getC2CHistoryMessageListRes.toJson()['data'].length==0){

                      }
                      else{
                        if(selectedConv.lastMessage!.sender.toString()==selectedConv.userID.toString()){

                        }else{
                          BotToast.showText(text: '等待对方回复即可开启聊天');
                          return;
                        }
                      }

                      //拉取成功
                    }

                  }
                }

                // return;
                // 如果需要适配桌面端，此处需要参考 Demo 代码修改。
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        selectedConversation: selectedConv,
                      ),
                    ));
                getList();
                getunreadCount();
              },
            ),
          )

        // Column(
        //   children: [
        //   // GestureDetector(
        //   // behavior: HitTestBehavior.translucent,
        //   // onTap: () {
        //   //   Navigator.push(context, MaterialPageRoute(
        //   //       builder: (BuildContext ccontext) {
        //   //         return const CommentListPage();
        //   //       }));
        //   //
        //   // },child:Container(
        //   //     height: 70,
        //   //     padding: const EdgeInsets.all(15),
        //   //     decoration: const BoxDecoration(
        //   //         color: Colors.white,
        //   //         borderRadius: BorderRadius.all(Radius.circular(10))),
        //   //     child: Row(
        //   //       crossAxisAlignment: CrossAxisAlignment.start,
        //   //       children: [
        //   //        Image(image: AssetImage('images/system_message_icon.png',),width: 43,height: 43,),
        //   //         const SizedBox(
        //   //           width: 10,
        //   //         ),
        //   //         Expanded(
        //   //             child: Column(
        //   //               crossAxisAlignment: CrossAxisAlignment.start,
        //   //               children: [
        //   //                 Row(
        //   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   //                   children: [
        //   //                     Text(
        //   //                       '系统通知',
        //   //                       style: const TextStyle(
        //   //                           color: Color(0xff333333),
        //   //                           fontSize: 15,
        //   //                           fontWeight: FontWeight.bold),
        //   //                     ),
        //   //                     Text(
        //   //                       '13:22',
        //   //                       style: const TextStyle(color: Color(0xff999999), fontSize: 13),
        //   //                     ),
        //   //                   ],
        //   //                 ),
        //   //                 Text(
        //   //                   '暂无最新消息',
        //   //                   style: const TextStyle(color: Color(0xff999999), fontSize: 13),
        //   //                 ),
        //   //
        //   //               ],
        //   //             )),
        //   //
        //   //         // Container(
        //   //         //   width: 52.5,
        //   //         //   height: 52.5,
        //   //         //   decoration: BoxDecoration(
        //   //         //       color: Colors.yellow,
        //   //         //       borderRadius: BorderRadius.all(Radius.circular(5))),
        //   //         // )
        //   //       ],
        //   //     ),
        //   //   )),
        //     // const SizedBox(
        //     //   height: 10,
        //     // ),
        //
        //     // GestureDetector(
        //     //     behavior: HitTestBehavior.translucent,
        //     //     onTap: () {
        //     //       Navigator.push(context, MaterialPageRoute(
        //     //           builder: (BuildContext ccontext) {
        //     //             return const CommentListPage();
        //     //           }));
        //     //
        //     //     },child:Container(
        //     //   height: 70,
        //     //   padding: const EdgeInsets.all(15),
        //     //   decoration: const BoxDecoration(
        //     //       color: Colors.white,
        //     //       borderRadius: BorderRadius.all(Radius.circular(10))),
        //     //   child: Row(
        //     //     crossAxisAlignment: CrossAxisAlignment.start,
        //     //     children: [
        //     //       Image(image: AssetImage('images/system_message_icon.png',),width: 43,height: 43,),
        //     //       const SizedBox(
        //     //         width: 10,
        //     //       ),
        //     //       Expanded(
        //     //           child: Column(
        //     //             crossAxisAlignment: CrossAxisAlignment.start,
        //     //             children: [
        //     //               Row(
        //     //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     //                 children: [
        //     //                   Text(
        //     //                     '系统通知',
        //     //                     style: const TextStyle(
        //     //                         color: Color(0xff333333),
        //     //                         fontSize: 15,
        //     //                         fontWeight: FontWeight.bold),
        //     //                   ),
        //     //                   // Text(
        //     //                   //   '13:22',
        //     //                   //   style: const TextStyle(color: Color(0xff999999), fontSize: 13),
        //     //                   // ),
        //     //                 ],
        //     //               ),
        //     //               // Text(
        //     //               //   '暂无最新消息',
        //     //               //   style: const TextStyle(color: Color(0xff999999), fontSize: 13),
        //     //               // ),
        //     //
        //     //             ],
        //     //           )),
        //     //
        //     //       // Container(
        //     //       //   width: 52.5,
        //     //       //   height: 52.5,
        //     //       //   decoration: BoxDecoration(
        //     //       //       color: Colors.yellow,
        //     //       //       borderRadius: BorderRadius.all(Radius.circular(5))),
        //     //       // )
        //     //     ],
        //     //   ),
        //     // )),
        //
        //
        //
        //
        //   ],
        // ),
      ):Container(),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //评论详情
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return CommentDetailPage(
                dataDic: dataSource[index],
              );
            }));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataSource[index]['avatar'] != null
                ? ClipOval(
              child: NetImage(
                dataSource[index]['avatar'],
                width: 35,
                height: 35,
              ),
            )
                : Container(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataSource[index]['nickname'] ?? '',
                      style: const TextStyle(
                          color: Color(0xff333333),
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '评论了你的动态  ${Utils.formatTimeChatStamp(
                              dataSource[index]['commentTime'])}',
                      style: const TextStyle(color: Color(0xff999999), fontSize: 13),
                    ),
                    Text(
                      dataSource[index]['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xff333333), fontSize: 14),
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
      ),
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
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.commentList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      isLoading = false;
      if (data['list'] != null) {
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
      EasyLoading.dismiss();
    });
  }
  @override
  void dispose() {
    BotToast.closeAllLoading();
    EasyLoading.dismiss();
    super.dispose();
  }
}
