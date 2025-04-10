import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:xinxiangqin/activity/my_dialog_contact.dart';
import 'package:xinxiangqin/mine/mine_orderdetail_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/pages/login/zhanxingshi_login.dart';
import 'package:xinxiangqin/widgets/network_image_widget.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_tijiao_luyin.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_yitijiao_luyin.dart';

class XingzuoTaskList extends StatefulWidget {
  const XingzuoTaskList({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyActivityListPageState();
  }
}

class MyActivityListPageState extends State<XingzuoTaskList> {

  List dataSource = [];
  int _pageNo = 1;

  List typeList = [];
  List typenameList = ['待处理','已处理'];
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
    // final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    // _coreInstance.login(userID: 'user1li',
    //     userSig: 'eJyrVgrxCdYrSy1SslIy0jNQ0gHzM1NS80oy0zLBwqXFqUVGOZlQqeKU7MSCgswUJStDMwMDA1MLMwtTiExqRUFmUSpQ3NTU1AgoBREtycwFiZkbGxiZmhsbGkJNyUwHmhzo5pRZnFtm6elYFGWQEqPvHa5tmOPvFebqGxZk4OLokedflWOQb1JiUODtaqtUCwDCTDG0');
    _getData();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: const Text("我的订单"),
      //   titleTextStyle: const TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),
      //   leading: IconButton(
      //     color: Colors.black,
      //     icon: const Icon(Icons.arrow_back_ios_new),
      //     onPressed: () => Navigator.of(context).pop(), // 点击返回按钮返回上一页
      //   ),
      //
      // ),
      body: Container(
        width: screenSize.width,
          height: screenSize.height,
          color: const Color(0xFFFAFAFA),

          child: Stack(
            children: [
              Container(
                height: 280,
                child: Image(image: AssetImage('images/xingzuo/top.png'),width: screenSize.width,height: 280,fit: BoxFit.fill,),
              ),
              Positioned(
                top: 260,bottom: 30,
                left: 0,right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                     color: Color(0xfffafafa),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
                  ),
                  width: screenSize.width,
                  margin: EdgeInsets.only(top: 0,bottom: 0),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 50,

                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageNo = 1;
                                    typeSeletRow = 0;
                                    _getData();
                                  });
                                },
                                child: Container(
                                  child:  Container(
                                      padding: const EdgeInsets.only(left: 25.5,top: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '待处理',
                                            style: TextStyle(
                                                color: typeSeletRow==0?const Color(0xff333333):const Color(0xff999999),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                )
                            ),


                            //已处理
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageNo = 1;
                                    typeSeletRow = 1;
                                    _getData();
                                  });
                                },
                                child: Container(
                                  child:  Container(
                                      padding: const EdgeInsets.only(left: 41.5,top: 14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '已处理',
                                            style: TextStyle(
                                                color: typeSeletRow==1?const Color(0xff333333):const Color(0xff999999),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )),
                                )
                            )

                          ],
                        )
                        // color: Colors.black,
                      ),
                      
                      Positioned(
                        top: 50,
                        left: 0,
                        right: 0,
                        bottom: 0,
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
                      ),)
                    ],
                  ),
                )),


              Positioned(
                right: 18,
                bottom: 23.5,
                child:  GestureDetector(
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                      top: 15,
                                      bottom: 15),
                                  width:
                                  MediaQuery.of(context).size.width - 30,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '确认退出登录?',
                                        style: TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        height: 12.5,
                                      ),
                                      Container(
                                        height: 0.5,
                                        color: const Color(0xffEEEEEE),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          quitLogin();
                                        },
                                        child: const Text(
                                          '退出登录',
                                          style: TextStyle(
                                              color: Color(0xffD81E06),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width -
                                        30,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '取消',
                                      style: TextStyle(
                                          color: Color(0xff4794F4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                              ],
                            );
                          });
                    },
                    child:Container(
                      width: 45.5,
                      height: 45.5,
                      child: Image(image:AssetImage('images/xingzuo/logout.png'),),
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
          // showTankuang();
          dataSource[index]['status']==0?godetail(dataSource[index]):godetail1(dataSource[index]);
        },
        child: dataSource.length>0?Container(

            margin: const EdgeInsets.only(left: 15,right: 15),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child:Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 16.5,left: 10,bottom: 22.5),
                    child:  Column(
                      children: [
                        Row(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(64.5/2), // 设置圆角的半径
                                      child: dataSource[index]['avatar']!=null?Image(image: NetworkImage(dataSource[index]['avatar']),width: 64.5,height: 64.5,fit: BoxFit.cover,)
                                          :Container(
                                        width: 64.5,
                                        height: 64.5,
                                      )
                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 47.5,
                                      width: 16,
                                      height: 16,
                                      child: Image(image: AssetImage(dataSource[index]['sex']!=1?'images/xingzuo/man.png':'images/xingzuo/woman.png'),width: 16,height: 16,)
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    //右边第一行
                                    Row(
                                      children: [
                                        Text(
                                          dataSource[index]['nickname']!=null?dataSource[index]['nickname']:'',
                                          style: const TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 7,),
                                        Container(
                                          padding: EdgeInsets.only(left: 5,right: 5,top: 1.5,bottom: 1.5),
                                          decoration: BoxDecoration(
                                            color: Color(0xff35C234 ),
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                          ),
                                          child: Row(
                                            children: [
                                              Image(image: AssetImage('images/xingzuo/shiming.png'),width: 10,height: 11,),
                                              SizedBox(width: 2,),
                                              Text(
                                                dataSource[index]['haveReal']==1?'已实名':'未实名',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500),
                                              ),

                                            ],
                                          ),
                                        ),

                                        SizedBox(width: 4,),
                                        dataSource[index]['haveMember']==1?Image(image: AssetImage('images/xingzuo/vip.png'),width: 23,height: 21,):Container()

                                      ],
                                    ),


                                    SizedBox(height: 4,),
                                    //第二行
                                    Row(
                                      children: [
                                        Text(
                                          dataSource[index]['birthday']+'年',
                                          style: const TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 7,),

                                        Container(
                                          color: Color(0xffeeeeee),
                                          width: 0.5,
                                          height: 12,
                                        ),

                                        SizedBox(width: 7,),

                                        Text(
                                            dataSource[index]['lunarBirthday']!=null?dataSource[index]['lunarBirthday'].toString().substring(0,2)+'月'+dataSource[index]['lunarBirthday'].toString().substring(3,5)+'日':'未选择',
                                          style: const TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(width: 7,),

                                        Container(
                                          color: Color(0xffeeeeee),
                                          width: 0.5,
                                          height: 12,
                                        ),

                                        SizedBox(width: 7,),

                                        Text(
                                          dataSource[index]['birthTime'].toString().substring(0,2)+'时'+dataSource[index]['birthTime'].toString().substring(3,5)+'分',
                                          style: const TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),


                                    const SizedBox(height: 5,),

                                    //第三行
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 7,right: 7,top: 2,bottom: 2),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF6F5F8),
                                              borderRadius: BorderRadius.all(Radius.circular(9))
                                          ),
                                          child: Text('出生地：'+
                                            dataSource[index]['areaId'].toString(),
                                            style: const TextStyle(
                                                color: Color(0xff999999),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),

                                        SizedBox(width: 10,),

                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Container(
                                      padding: EdgeInsets.only(left:7,right: 7,top: 2,bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Color(0xffF6F5F8),
                                          borderRadius: BorderRadius.all(Radius.circular(9))
                                      ),
                                      child: Text('现居地：'+
                                        dataSource[index]['nativePlace'].toString(),
                                        style: const TextStyle(
                                            color: Color(0xff999999),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
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

                      ],
                    )
                ),

              ],
            )
        ):Container()
    );
  }


  ///退出登录
  void quitLogin() async {
    //删除本地数据
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('UserId');
    sharedPreferences.remove('AccessToken');
    sharedPreferences.remove('RefreshToken');

    //返回登录
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const ZhanxingshiLogin(),
      ),
          (route) => false,
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

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return ZChatVoiceBar(onRecorderEnd: (String? path, int? duration) {  },);
    //     }));
    //
    // return;

    //NewUserHomePage
    log('infodicid===='+infodic.toString());
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return XingzuoTijiaoLuyin(userInfoDic: infodic,onRecorderEnd: (String? path, int? duration) {  });
        }));
    setState(() {
      _pageNo=1;
      _getData();
    });

  }

  godetail1(infodic)async{

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext ccontext) {
    //       return ZChatVoiceBar(onRecorderEnd: (String? path, int? duration) {  },);
    //     }));
    //
    // return;

    //NewUserHomePage
    // log('infodicid===='+infodic.toString());
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return XingzuoYitijiaoLuyin(userInfoDic: infodic,onRecorderEnd: (String? path, int? duration) {  });
        }));


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
              padding: const EdgeInsets.only(left: 10,right: 30.5),
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
                  // typeSeletRow==index?Image.asset(
                  //   'images/myactivity_tip.png',
                  //   width: 24.5,
                  //   height: 8,
                  // ):Container()
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
        'status':'0'
      };
    }

    if (typeSeletRow==1){
      queryParameters = {
        'pageNo': _pageNo.toString(),
        'pageSize': '10',
        'status':'1'
      };
    }


    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    EasyLoading.show();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getConstellationTestPage, queryParameters: queryParameters, successCallback: (data) async {
      EasyLoading.dismiss();
      log('打印订单data'+data['list'].toString());
      isLoading = false;
      if (data!= null) {
        setState(() {
          if (_pageNo == 1) {
            dataSource = data['list'];
          } else {
            if (data.length == 0) {
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
