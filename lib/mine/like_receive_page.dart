import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xinxiangqin/activity/my_dialog_contact.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/user/new_userinfo_page.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import '../mine/chat_page.dart';
import '../activity/my_dialog_page.dart';

class LikeReceivePage extends StatefulWidget {
  const LikeReceivePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<LikeReceivePage> {

  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['我收到的','我发出的'];
  int typeSeletRow = 0;

  String userAreaName = '';//只展示市

  int nowSelectPageRow = 0;//0选择的是我参与的，1选择是我创建的

  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    // final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    // _coreInstance.login(userID: 'user1li',
    //     userSig: 'eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwqXFqUVGOZlQqeKU7MSCgswUJStDMwMDA1MLMwtTiExqRUFmUSpQ3NTU1AgoBREtycwFiZkbGxiZmhsbGkJNyUwHmhzo5pRZnFtm6elYFGWQEqPvHa5tmOPvFebqGxZk4OLokedflWOQb1JiUODtaqtUCwDCTDG0');
    _getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("我想认识"),
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
                    Expanded(
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
                        )),

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
        nowSelectPageRow==0?showTankuang(dataSource[index]):godetail(dataSource[index]);


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
                          dataSource[index]['avatar'] != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(10.0), // 设置圆角的半径
                            child: NetImage(
                              dataSource[index]['avatar'],
                              width: 60,
                              height: 60,
                            ),
                          )
                              : Container(),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        dataSource[index]['nickname'] ?? '',
                                        style: const TextStyle(
                                            color: Color(0xff333333),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 5.5,),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(left: 5,right: 5.5,top: 2,bottom: 2.5),
                                        decoration: BoxDecoration(
                                          color: dataSource[index]['haveNameAuth'].toString()=='1'?const Color(0xff35C234):const Color(0xff999999),
                                          borderRadius: const BorderRadius.all(Radius.circular(2.5))
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Image(image: AssetImage('images/shiming_icon.png'),width: 10,height: 11,),
                                            const SizedBox(width: 2.5,),
                                            Text(dataSource[index]['haveNameAuth'].toString()=='1'?'已实名':'未实名',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 12),)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10,),

                                  Container(
                                    padding: const EdgeInsets.only(left: 9,top: 4.5,bottom: 5,right: 8.5),
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(238, 238, 238, 0.58),
                                        borderRadius: BorderRadius.all(Radius.circular(2.5))
                                    ),
                                    child: Row(
                                      children: [
                                        Text('${dataSource[index]['areaName']}•${dataSource[index]['age']}岁',style: const TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w500),)
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

                                //多少人
                                Container(
                                  padding: const EdgeInsets.only(bottom: 14.5),
                                  child: Text(
                                    '${dataSource[index]['photoNum']}张照片 | ${dataSource[index]['dynamicNum']}条动态',
                                    style: const TextStyle(color: Color(0xff999999), fontSize: 14,fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),

                           GestureDetector(
                             onTap: (){
                               nowSelectPageRow==0?showTankuang(dataSource[index]):godetail(dataSource[index]);
                             },
                             child:  Container(
                               alignment: Alignment.center,
                               width: 86,
                               height: 34.5,
                               decoration: const BoxDecoration(
                                 image: DecorationImage(
                                     fit: BoxFit.cover,
                                     image:AssetImage('images/likereceive_detail_icon.png')),
                               ),
                               child:  const Text(
                                 '查看详情',
                                 textAlign: TextAlign.center,
                                 style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
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

  showTankuang(datadic)async{

    setState(() {
      userAreaName = datadic['areaName'];
    });
    EasyLoading.show();

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userSearch, queryParameters: {"userId": datadic['issue']},
        successCallback: (data) async {
          EasyLoading.dismiss();
          log('用户主页$data');
         showUserInfoDialog(data,datadic);
        }, failedCallback: (data) {
          log('用户主页错误$data');
          EasyLoading.dismiss();
        });


  }

  showUserInfoDialog(data,datadic)async{
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => MyDialogContact(
              OntapCommit: (){
              Future.delayed(const Duration(seconds: 1), () {
                // 这里是一秒后需要执行的代码
                print('执行了一秒后的代码');
                showContactCreate(data);
              });
            },
              OntapUserDetail: (){
                Future.delayed(const Duration(seconds: 1), () {
                  // 这里是一秒后需要执行的代码
                  print('执行了一秒后的代码');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext ccontext) {
                        return NewUserinfoPage(userId: typeSeletRow==0?datadic['issue'].toString():datadic['receive'].toString(),);
                      }));
                });
              },
              areaName: userAreaName,
              userInfoDic: data,),
            fullscreenDialog: true));
    _pageNo = 1;
    _getData();

    // await Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return MyDialogContact(
    //         OntapCommit: (){
    //           Future.delayed(const Duration(seconds: 1), () {
    //
    //             // 这里是一秒后需要执行的代码
    //             print('执行了一秒后的代码');
    //             showContactCreate();
    //           });
    //
    //         },
    //         userInfoDic: data,
    //
    //       );
    //     }));
    // _pageNo = 1;
    // _getData();


  }

  showContactCreate(data){
    showDialog(
        context:context,
        builder:(context){
          return MyDialog(
             OntapCommit: (){
               Navigator.push(context,
                   MaterialPageRoute(builder: (BuildContext ccontext) {
                     return ChatPage(userInfoDic: data,);
                   }));
             }

          );
        }
    );
  }

  godetail(infodic){
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return UserInfoPage(userId: typeSeletRow==0?infodic['issue'].toString():infodic['receive'].toString(),);
    //     }));

    //NewUserHomePage
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return NewUserinfoPage(userId: typeSeletRow==0?infodic['issue'].toString():infodic['receive'].toString(),);
        }));
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
                    child: Image(image: NetworkImage(dataSource[index]['avatarList'][index1]),width: 23,height: 23,fit: BoxFit.fill,), //宽度设为原来宽度一半
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

  ///获取数据
  void _getData() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(typeSeletRow==0?Apis.getReceiveLikeList:Apis.getSendLikeList, queryParameters: {
      'pageNo': _pageNo.toString(),
      'pageSize': '10',
    }, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印data$data');
      isLoading = false;
      if (data!= null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data;
          } else {
            if (data.length == 0) {
              EasyLoading.showToast('没有更多数据了');
            } else {
              dataSource.addAll(data);
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
