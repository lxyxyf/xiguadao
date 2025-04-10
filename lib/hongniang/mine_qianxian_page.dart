import 'dart:developer';
import 'package:intl/intl.dart';
// import 'package:bruno/bruno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/mine/chat_page.dart';
import 'package:xinxiangqin/mine/mine_rights_interests_dialog.dart';
import 'package:xinxiangqin/mine/set_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/tools/event_tools.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

class MineQianxianPage extends StatefulWidget {
  const MineQianxianPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MinePageState();
  }
}

class MinePageState extends State<MineQianxianPage> {
  Map<String, dynamic> serviceData = {};
  int selectRow = 0;
  List dataSource = [];
  bool isLoading = false;
  int _pageNo = 1;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getPointDetailPage();
  }


  ///获取我的服务
  void getPointDetailPage() async {
    Map<String, dynamic> dict = {};
    // dict['pageNo'] = _pageNo.toString();
    // dict['pageSize'] = '10';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    log('打印传值参数$dict');
    service.get(Apis.getMyServiceRecord, queryParameters: dict, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          serviceData = data;
          if (data['matchmakerStringingRespVOPageResult'] == null){

          }else{
            dataSource = data['matchmakerStringingRespVOPageResult']['list'];
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }


  chooseSeletRow(row){
    setState(() {
      _pageNo = 1;
      selectRow = row;
      getPointDetailPage();
    });
  }

  gochat(data){
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext ccontext) {
          return  ChatPage(userInfoDic: data);
        }));
  }

  sendKefuMessage(data)async{

    print('data[id].toString()'+data['nickname'].toString());
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: '你好，很高兴通过红娘认识你。期待我们能有个愉快的交流，看看未来会怎样。', // 文本信息
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
          receiver: data['id'].toString(), // 接收人id
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
      print('sendMessageRes.code'+sendMessageRes.code.toString());
      if (sendMessageRes.code == 0) {
        // 发送成功
        gochat(data);
      }else{

      }
    }
  }




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          width: screenSize.width,
          height: screenSize.height,
          // color: Colors.white,
          child: Stack(
            children: [

              // Container(
              //   width: screenSize.width,
              //   height: MediaQuery.of(context).padding.top,
              //   color: Color(0xffFE7A24),
              // ),

              Container(
                margin: EdgeInsets.only(top: 0),
                  // height: 175.5,
                  width: screenSize.width,
                  height: 180+MediaQuery.of(context).padding.top,
                  // margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(

                      image: DecorationImage(
                        image: AssetImage('images/hongniang/top.png'),
                        fit: BoxFit.cover,
                      )
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(top:20+MediaQuery.of(context).padding.top,left: 15),
                        // color: Colors.white,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child:  Row(
                            children: [
                              const Icon(Icons.arrow_back_ios,color: Colors.white,),

                              // const Text(
                              //   '积分明细',
                              //   style: TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 17,
                              //       fontWeight: FontWeight.bold),
                              // )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 26,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 15,),
                          Image(image: AssetImage('images/hongniang/myservice.png'),width: 98,height: 23.5,),
                          SizedBox(width: 5,),
                          const Text(
                            '快速了解服务明细',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          )

                        ],
                      ),


                      Container(

                        child: Container(
                          padding: EdgeInsets.only(top: 7,left: 30),
                          margin: EdgeInsets.only(left: 15,right: 15,top:20),
                          height: 62,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child:Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '我的红娘',
                                    style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 13),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 85.5),
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      '有效期',
                                      style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 13),
                                    ),
                                  )

                                ],
                              ),
                              SizedBox(height: 1.5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  serviceData['makerName']!=null?Row(
                                   children: [
                                     Text(
                                       serviceData['makerName'],
                                       style: TextStyle(
                                           color: Color(0xff333333),
                                           fontSize: 15,fontWeight: FontWeight.bold),
                                     ),
                                     SizedBox(width: 8.5,),
                                     GestureDetector(
                                       onTap: (){
                                         Map<String, dynamic> userInfoDic = {
                                           'id':serviceData['makerId'],
                                           'nickname':serviceData['makerName'],
                                         };
                                         Navigator.push(context, MaterialPageRoute(
                                             builder: (BuildContext ccontext) {
                                               return  ChatPage(userInfoDic: userInfoDic);
                                             }));
                                       },
                                       child: Container(
                                         alignment: Alignment.center,
                                         width: 54,
                                         height: 23,
                                         decoration: BoxDecoration(
                                             color: Color.fromRGBO(254, 122, 36, 0.09),
                                             borderRadius: BorderRadius.all(Radius.circular(11.5))
                                         ),
                                         child:  Text(
                                           textAlign: TextAlign.center,
                                           '聊天',
                                           style: TextStyle(
                                               color: Color(0xffFE7A24),
                                               fontSize: 14,fontWeight: FontWeight.normal),
                                         ),
                                       ),
                                     )
                                   ],
                                 ):Text(
                                    '等待平台分配中～',
                                    style: TextStyle(
                                        color: Color(0xff333333),
                                        fontSize: 15,fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 29.5),
                                    width: 95,
                                    child: Text(
                                      textAlign: TextAlign.left,
                                        serviceData['makerEndTime']!=null&&serviceData['makerEndTime'].toString()!=''?serviceData['makerEndTime']:'暂无',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 15,fontWeight: FontWeight.bold),
                                    ),
                                  )

                                ],
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  )
              ),





              Positioned(
                top: MediaQuery.of(context).padding.top+175.5,
                left: 0,right: 0,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 15,right: 15,top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          '服务明细',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 16,fontWeight: FontWeight.w500),
                        ),
                        margin: EdgeInsets.only(left: 10.5,right: 10.5,top: 15),
                      ),
                      Container(
                        color: Color.fromRGBO(238, 238, 238, 0.5),
                        margin: EdgeInsets.only(left: 10.5,right: 10.5,top: 15),
                        height: 0.5,
                      ),

                      serviceData['makerName']!=null?Container(
                        height: 85*6,
                        // margin: EdgeInsets.only(top: 0,bottom: 0),
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
                                    height: 0,
                                  );
                                },
                                itemCount:dataSource.length),
                          ),
                        ),
                      ):Container(
                        margin: EdgeInsets.only(left: 18.5,right: 18.5,top: 70.5),
                        child: Image(image: AssetImage('images/hongniang/nohongniang.png'),fit: BoxFit.fitWidth,),
                      )

                    ],
                  )
                )
              )

            ],
          ),
        )

    );
  }


  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // // showTankuang();
        // godetail(dataSource[index]);
      },
      child: dataSource.length!=0?Container(
          height: 83,
          margin: const EdgeInsets.only(left: 15,right: 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child:Column(

            children: [
              Container(
                padding: const EdgeInsets.only(top: 15.5),
                // color: Colors.white,
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text(dataSource[index]['activeId'].toString()==dataSource[index]['manId'].toString()?'牵线女方：':'牵线男方：',style: TextStyle(
                                  color: Color(0xff999999),fontSize: 14,fontWeight: FontWeight.normal
                              ),),
                            ),
                            dataSource[index]['avatar']==null?ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image(image: AssetImage('images/hongniang/usericon.png'),width: 32.5,height: 32,fit: BoxFit.cover,),
                            )
                            :ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image(image: NetworkImage(dataSource[index]['avatar']),width: 32.5,height: 32,fit: BoxFit.cover,),
                            ),
                            SizedBox(width: 8.5),
                            Text(dataSource[index]['activeId']==dataSource[index]['manId']?dataSource[index]['womanName']:dataSource[index]['manName'],style: TextStyle(
                                color: Color(0xff333333),fontSize: 15,fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                        SizedBox(height: 5,),


                        Container(
                          // padding: EdgeInsets.only(bottom: 20),
                            child:
                            Row(
                              children: [
                                Text(
                                  '牵线时间：',
                                  style: const TextStyle(color: Color(0xff999999), fontSize: 14,fontWeight: FontWeight.normal),
                                ),
                                Text(
                                  timestampToDateString(dataSource[index]['createTime']),
                                  style: const TextStyle(color: Color(0xff666666), fontSize: 11.5,fontWeight: FontWeight.normal),
                                ),
                              ],
                            )
                        ),



                      ],
                    ),

                    GestureDetector(
                      onTap: (){
                        Map<String, dynamic> userInfoDic = {
                          'id':dataSource[index]['activeId']==dataSource[index]['manId']?dataSource[index]['womanId']:dataSource[index]['manId'],
                          'nickname':dataSource[index]['activeId']==dataSource[index]['manId']?dataSource[index]['womanName']:dataSource[index]['manName'],
                        };
                        sendKefuMessage(userInfoDic);
                      },
                      child: Container(
                        width: 69.5,
                        height: 28,
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                            color: Color(0xffFE7A24),
                            borderRadius: BorderRadius.all(Radius.circular(14))
                        ),
                        child: Row(

                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 12.5),
                                child:
                                Image(image: AssetImage('images/hongniang/chat.png'),width: 12.5,height: 12.5,)
                            ),
                            SizedBox(width: 4,),

                            Text('聊天',style: TextStyle(
                                color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal
                            ),),
                          ],
                        ),
                      ),
                    )



                  ],
                ),


              ),
              Container(
                color: Color.fromRGBO(238, 238, 238, 0.5),
                margin: EdgeInsets.only(top: 10),
                height: 0.5,
              ),
            ],
          )
      ):Container(),
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


  Future<void> _onRefresh() async {
    setState(() {
      _pageNo=1;
    });
    /* 2秒后执行 */
    await Future.delayed(const Duration(milliseconds: 2000), () {
      getPointDetailPage();
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
