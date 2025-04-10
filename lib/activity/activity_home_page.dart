import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/activity/actitity_detai_jinxingzhong.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xinxiangqin/activity/activity_detai_fullbaoming.dart';
import 'package:xinxiangqin/activity/newactivity_detail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import '../home/noOpenVipDialog.dart';
import '../mine/face_verify.dart';
import '../tools/event_tools.dart';
import '../vipcenter/vipcenter_home.dart';
import 'activity_detail_baomingzhong.dart';
import 'activity_detail_end.dart';
import 'create_activity_page.dart';
import 'new_create_activity.dart';

class ActivityHomePage extends StatefulWidget {
  const ActivityHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ActivityHomePageState();
  }
}

class ActivityHomePageState extends State<ActivityHomePage> {
  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['全部','官方活动','个人活动'];
  int typeSeletRow = 0;
  int sexSeletRow = 0;


  String userSex = '';
  String userSexJoinNum = '';

  String searchText = '';
  String publishSetting = '1';

  bool isLoading = false;
  Map<String, dynamic> basicDic = {};
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
    getbasicData();
    getUserinfo();
    _getData();
    getunreadCount();
    // getactivityTypeList();
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



  getbasicData()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      setState(() {
        publishSetting = data['publish_setting'].toString();
        basicDic = data;
      });
    }, failedCallback: (data) {});
  }

  getUserinfo()async{

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          setState(() {
            String sexstr = data['sex'].toString();
            log('用户的性别是'+sexstr);
            if (sexstr == '1'){
              userSex = 'menNum';
              userSexJoinNum = 'registeredMenNum';
            }else{
              userSex = 'womenNum';
              userSexJoinNum = 'registeredWomenNum';
            }
          });
        }, failedCallback: (data) {});
  }

  sureUserInfo()async{

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
      if (publishSetting == '1'){
        //所有人
        if (data['haveNameAuth']!=1){
          showShimingDialog();
          return;
        }else{
          await  Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext ccontext) {
                return const NewCreateActivity();
              }));
          _pageNo = 1;
          _getData();
        }
      }else{
        if (data['userLevel']==0&&basicDic['virtualDisplay']==1){
          showDialog(
              context:context,
              builder:(context){
                return Noopenvipdialog(
                    content: '',
                    OntapCommit: ()async{
                      await  Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext ccontext) {
                            return  VipcenterHome();
                          }));
                      // sureUserInfo();
                    }

                );
              }
          );
          return;
        }else{
          if (data['haveNameAuth']!=1){
            showShimingDialog();
            return;
          }else{
            await  Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext ccontext) {
                  return const NewCreateActivity();
                }));
            _pageNo = 1;
            _getData();
          }
        }
      }

        }, failedCallback: (data) {});

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          // height: MediaQuery.of(context).padding.top + 103,
                          margin: EdgeInsets.only( top: MediaQuery.of(context).padding.top + 10,left: 15,right: 0,bottom: 0),
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          child: Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: Icon(Icons.arrow_back_ios),
                              // ),
                              const SizedBox(
                                width: 11,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 7.5),
                                child: const Text(
                                  '活动',
                                  style: TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              //搜索输入框
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0), // 设置圆角的半径
                                  child: Container(
                                      color: const Color.fromRGBO(250, 250, 250, 1),
                                      height: 32,
                                      padding: const EdgeInsets.only(left: 7.5),
                                      width: 300.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding:const EdgeInsets.only(left: 14),
                                            child: const Image(
                                                image: AssetImage("images/activity_search.png"),
                                                width: 11.5
                                            ),
                                          ),
                                          Expanded(

                                            child: Container(
                                              margin: const EdgeInsets.only(left:4),
                                              alignment: Alignment.centerLeft,
                                              child: TextField(

                                                onSubmitted: (value) {
                                                  // 用户完成输入后执行搜索
                                                  setState(() {
                                                    _pageNo==1;
                                                    searchText = value;
                                                    _getData();
                                                  });

                                                },
                                                controller: searchController,
                                                textAlignVertical: TextAlignVertical.center,
                                                decoration: InputDecoration(
                                                    hintText: '搜索活动',
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide.none
                                                    ),

                                                    hintStyle: TextStyle(
                                                        color:
                                                        const Color(0xff999999).withOpacity(1),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400)),
                                              ),
                                            ),
                                          )

                                        ],
                                      )
                                  )
                              ),


                            ],
                          ),
                        ),
                        
                        


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

                  typeSeletRow==2?Row(
                    children: [
                      SizedBox(width: 15),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            sexSeletRow=0;
                            _pageNo=1;
                            _getData();
                          });
                        },
                        child: Container(
                          width: 72.5,height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: sexSeletRow==0?Color.fromRGBO(254, 122, 36, 1):Color.fromRGBO(153, 153, 153, 0.12),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Text('男方发起',
                            style: TextStyle(color: sexSeletRow==0?Colors.white:Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
                        ),
                      ),

                      SizedBox(width: 18.5,),

                      GestureDetector(
                        onTap: (){
                          setState(() {
                            sexSeletRow=1;
                            _pageNo=1;
                            _getData();
                          });
                        },
                        child: Container(
                          width: 72.5,height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: sexSeletRow==1?Color.fromRGBO(254, 122, 36, 1):Color.fromRGBO(153, 153, 153, 0.12),
                              borderRadius: BorderRadius.all(Radius.circular(12))
                          ),
                          child: Text('女方发起',
                            style: TextStyle(color: sexSeletRow==1?Colors.white:Color(0xff999999),fontSize: 14,fontWeight: FontWeight.w500),),
                        ),
                      ),


                    ],
                  ):Container(),

                  typeSeletRow==2? SizedBox(
                    height: 12.5,
                  ):SizedBox(
                    height: 0,
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


            Positioned(
                  right: 5,
                  bottom: 23.5,
                  child:  GestureDetector(
                      onTap: () async{
                       sureUserInfo();
                      },
                      child:const SizedBox(
                    width: 61,
                    height: 61,
                    child: Image(image:AssetImage('images/publishActivity.png'),),
                  )),
            )
          ],
        )
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //活动列表

        // Map<String, dynamic> InfoDic = dataSource[index];
        // String statusStr = dataSource[index]['status'].toString();
        // pushPageCanyu(statusStr, InfoDic);

          if (dataSource[index]['isEnroll'] == false&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()==dataSource[index][userSexJoinNum].toString()){
            Map<String, dynamic> InfoDic1 = dataSource[index];
            String statusStr1 = dataSource[index]['status'].toString();
            pushPageCanyuFull(statusStr1, InfoDic1);
          }else{
            Map<String, dynamic> InfoDic = dataSource[index];
            String statusStr = dataSource[index]['status'].toString();
            pushPageCanyu(statusStr, InfoDic);
          }
      },
      child: Container(
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
                      // NetImage(
                      //   dataSource[index]['activeCover'],
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.cover,
                      // )

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            dataSource[index]['activeSource'].toString() =='1'
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // 设置圆角的半径
                              child: Image(image: NetworkImage(dataSource[index]['activeCover'])
                                  ,width: 100,height: 100,fit: BoxFit.cover),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // 设置圆角的半径
                              child: Image(image: NetworkImage(dataSource[index]['promoterAvatar'])
                                  ,width: 100,height: 100,fit: BoxFit.cover),
                            ),


                            Positioned(child:
                            Container(
                              alignment: Alignment.center,
                              width: 46.5,height: 18,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(51, 51, 51, 0.8),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                              ),
                              child:  Text(
                                dataSource[index]['statusName'],
                                style: const TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                              ),
                            ))
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataSource[index]['name'] ?? '',
                                  style: const TextStyle(
                                      color: Color(0xff333333),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 1.5,),
                                Row(
                                  children: [
                                    Container(
                                      width: 13.5,
                                      height: 13.5,
                                      margin: const EdgeInsets.only(right: 7.5),
                                      child:
                                      const Image(image: AssetImage('images/activity_type_icon.png'),),
                                    ),
                                    Text(

                                        dataSource[index]['costShare'].toString()=='1'?'AA制':'发起人全款',
                                    style: const TextStyle(color: Color(0xff999999), fontSize: 14,fontWeight: FontWeight.w500)
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 1.5,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 13.5,
                                      height: 13.5,
                                      margin: const EdgeInsets.only(right: 7.5,top: 4),
                                      child:
                                      const Image(image: AssetImage('images/activity_address_icon.png'),),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 100-25-25-7.5-24,
                                      child: Text(
                                          dataSource[index]['address'],
                                          style: const TextStyle(color: Color(0xff999999), fontSize: 14,fontWeight: FontWeight.w500)),
                                    )
                                  ],
                                ),

                                Container(
                                  margin: const EdgeInsets.only(top: 5.5),
                                  padding: const EdgeInsets.only(top: 7,bottom: 7,left: 9.5,right:12 ),
                                  decoration: const BoxDecoration(
                                      color: Color(0xffFAFAFA),
                                      borderRadius: BorderRadius.all(Radius.circular(13.25))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 13.5,
                                            height: 13.5,
                                            margin: const EdgeInsets.only(right: 7.5),
                                            child:
                                            const Image(image: AssetImage('images/activity_time_icon.png'),),
                                          ),
                                          Text(
                                              getFormattedDate(DateTime.parse(dataSource[index]['activeDate'].toString())),
                                              style: const TextStyle(color: Color(0xff333333), fontSize: 14,fontWeight: FontWeight.bold)

                                            // Utils.formatTimeChatStamp(
                                            //     dataSource[index]['commentTime']),
                                            // style: TextStyle(color: Color(0xff999999), fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Text(

                                        dataSource[index]['isEnroll'] == true&&dataSource[index]['status'] == 2?'已报名'
                                            : dataSource[index]['isEnroll'] == false&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()!=dataSource[index][userSexJoinNum].toString()?'等待报名':'',
                                        style: const TextStyle(color: Color(0xff999999), fontSize: 12,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
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
                    const SizedBox(height: 15,),
                    Container(
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              //头像集合
                              dataSource[index]['avatarList']!=null?SizedBox(
                                  width: dataSource[index]['avatarList'].length<=4?dataSource[index]['avatarList'].length.toDouble()*23:92,
                                  height: 23,
                                  child: MediaQuery.removePadding(
                                    context: context,
                                    removeTop: true,
                                    child: RefreshIndicator(
                                      onRefresh: _onRefresh,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          controller: _scrollController2,
                                          itemBuilder: (BuildContext context, int index1) {
                                            return _buildNumListItem(context, index1,index);
                                          },
                                          separatorBuilder: (BuildContext context, int index) {
                                            return Container(

                                            );
                                          },
                                          itemCount: dataSource[index]['avatarList'].length<=4?dataSource[index]['avatarList'].length:4),
                                    ),
                                  )):Container(),
                              const SizedBox(width: 3,),

                              //多少人
                              Text(
                                dataSource[index]['avatarList']!=null&&dataSource[index]['avatarList'].length!=0?'(${dataSource[index]['avatarList'].length}人已报名)':'暂未有人参与',
                                style: const TextStyle(color: Color(0xff999999), fontSize: 13),
                              ),
                            ],
                          ),

                          GestureDetector(
                            // onTap: (){
                            //   if (dataSource[index]['isEnroll'] == null&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()!=dataSource[index][userSexJoinNum].toString()){
                            //     entrolActivity(dataSource[index]['id'].toString());
                            //   }
                            //   if (dataSource[index]['isEnroll'] == null&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()==dataSource[index][userSexJoinNum].toString()){
                            //     Map<String, dynamic> InfoDic1 = dataSource[index];
                            //     String statusStr1 = dataSource[index]['status'].toString();
                            //     pushPageCanyuFull(statusStr1, InfoDic1);
                            //   }
                            //
                            // },
                            child: Container(
                              alignment: Alignment.center,
                              width: 97.5,
                              height: 29.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:dataSource[index]['isEnroll'] == false&&dataSource[index]['status'] == 2?const AssetImage('images/activity_status_back.png'):const AssetImage('images/manager_gray_status.png')),
                              ),
                              child:  Text(
                                dataSource[index]['isEnroll'] == true&&dataSource[index]['status'] == 2?'已报名'
                                    : dataSource[index]['isEnroll'] == false&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()!=dataSource[index][userSexJoinNum].toString()?'立即参与':
                                dataSource[index]['isEnroll'] == false&&dataSource[index]['status'] == 2&&dataSource[index][userSex].toString()==dataSource[index][userSexJoinNum].toString()?'查看详情':
                                dataSource[index]['status'] == 4?'已开始':dataSource[index]['statusName'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),

          ],
        )
      ),
    );
  }

  pushPageCanyuFull(statusStr,InfoDic)async{

    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getActivityPageInfo, queryParameters: {
      'id':InfoDic['id']
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      isLoading = false;
      InfoDic['activityAvatar'] = data['activityAvatar'];
      InfoDic['headName'] = data['headName'];
      InfoDic['promoterAvatar'] = data['promoterAvatar'];
      pushresultFull(statusStr,InfoDic);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });


  }

  pushresultFull(statusStr,InfoDic)async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ActivityDetailFullBaomingPage(
            userInfoDic: InfoDic,
          );
        }));
    _pageNo = 1;
    _getData();
  }

  pushPageCanyu(statusStr,InfoDic)async{

    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getActivityPageInfo, queryParameters: {
    'id':InfoDic['id']
    }, successCallback: (data) async {
    EasyLoading.dismiss();
    isLoading = false;
    log('某一个活动的信息$data');
    InfoDic['activityAvatar'] = data['activityAvatar'];
    InfoDic['headName'] = data['headName'];
    InfoDic['promoterAvatar'] = data['promoterAvatar'];
    pushresult(statusStr,InfoDic);
    }, failedCallback: (data) {
    EasyLoading.dismiss();
    });


  }

  pushresult(statusStr,InfoDic)async{
    // await Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return NewactivityDetailPage(
    //         userInfoDic: InfoDic,
    //       );
    //     }));
    // _pageNo = 1;
    // _getData();
    if (statusStr=='2'&&InfoDic[userSex].toString()!=InfoDic[userSexJoinNum].toString()){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ActivityDetailBaomingzhongPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='2'&&InfoDic[userSex].toString()==InfoDic[userSexJoinNum].toString()){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ActivityDetailFullBaomingPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='4'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ActivityDetailJinxingzhongPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='5'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ActivityDetailEndgPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }
  }





  Widget _buildTypeItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        typeSeletRow = index;
        //评论详情
       _getData();
      },
      child: Container(

        // padding: EdgeInsets.all(10),
        // color: Colors.white,
        child:  Container(
          padding: const EdgeInsets.only(left: 10,right: 30),
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

  //共多少人参与的列表
  Widget _buildNumListItem(BuildContext context, int index1,index) {
    return
      SizedBox(

        width: 23,
        height: 23,
        child:  Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              // 将溢出部分剪裁
              child: ClipOval(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1,
                  child: Image(image: NetworkImage(dataSource[index]['avatarList'][index1]),width: 23,height: 23,fit: BoxFit.cover,), //宽度设为原来宽度一半
                ),
              )
            ),
          ],
        ),
      )
    ;
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


  entrolActivity(id) async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          if (data['haveNameAuth']!=1){
            showShimingDialog();
            return;
          }else{
            sureEntrol(id);
          }

        }, failedCallback: (data) {});
  }

  sureEntrol(id)async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    Map<String, dynamic> map = {};
    log('传递的信息$id');
    map['activityId'] = id.toString();
    map['userId'] = userId;
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.entroActivity, data: map, successCallback: (data) async {
      EasyLoading.dismiss();
      log('正确信息$data');
      BotToast.showText(text: '报名成功');
      _onRefresh();

    }, failedCallback: (data) {
      EasyLoading.dismiss();
      log('错误信息$data');

    });
  }


  String getFormattedDate(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('MM月dd, EEEE');
    return fullYearFormat.format(date);
  }

  performSearch(value)async {

    EasyLoading.show();
    log('搜索的名字是$value');
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.activityList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
      'activityKind':typeList[typeSeletRow]['id'].toString(),
      'name':value.toString()
    }, successCallback: (data) async {
      EasyLoading.dismiss();

      isLoading = false;
      if (data['list']!=null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
            log('打印data1$dataSource');
          } else {
            if (data['list'].length == 0) {
              EasyLoading.showToast('没有更多数据了');
              log('打印data2$dataSource');
            } else {
              dataSource.addAll(data['list']);
              log('打印data3$dataSource');
            }
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
      EasyLoading.dismiss();
    });
  }

  ///获取数据
  void _getData() async {
    Map<String,dynamic> requestData = {
    };
    typeSeletRow==0? requestData={
      // 'activeSource' : 1,
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
      // 'headSex':'${sexSeletRow+1}',
      'name':searchText
    }:typeSeletRow==1?requestData={
      'activeSource' : '1',
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
      // 'headSex':'${sexSeletRow+1}',
      'name':searchText
    }:requestData={
      'activeSource' : '0',
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
      'headSex':'${sexSeletRow+1}',
      'name':searchText
    };

    log('传递的活动请求参数'+requestData.toString());

    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.activityList, queryParameters: requestData, successCallback: (data) async {
      EasyLoading.dismiss();

      isLoading = false;
      if (data['list']!=null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
            log('打印data1$dataSource');
          } else {
            if (data['list'].length == 0) {
              EasyLoading.showToast('没有更多数据了');
              log('打印data2$dataSource');
            } else {
              dataSource.addAll(data['list']);
              log('打印data3$dataSource');
            }
          }
        });
      }
    }, failedCallback: (data) {
      log('打印错误$data');
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
