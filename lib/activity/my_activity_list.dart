import 'dart:developer';

// import 'package:dd_js_util/dd_js_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/activity/activity_detail_baomingzhong.dart';
import 'package:xinxiangqin/activity/manager_activityclose_page.dart';
import 'package:xinxiangqin/activity/manager_activitydaishenhe_page.dart';
import 'package:xinxiangqin/activity/manager_activityend_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';

import '../home/noOpenVipDialog.dart';
import '../mine/face_verify.dart';
import '../vipcenter/vipcenter_home.dart';
import 'actitity_detai_jinxingzhong.dart';
import 'activity_detail_end.dart';
import 'manager_activitybaoming_page.dart';
import 'manager_activityjinxingzhong_page.dart';
import 'manager_activityyibohui_page.dart';
import 'new_create_activity.dart';

class MyActivityListPage extends StatefulWidget {
  const MyActivityListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<MyActivityListPage> {

  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['我参与的','我创建的'];
  int typeSeletRow = 0;

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的
  String publishSetting = '1';
  Map<String, dynamic> basicDic = {};
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // getactivityTypeList();
    getbasicData();
    _getData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("我的活动"),
        titleTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.w500),
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

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        //活动列表
        if (typeSeletRow == 1){
          Map<String, dynamic> InfoDic = dataSource[index];
          String statusStr = dataSource[index]['status'].toString();
          pushPage(statusStr,InfoDic);

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

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              dataSource[index]['activeSource'].toString() =='1'
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(10.0), // 设置圆角的半径
                                child: NetImage(
                                  dataSource[index]['activeCover'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : ClipRRect(
                                borderRadius: BorderRadius.circular(10.0), // 设置圆角的半径
                                child: NetImage(
                                  dataSource[index]['promoterAvatar'],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
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
                                        // Text(
                                        //
                                        //   dataSource[index]['statusName'],
                                        //   style: const TextStyle(color: Color(0xff999999), fontSize: 13),
                                        // ),
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

                                SizedBox(
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
                                    )),
                                const SizedBox(width: 3,),
                                //多少人
                                Text(
                                  dataSource[index]['avatarList']!=null&&dataSource[index]['avatarList'].length!=0?'(${dataSource[index]['avatarList'].length}人已报名)':'暂未有人参与',
                                  style: const TextStyle(color: Color(0xff999999), fontSize: 13),
                                ),
                              ],
                            ),

                            Container(
                              alignment: Alignment.center,
                              width: 97.5,
                              height: 29.5,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:AssetImage(typeSeletRow==0?'images/manager_gray_status.png':'images/activity_status_back.png')),
                              ),
                              child:  Text(
                                typeSeletRow==0?dataSource[index]['statusName']:'管理活动',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
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

  pushPage(statusStr,InfoDic)async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getActivityPageInfo, queryParameters: {
      'id':InfoDic['id']
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      isLoading = false;
      log('某一个活动的信息pushPage$data');
      InfoDic['activityAvatar'] = data['activityAvatar'];
      InfoDic['promoterAvatar'] = data['promoterAvatar'];
      InfoDic['headName'] = data['headName'];
      pushresult(statusStr,InfoDic);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });
  }

  pushPageCanyu(statusStr,InfoDic)async{
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getActivityPageInfo, queryParameters: {
      'id':InfoDic['id']
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      isLoading = false;
      log('某一个活动的信息pushPageCanyu$data');
      InfoDic['activityAvatar'] = data['activityAvatar'];
      InfoDic['headName'] = data['headName'];
      InfoDic['promoterAvatar'] = data['promoterAvatar'];
      pushresult1(statusStr,InfoDic);
    }, failedCallback: (data) {
      EasyLoading.dismiss();
    });
  }


  pushresult(statusStr,InfoDic)async {

    if (statusStr=='0'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityDaishenhePage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='2'||statusStr=='3'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='4'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityjinxingzhongPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='5'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityEndPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='6'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityYibohuiPage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='7'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityClosePage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }
  }

  pushresult1(statusStr,InfoDic)async {

    if (statusStr=='0'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityDaishenhePage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }

    if (statusStr=='2'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ActivityDetailBaomingzhongPage(
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

    if (statusStr=='7'){
      await Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return ManagerActivityClosePage(
              userInfoDic: InfoDic,
            );
          }));
      _pageNo = 1;
      _getData();
    }
  }


  String getFormattedDate(date){
    Intl.defaultLocale = 'zh';
    initializeDateFormatting();
    final DateFormat fullYearFormat = DateFormat('MM月dd, EEEE');
    return fullYearFormat.format(date);
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


  Widget _buildTypeItem(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _pageNo = 1;
            typeSeletRow = index;
            _getData();
          });

          //评论详情

        },
        child: Container(

          // padding: EdgeInsets.all(10),
          // color: Colors.white,
          child:  Container(
              padding: const EdgeInsets.only(left: 10,right: 10),
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

  // ///获取数据
  // void _getData() async {
  //   EasyLoading.show();
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.commentList, queryParameters: {
  //     'pageNo': '1',
  //     'pageSize': '10',
  //
  //   }, successCallback: (data) async {
  //     EasyLoading.dismiss();
  //     log('打印data'+data.toString());
  //     isLoading = false;
  //     if (data['list'] != null) {
  //       setState(() {
  //         if (_pageNo == 1) {
  //           dataSource = data['list'];
  //         } else {
  //           if (data['list'].length == 0) {
  //             EasyLoading.showToast('没有更多数据了');
  //           } else {
  //             dataSource.addAll(data['list']);
  //           }
  //         }
  //       });
  //     }
  //   }, failedCallback: (data) {
  //     log('打印错误'+data.toString());
  //     EasyLoading.dismiss();
  //   });
  // }

  ///获取数据
  void _getData() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.activityList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',

      'isHeader':typeSeletRow.toString(),

    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
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
      log('打印错误$data');
      EasyLoading.dismiss();
    });
   }
}
