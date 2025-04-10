
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/activity/manager_activitybaoming_page.dart';
import 'package:xinxiangqin/activity/manager_activityclose_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import '../mine/chat_page.dart';
import '../mine/face_verify.dart';
import '../widgets/network_image_widget.dart';



class ActivityDetailBaomingzhongPage extends StatefulWidget {
  Map<String, dynamic> userInfoDic;
  ActivityDetailBaomingzhongPage({super.key, required this.userInfoDic});
  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<ActivityDetailBaomingzhongPage> {
  List dataSource = [];
  final int _pageNo = 1;
  String userIdStr = '';
  List typeList = [];
  List typenameList = ['我参与的','我创建的'];
  int typeSeletRow = 0;
  String topImage = '';
  List<V2TimConversation?>? userConversationList = [];
  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    initUserId();

    super.initState();
    // _scrollController.addListener(_scrollListener);

  }

  getUserMessageList()async{
    print('11111111111');
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
      // if (!isFinished!) {
      //   V2TimValueCallback<V2TimConversationResult> nextConversationListRes =
      //   await TencentImSDKPlugin.v2TIMManager
      //       .getConversationManager()
      //       .getConversationList(count: 100, nextSeq: nextSeq = "0");//使用返回的nextSeq继续拉取直到isFinished为true
      // }

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
      });


        userConversationList = conversationList;
        if (conversationList != null){

          conversationList.forEach((element) {
            widget.userInfoDic['activityAvatar'].forEach((item) async {
              if (element?.userID.toString()==item['userId'].toString()){
                log('聊天会话userid'+element!.userID.toString()+'---'+item['userId'].toString());
                String? useridstr = element.conversationID.toString();
                log('聊天会话列表'+useridstr);
                // 删除本地及漫游消息
                V2TimCallback deleteConversationRes = await TencentImSDKPlugin.v2TIMManager
                    .getConversationManager()
                    .deleteConversation(
                  conversationID: useridstr,//需要删除的会话id
                );
                if (deleteConversationRes.code == 0) {
                  //删除成功
                  log('取消成功1');
                }else{
                  log('取消报名错误信息一'+deleteConversationRes.desc.toString());
                }

              }
            });
          });
      }
    }
  }

  initUserId()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    setState(() {
      userIdStr = share.getString('UserId') ?? '';
    });

  }

  refreshData()async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getActivityPageInfo, queryParameters: {
      'id':widget.userInfoDic['id']
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      isLoading = false;
      setState(() {
        widget.userInfoDic = data;
      });
      log('某一个活动的信息$data');
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });
  }


  String getFormattedDate(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('MM.dd');
    return fullYearFormat.format(date);
  }

  String getFormattedDate1(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('HH:mm');
    return fullYearFormat.format(date);
  }

  // getPageinfo()async{
  //   EasyLoading.show();
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.getActivityPageInfo, queryParameters: {
  //     'id':widget.userInfoDic['id']
  //   }, successCallback: (data) async {
  //     EasyLoading.dismiss();
  //     isLoading = false;
  //     setState(() {
  //       widget.userInfoDic['activityAvatar'] = data['activityAvatar'];
  //     });
  //    log('某一个活动的信息'+data.toString());
  //   }, failedCallback: (data) {
  //     EasyLoading.dismiss();
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("活动详情",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
        ),

      ),

      body: Container(
        width:MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          // color: const Color(0xFFFAFAFA),
            children:[
              Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 85,
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child:
                            Stack(
                              children: [
                                Container(

                                  height: 197.5,
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                  widget.userInfoDic['activeSource'].toString() =='1'
                                      ? NetImage(
                                    widget.userInfoDic['activeCover'],
                                    width: MediaQuery.of(context).size.width,
                                    height: 195,
                                  )
                                      : Image(image: AssetImage('images/activity/new_activitydetail_top.png')
                                    ,width: MediaQuery.of(context).size.width,height: 195,fit: BoxFit.fill,),
                                  // Image(image:NetworkImage(widget.userInfoDic['activeCover']),width: MediaQuery.of(context).size.width,fit: BoxFit.fill,)
                                ),
                                Positioned(
                                    top: 119.5,
                                    left: 0,right: 0,
                                    height: 60,
                                    child: Stack(
                                      children: [
                                        widget.userInfoDic['promoterAvatar']!=null?Positioned(
                                            child:
                                            Container(
                                                margin: EdgeInsets.only(left: 16),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                                    border: Border.all(width: 1,color: Colors.white)
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                                  child: Image(
                                                      image: NetworkImage(
                                                          widget.userInfoDic['promoterAvatar']),width: 45.1,height: 45.1,fit: BoxFit.cover
                                                  ),
                                                )
                                            )
                                        ):Container(),

                                        widget.userInfoDic['headSex']!=null?Positioned(
                                            child:
                                            Container(
                                              margin: EdgeInsets.only(left: 45.1),
                                              width: 14,height: 14.5,
                                              // decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.all(Radius.circular(45.1/2)),
                                              //     border: Border.all(width: 0.5,color: Colors.white)
                                              // ),
                                              child: Image(image:
                                              widget.userInfoDic['headSex'].toString()=='1'?const AssetImage('images/activity_man.png')
                                                  :const AssetImage('images/activity_woman.png'),),
                                            )
                                        ):Container(),

                                        widget.userInfoDic['headName']!=null?Positioned(
                                            child:
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(left: 67),
                                                    child: Text(widget.userInfoDic['headName'],
                                                      style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),)
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 50,height: 20,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.white,width:1,),
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    margin: EdgeInsets.only(left: 67),
                                                    child: Text('发起人',
                                                      style: TextStyle(color: Colors.white,fontSize: 11,fontWeight: FontWeight.bold),)
                                                )
                                              ],
                                            )
                                        ):Container()
                                      ],
                                    )
                                ),
                              ],
                            ),
                          ),



                          Container(

                              width: MediaQuery.of(context).size.width,
                              child:
                              Container(
                                padding: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.5),topRight: Radius.circular(10.5))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(left: 15,top: 13.5),
                                            alignment: Alignment.center,
                                            width: 62.5,height: 25.5,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(image: AssetImage('images/activity/activity_detail_status.png'))
                                            ),
                                            child: Text('${widget.userInfoDic['statusName']}',
                                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color(0xffFE7A24)),)
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width - 8.5-15-62.5-15,
                                          margin: EdgeInsets.only(left: 8.5,top: 11.5),
                                          child: Text('${widget.userInfoDic['name']}',
                                            style: TextStyle(fontSize: 17.5,fontWeight: FontWeight.w700,color: Color(0xff333333)),),
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 9.5,),
                                    widget.userInfoDic['activityAvatar']!=null?Container(
                                        height: widget.userInfoDic['isInitiator']==true&&widget.userInfoDic['isEnroll'] ==true&&widget.userInfoDic['activityAvatar'].length>1?85:55,
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: RefreshIndicator(
                                            onRefresh: _onRefresh,
                                            child: ListView.separated(
                                                scrollDirection: Axis.horizontal,
                                                controller: _scrollController,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return _buildTypeItem(context, index);
                                                },
                                                separatorBuilder: (BuildContext context, int index) {
                                                  return Container(

                                                  );
                                                },
                                                itemCount: widget.userInfoDic['activityAvatar'].length),
                                          ),
                                        )):Container(),



                                    Container(
                                        alignment: Alignment.topLeft,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(13.5),
                                          color:Colors.white,
                                        ),
                                        margin: const EdgeInsets.only(top: 0,left: 15,right: 15),
                                        padding: const EdgeInsets.only(bottom: 16.5),
                                        child: Container(
                                          child: Column(
                                            children: [


                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 14.5),
                                                    child: const Image(image: AssetImage('images/mymanager_time.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动时间：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text(
                                                      '${getFormattedDate(DateTime.parse(widget.userInfoDic['activeDate'].toString()))} ${getFormattedDate1(DateTime.parse(widget.userInfoDic['activeTimeBegin'].toString()))}~${getFormattedDate(DateTime.parse(widget.userInfoDic['activeTimeEnd'].toString()))} ${getFormattedDate1(DateTime.parse(widget.userInfoDic['activeTimeEnd'].toString()))}',style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 19.5),
                                                    child: const Image(image: AssetImage('images/manager_activity_address.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动地点：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    width: MediaQuery.of(context).size.width - 30 - 125,
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text(widget.userInfoDic['address'],style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),

                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 0,top: 15.5),
                                                    child: const Image(image: AssetImage('images/manager_activity_personnum.png'),width: 13.5,height: 13.5,),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                    child: const Text('活动人数：',style: TextStyle(
                                                        color:Color(0xff999999),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                  Container(
                                                    margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                    child: Text('${widget.userInfoDic['menNum']}男${widget.userInfoDic['womenNum']}女',style: const TextStyle(
                                                        color:Color(0xff333333),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w500
                                                    ),),
                                                  ),

                                                ],
                                              ),


                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 0,top: 15.5),
                                                        child: const Image(image: AssetImage('images/activity/pay_type.png'),width: 13.5,height: 13.5,),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 6.5,top: 15.5),
                                                        child: const Text('付款类型：',style: TextStyle(
                                                            color:Color(0xff999999),
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      ),

                                                      Container(
                                                        margin: const EdgeInsets.only(left: 23.5,top: 15.5),
                                                        child: Text(widget.userInfoDic['costShare'].toString()=='1'?'AA制':'发起人全款',style: const TextStyle(
                                                            color:Color(0xff333333),
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500
                                                        ),),
                                                      ),
                                                    ],
                                                  ),


                                                  Row(
                                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [

                                                      Container(
                                                        margin: const EdgeInsets.only(top: 15.5),
                                                        child: const Text('人均¥',style: TextStyle(
                                                            color:Color(0xffF62525),
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.bold
                                                        ),),
                                                      ),

                                                      Container(
                                                        margin: const EdgeInsets.only(right: 15,top: 13.5),
                                                        child: Text('${widget.userInfoDic['activeCost']}',style: const TextStyle(
                                                            color:Color(0xffF62525),
                                                            fontSize: 17.5,
                                                            fontWeight: FontWeight.bold
                                                        ),),
                                                      ),
                                                    ],
                                                  )

                                                ],
                                              ),

                                            ],
                                          ),
                                        )
                                    ),

                                    const SizedBox(height: 11,),


                                    Container(
                                      transformAlignment: Alignment.centerLeft,
                                      width:MediaQuery.of(context).size.width,
                                      height: 45,
                                      color: Color(0xFFFAFAFA),
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(left: 14.5,top: 15),
                                      child: const Text('活动详情',style: TextStyle(
                                          color:Color(0xff333333),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13.5),
                                        color:Colors.white,
                                      ),
                                      padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
                                      child: Container(
                                        child: Text(widget.userInfoDic['activeDesc'],style: const TextStyle(
                                            color:Color(0xff666666),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                    ),
                                  ],

                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  )),

              widget.userInfoDic['isInitiator']==true?
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child:Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: (){
                        widget.userInfoDic['status']==2?managerActivity():managerActivity1();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        margin: const EdgeInsets.only(bottom: 32,left: 25,right: 25,top: 17.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          color:const Color(0xffFE7A24),
                        ),
                        child: const Text('管理活动',textAlign: TextAlign.center,style: TextStyle(
                            color:Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    ),
                  )
              ):widget.userInfoDic['isEnroll'] ==true&&widget.userInfoDic['isInitiator']==false&&widget.userInfoDic['status']==2?
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child:Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(0),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 32,left: 25,right: 25,top: 17.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(

                            child: GestureDetector(
                              onTap: (){
                                closeActivity();//取消报名
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.5),
                                  color:Colors.white,
                                  border: Border.all(
                                    color: const Color(0xffFE7A24), // 边框颜色
                                    width: 0.5, // 边框宽度
                                  ),
                                ),
                                child: const Text('取消报名',textAlign: TextAlign.center,style: TextStyle(
                                    color:Color(0xffFE7A24),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ),
                          ),
                          const SizedBox(width: 19,),

                          widget.userInfoDic['activeSource'].toString()=='0'?Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Map<String, dynamic> userdic = widget.userInfoDic;
                                userdic['id'] = widget.userInfoDic['headUserId'];
                                userdic['nickname'] = widget.userInfoDic['headName'];
                                rightToChat(userdic);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.5),
                                  color:Color(0xffFE7A24),
                                ),
                                child: Text('与发起人聊天',textAlign: TextAlign.center,style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ),
                          ):Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Map<String, dynamic> userdic = widget.userInfoDic;
                                userdic['id'] = '1';
                                userdic['nickname'] = '平台客服';
                                rightToChat(userdic);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                margin: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.5),
                                  color:Color(0xffFE7A24),
                                ),
                                child: Text('平台客服',textAlign: TextAlign.center,style: TextStyle(
                                    color:Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              ):widget.userInfoDic['isEnroll'] ==false&&widget.userInfoDic['isInitiator']==false&&widget.userInfoDic['status']==2?
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child:
                Container(
                    color: Colors.white,
                    margin: EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: (){
                        rightBaoming();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 32,left: 25,right: 25,top: 17.5),
                        alignment: Alignment.center,
                        height: 45,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.5),
                          color:const Color(0xffFE7A24),
                        ),
                        child: const Text('立即报名',textAlign: TextAlign.center,style: TextStyle(
                            color:Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                        ),),
                      ),
                    )),
              ):Container()
            ]
        ),
      )






    );
  }

  managerActivity()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ManagerActivityPage(
            userInfoDic: widget.userInfoDic,
          );
        }));
    refreshData();
  }
  managerActivity1()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ManagerActivityClosePage(
            userInfoDic: widget.userInfoDic,
          );
        }));
    refreshData();
  }


  //跳转聊天
  rightToChat(userdic)async{

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ChatPage(userInfoDic: userdic,);
        }));

  }



  Widget _buildTypeItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          if (widget.userInfoDic['isInitiator']==true&&widget.userInfoDic['isEnroll']==true&&widget.userInfoDic['activityAvatar']![index]['userId'].toString()!=userIdStr){
            typeSeletRow = index;
            Map<String, dynamic> userdic = widget.userInfoDic;
            userdic['id'] = widget.userInfoDic['activityAvatar']![index]['userId'];
            userdic['nickname'] = widget.userInfoDic['activityAvatar']![index]['nickName'];
            rightToChat(userdic);
          }


        },
        child: Container(
          child:  Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                          child: SizedBox(
                              width: 45.1,
                              height: 45.1,
                              child: ClipOval(
                                child: Image(image: NetworkImage(widget.userInfoDic['activityAvatar']![index]['avatar']),width: 45.1,height: 45.1,fit: BoxFit.cover,),
                              )
                          )),

                      Positioned(
                        width: 12.5,
                        height: 12.5,
                        right: 0,
                        top: 0,
                        child: Image(image: widget.userInfoDic['activityAvatar']![index]['sex'].toString()=='1'?const AssetImage('images/activity_man.png'):const AssetImage('images/activity_woman.png'),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4,),
                  widget.userInfoDic['isInitiator']==true&&widget.userInfoDic['isEnroll']==true&&widget.userInfoDic['activityAvatar']![index]['userId'].toString()!=userIdStr
                      ?Container(
                    padding: EdgeInsets.only(top: 4.5,left: 7,right: 7,bottom: 4.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Color(0xffFE7A24), // 边框颜色
                        width: 0.5, // 边框宽度
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/activity_chat.png',
                          width: 8.5,
                          height: 8.5,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '聊天',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xffFE7A24),fontSize: 9,fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ):Container()
                ],
              )),
        )
    );
  }

  Future<void> _onRefresh() async {
    // _pageNo = 1;
    // _getData();
  }

  readyCancel()async{
    await getUserMessageList();
    cancelBaoming();
  }


  cancelBaoming()async{
    log('222222222');
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    // Map<String, dynamic> map = {};
    // map['activityId']= widget.userInfoDic['id'].toString();
    // map['userId']=userId;
    // log('传递的信息$map');
    // map['id'] = widget.userInfoDic['id'];
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.cancelEnrollActivity, queryParameters: {
        'userId':userId,
      'activityId':widget.userInfoDic['id'].toString()
      },successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '取消成功');
      Navigator.pop(context);

    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });

  }

  rightBaoming()async{

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          if (data['haveNameAuth']!=1){
            showShimingDialog();
            return;
          }else{
            surebaoming();
          }

        }, failedCallback: (data) {});
  }

  surebaoming()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    Map<String, dynamic> map = {};
    map['activityId'] = widget.userInfoDic['id'].toString();
    map['userId'] = userId;
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.entroActivity, data: map, successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '报名成功');
      Navigator.pop(context);

    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });
  }


  showShimingDialog()async{
    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '请先完成实名认证',
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 15,fontWeight: FontWeight.bold),
          ),
          content: const  Text(
            '实名认证信息仅用于身份核验，不会公开展示，我们将采取严格的技术措施保护您的个人信息安全',
            style: TextStyle(
                color: Color(0xff999999),
                fontSize: 13),
          ),
          actions: [
            TextButton(
              onPressed: () {
                //关闭弹窗
                Navigator.of(context).pop();
              },
              child: Text(
                '忽略',
                style: TextStyle(
                    color: Color(0xff4794F4),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async{
                //关闭弹窗
                Navigator.of(context).pop();
                rightNameAuth();
              },
              child: const Text("去认证", style: TextStyle(
                  color: Color(0xffFE7A24),
                  fontSize: 15,
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  //立即实名认证
  rightNameAuth()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const FaceVerify();
        }));
    // sureUserInfo();
  }

  //关闭活动
  closeActivity() async{

    showDialog(
      context: context,
      barrierDismissible: false, //点击弹窗以外背景是否取消弹窗
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("取消报名"),
          content: const Text("确定取消报名吗？"),
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
                readyCancel();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }

  ///获取数据
  void _getData() async {

  }
}
