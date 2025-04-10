
import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:fl_amap/fl_amap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/home/home_nodata_page.dart';
import 'package:xinxiangqin/home/home_showdialog_page.dart';
import '../home/tags_demo2.dart';
import '../home/tags_future_nochoose.dart';
import '../mine/chat_page.dart';
import '../mine/userinfo_change_page.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../pages/login/login_page.dart';
import '../shequ/post_detail_page.dart';
import '../post/user_report_page.dart';
import '../user/user_info_page.dart';
import '../widgets/yk_easy_loading_widget.dart';
import 'dart:developer';

class NewUserinfoPage extends StatefulWidget {
  final String userId;
  const NewUserinfoPage({super.key, required this.userId});


  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<NewUserinfoPage> {

  final ScrollController _scrollController = ScrollController();
  bool get wantKeepAlive => true;
  // 声明实例
  CityPickerUtil cityPickerUtils = CityPickers.utils();
  int selectRow = 0;
  List tagList = [

  ];

  List getMonthIncomeList = [
    '5万以下', '5万-10万','10万-20万','20万-50万'
  ];

  //星座标题列表
  final List<String> xingzuoTitleList = [
    '水瓶座','双鱼座','白羊座','金牛座','双子座','巨蟹座','狮子座','处女座','天秤座','天蝎座','射手座','摩羯座'
  ];
//星座图片列表
  final List<String> xingzuoUnselectImageList = [
    'images/xingzuo/shuiping_unselect.png','images/xingzuo/shuangyu_unselect.png','images/xingzuo/baiyang_unselect.png',
    'images/xingzuo/jinniu_unselect.png','images/xingzuo/shuangzi_unselect.png','images/xingzuo/juxie_unselect.png',
    'images/xingzuo/shizi_unselect.png','images/xingzuo/chunv_unselect.png','images/xingzuo/tianping_unselect.png',
    'images/xingzuo/tianxie_unselect.png','images/xingzuo/sheshou_unselect.png','images/xingzuo/mojie_unselect.png'

  ];

  final List<String> xingzuoSelectImageList = [
    'images/xingzuo/shuiping.png','images/xingzuo/shuangyu.png','images/xingzuo/baiyang.png',
    'images/xingzuo/jinniu.png','images/xingzuo/shuangzi.png','images/xingzuo/juxie.png',
    'images/xingzuo/shizi.png','images/xingzuo/chunv.png','images/xingzuo/tianping.png',
    'images/xingzuo/tianxie.png','images/xingzuo/sheshou.png','images/xingzuo/mojie.png'

  ];
  int hasNext = 1;
  double progress = 0;

  int lickclick = 0;

  List tagList2 = [
    // {'label': '水瓶座', 'select': false},
    // {'label': '天蝎座', 'select': false},
    // {'label': '狮子座', 'select': false},

  ];

  List tagListFuture = [];

  List imgs=[

  ];

  List ListData = [];
  List chooseItemArray = ['1'];
  List chooseImageArray = [];
  String backImageUrl = '';
  double _value = 40.0;
  Map userInfoDic = {};
  String myuserid = '';
  bool canLoadingSeeOther = true;

  double _emotionalValue =0; // 0.6表示偏右60%（感性）
  double _pursuitValue = 0; // 修改为0到1的范围
  double _iqValue = 0.5;
  double _eqValue = 0.5;
  bool positionShouquan = false;
  String juli = '';
  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  double mylatitude = 0;
  double mylongitude = 0;
  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getuserInfo();

    // getuserTuijian();
    // userinfochangeshowdialog();
  }

  void _scrollListener() async{
    if (_scrollController.position.pixels >0) {
      // _scrollController.removeListener(_scrollListener);
      //产生了滑动


    }

  }

  createBlindMemberSeeMe(data)async{

    // BotToast.showLoading();
    // _scrollController.removeListener(_scrollListener);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    NetWorkService service = await NetWorkService().init();
    log('我看过谁传递参数'+sharedPreferences.get('UserId').toString()+data['id'].toString());
    service.post(Apis.createBlindMemberSeeMe, data: {
      'issue': sharedPreferences.get('UserId').toString(),
      'receive': data['id'].toString(),
    }, successCallback: (data) async {
      log('我看过谁成功'+data.toString());
      // Future.delayed(const Duration(seconds: 1), () {
      //   BotToast.closeAllLoading();
      // });

    }, failedCallback: (data) {
      log('我看过谁失败'+data.toString());
      BotToast.closeAllLoading();
    });
  }

  userinfochangeshowdialog(content){
    showDialog(
        context:context,
        builder:(context){
          return HomeShowdialogPage(
              content: content,
              OntapCommit: ()async{
                await Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ccontext) {
                      return const UserinfoChangePage(

                      );
                    }));
                getuserInfo();
              }

          );
        }
    );
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final bool key = await setAMapKey(
        iosKey: 'd7b5cb7f36906a827392540b377da96b',
        androidKey: '73368d689ef463c33da954292bee4956');

    if (key != null && key)  print('高德地图ApiKey设置成功');
    requestLocationPermission();
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<void> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      final bool data = await FlAMapLocation().initialize();
      if (data) {
        print('初始化成功');
        getLocation();
      }
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        final bool data = await FlAMapLocation().initialize();
        if (data) {
          print('初始化成功');
          getLocation();
        }
      } else {
        BotToast.showText(text: '请前往设置开启定位权限');

      }
    }
  }


  Future<void> getLocation() async {
    BotToast.showLoading();
    /// 务必先初始化 并获取权限
    // if (getPermissions) return;
    AMapLocation? location = await FlAMapLocation().getLocation();
    if (_isAndroid) {
      AMapLocation is AMapLocationForAndroid;
    }
    if (_isIOS) {
      AMapLocation is AMapLocationForIOS;
    }

    if (location!=null){
      log('纬度${location.latitude}'+'经度${location.longitude}');
      saveLocation(location.latitude,location.longitude);
      setState(() {
        mylatitude = location.latitude!;
        mylongitude = location.longitude!;
      });
    }
  }

  saveLocation(latitude,longitude)async{

    log('获取双方的距离'+'${latitude},${longitude}');
    Map<String, dynamic> map = {};
    map['position'] = '${latitude},${longitude}';
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      getUsersLocation(latitude, longitude);
    }, failedCallback: (data) {

    });
  }

  getUsersLocation(latitude,longitude)async{
    if(userInfoDic['position'] == null||userInfoDic['position'].toString() ==''){
      setState(() {
        positionShouquan = true;
        juli = '距离未知';
      });
      BotToast.closeAllLoading();
      return;
    }else{

    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getDistance, queryParameters: {
      'latitude1': latitude,
      'longitude1': longitude,
      'latitude2': userInfoDic['position'].toString().split(',')[0],
      'longitude2': userInfoDic['position'].toString().split(',')[1],
    }, successCallback: (data) async {
      setState(() {
        positionShouquan = true;
        juli = '${double.parse(data.toStringAsFixed(2))}';
      });
      log('获取双方的距离'+data.toString());
      BotToast.closeAllLoading();
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }
  getuserInfo()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      myuserid = sharedPreferences.get('UserId').toString();
    });
    log('传入的userid是'+widget.userId.toString());

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userSearch, queryParameters: {
      'auditStatus': '1',
      'appType': '1',
      "userId": widget.userId,
    },
        successCallback: (data) async {
          setState(() {
            _emotionalValue = double.parse(data['disposition']!=null?data['disposition'].toString():'0'); // 0.6表示偏右60%（感性）
            _pursuitValue = double.parse(data['personPursuit']!=null?data['personPursuit'].toString():'0'); // 修改为0到1的范围
            _iqValue = double.parse(data['iqValue']!=null?data['iqValue'].toString():'0.5');
            _eqValue = double.parse(data['eqValue']!=null?data['eqValue'].toString():'0.5');
            log('打印首页用户信息$data');
            userInfoDic = data;
            initTagList();
          });
        }, failedCallback: (data) {

          log(data);
        });
  }


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
        builder: (context) => const LoginPage(),
      ),
          (route) => false,
    );
  }


  jubaoClick(){
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) {
          return UseReportPage(
            userName: userInfoDic[
            'nickname'],
          );
        },
        fullscreenDialog: true));
  }

  initTagList(){

    setState(() {
      if (userInfoDic['albumDOS'] == null){
        imgs = [];
      }else{
        imgs = userInfoDic['albumDOS'];
      }

      if (userInfoDic['memberUserTagRespVOS']==null){
        tagList2 = [];
      }else{
        tagList2 = userInfoDic['memberUserTagRespVOS'];
      }


      if (userInfoDic['expectedLabelDOS']==null){
        tagListFuture = [];
      }else{
        tagListFuture = userInfoDic['expectedLabelDOS'];
      }

      // backImageUrl = data['bgUrl'].toString();
      // chooseItemArray = data['memberUserTagRespVOS'];
      List newTagList = [];
      Map map1 = {};
      if (userInfoDic['getDistance'] == null||userInfoDic['getDistance'].toString() == 'null'){
        juli = '';
      }else{
        juli = userInfoDic['getDistance'];
      }
      String str1 = userInfoDic['height'].toString();
      String str2 = userInfoDic['weight'].toString();
      map1['label'] = '${str1}cm/${str2}kg';
      newTagList.add(map1);

      String str3 = userInfoDic['marriageName'].toString();
      Map map2 = {};
      map2['label'] = str3;
      newTagList.add(map2);

      String str4 = userInfoDic['educationName'].toString();
      Map map3 = {};
      map3['label'] = str4;
      newTagList.add(map3);

      String str5 = getMonthIncomeList[int.parse(userInfoDic['monthIncome'].toString())];
      Map map4 = {};
      map4['label'] = str5;
      newTagList.add(map4);

      String str6 = userInfoDic['career'].toString();
      Map map5 = {};
      map5['label'] = '从事$str6';
      newTagList.add(map5);

      String str7 = userInfoDic['areaName'].toString();
      Map map6 = {};
      map6['label'] = str7;
      newTagList.add(map6);

      String str8 = userInfoDic['graduatFrom'].toString();
      Map map7 = {};
      map7['label'] = str8;
      newTagList.add(map7);

      //抽烟
      String str9 = userInfoDic['smokerName'].toString();
      Map map8 = {};
      map8['label'] = str9;
      newTagList.add(map8);

      //喝酒
      String str10 = userInfoDic['drinkName'].toString();
      Map map9 = {};
      map9['label'] = str10;
      newTagList.add(map9);

      print(newTagList);
      print('就大姐大姐家大姐大姐dkdkkddkkdk');
      tagList = newTagList;
    });
    // createBlindMemberSeeMe(userInfoDic);

  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      color: Color(0xffF3F5F9),
      width: screenSize.width,
      height: screenSize.height,
      child:Stack(
        children: [
          Positioned(
              left:0,right: 0,
              height: 480.5,
              child: Image(image: AssetImage('images/home/hometop.png'),fit: BoxFit.fill,)
          ),
          // Positioned(
          //   top: MediaQuery.of(context).padding.top,
          //   left: 15,
          //   child:Text('西瓜岛',style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
          // ),

          Positioned(
            left: 15,
            top: MediaQuery.of(context).padding.top,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:  Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Color(0xff333333),
                    ),
                    Text(userInfoDic['nickname']!=null?userInfoDic['nickname'].toString():'',style: TextStyle(color: Color(0xff333333),fontSize: 17,fontWeight: FontWeight.bold),)
                  ],
                )
            ),
          ),




          Positioned(
            // color: Colors.white,
            left: 15,right: 15,bottom: MediaQuery.of(context).padding.bottom,top: MediaQuery.of(context).padding.top+40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                // height: screenSize.height-MediaQuery.of(context).padding.top-40-100,
                padding: EdgeInsets.only(bottom: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // color: Colors.white
                ),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),

                          ),
                          child: Column(
                            children: [

                              Column(
                                children: [
                                  // userInfoDic['bgUrl']==null?
                                  Stack(
                                    children: [


                                      userInfoDic['avatar'].toString()!=''?Container(
                                        margin: EdgeInsets.only(top: 0),
                                        height: screenSize.height - MediaQuery.of(context).padding.top-40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          ),
                                          image: DecorationImage(
                                              image: NetworkImage( userInfoDic['avatar'].toString()),fit: BoxFit.cover),
                                        ),
                                      ):Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25),
                                          ),
                                          color: Colors.yellow,
                                        ),
                                        margin: EdgeInsets.only(left: 15,right: 15,top: MediaQuery.of(context).padding.top+40),
                                        height: screenSize.height - MediaQuery.of(context).padding.top-40,

                                      ),

                                      Positioned(
                                          left: 10,
                                          top: 10,
                                          child: positionShouquan==true?Container(
                                        margin: EdgeInsets.only(top: 5,right: 10),
                                        padding: EdgeInsets.only(top: 3,bottom: 3,left: 4.5,right: 7),
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(0, 0, 0, 0.25),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(18)
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image(image: AssetImage('images/home/location.png',),width:13 ,height: 13,),
                                            SizedBox(width: 3,),
                                            Text(

                                              juli!=''&&juli!='距离未知'&&juli!='null'&&positionShouquan==true?'距你'+juli+'km':'距离未知',
                                              style: const TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                                            ),
                                            // const Text(
                                            //   '岁',
                                            //   style: TextStyle(color: Colors.white, fontSize: 16),
                                            // ),
                                          ],
                                        ),)
                                          :GestureDetector(
                                        onTap: (){
                                          main();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 5,right: 10),
                                          padding: EdgeInsets.only(top: 3,bottom: 3,left: 4.5,right: 7),
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(0, 0, 0, 0.25),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18)
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Image(image: AssetImage('images/home/location.png',),width:13 ,height: 13,),
                                              SizedBox(width: 3,),
                                              Text(

                                                '查看你们的距离',
                                                style: const TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                                              ),
                                              // const Text(
                                              //   '岁',
                                              //   style: TextStyle(color: Colors.white, fontSize: 16),
                                              // ),
                                            ],
                                          ),),
                                      )
                                      ),

                                      Positioned(
                                          left: 10,
                                          bottom: 10,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        userInfoDic['nickname'].toString()+' '+'${userInfoDic['age']}',
                                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // width: 100,
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Image(image: AssetImage('images/home/career.png',),width:13 ,height: 13,),
                                                          SizedBox(width: 7),
                                                          Text(
                                                            userInfoDic['career']==null||userInfoDic['career'].toString()==''?'职业未知':userInfoDic['career'],
                                                            style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                                                          ),
                                                          // const Text(
                                                          //   '岁',
                                                          //   style: TextStyle(color: Colors.white, fontSize: 16),
                                                          // ),
                                                        ],
                                                      ),)
                                                ),

                                                Container(
                                                  // width: 100,
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Image(image: AssetImage('images/home/jinniuzuo.png',),width:13 ,height: 13,),
                                                          SizedBox(width: 7),
                                                          Text(
                                                            userInfoDic['constellation']==null||userInfoDic['constellation'].toString()==''?'星座未知':xingzuoTitleList[int.parse(userInfoDic['constellation'].toString())],
                                                            style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                                                          ),
                                                          // const Text(
                                                          //   '岁',
                                                          //   style: TextStyle(color: Colors.white, fontSize: 16),
                                                          // ),
                                                        ],
                                                      ),)
                                                ),
                                              ],
                                            ),
                                          )),



                                      Positioned(
                                          right: 0,
                                          bottom: 10,
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [





                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                  Container(
                                    width: screenSize.width,
                                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 10,left: 10),
                                          child: const Text(
                                            "基本资料",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10, top: 15.5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/height.png'),width: 10.5,height: 14,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[0]!=null?tagList[0]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(left: 16.5),
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/hunyin.png'),width: 14.5,height: 12,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[1]!=null?tagList[1]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),


                                        Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(left: 16),
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/home_smoke.png'),width: 23.5,height: 13,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[7]!=null?tagList[7]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 12.5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,

                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/home_drink.png'),width: 12.5,height: 14,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[8]!=null?tagList[8]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.only(left: 16),
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/xueli.png'),width: 14,height: 12,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[2]!=null?tagList[2]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )


                                        ),





                                      ],
                                    ),
                                    Container(
                                      height: 12.5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/gongzuo.png'),width: 13,height: 12.5,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[4]!=null?tagList[4]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),


                                      ],
                                    ),
                                    Container(
                                      height: 12.5,
                                    ),

                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,

                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/income.png'),width: 12,height: 13,),
                                                SizedBox(width: 4,),
                                                Text("年收入"+(tagList.isNotEmpty&&tagList[3]!=null?tagList[3]["label"]:""),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )


                                        ),
                                      ],
                                    ),

                                    Container(
                                      height: 12.5,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            decoration: const BoxDecoration(
                                              color: Color.fromRGBO(226, 225, 223, 0.28),
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),

                                            child: Row(
                                              children: [
                                                Image(image: AssetImage('images/home/address.png'),width: 14.5,height: 12.5,),
                                                SizedBox(width: 4,),
                                                Text(tagList.isNotEmpty&&tagList[5]!=null?tagList[5]["label"]:"",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xff333333),
                                                      fontSize: 14,
                                                    ),
                                                    softWrap: true),
                                              ],
                                            )
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              imgs.isNotEmpty?Container(
                                margin: const EdgeInsets.only(top: 17.5),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][0]['url']),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),
                              imgs.length>=6?Container(
                                margin: const EdgeInsets.only(top: 9.5),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][5]['url']),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),

                              Container(
                                margin: const EdgeInsets.only(top: 16,left: 10.5),
                                child: Row(
                                  children: [

                                    Container(
                                      child: const Text(
                                        "个性标签",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              tagList2.isNotEmpty?Container(
                                margin: const EdgeInsets.only(left: 10, top: 15.5),
                                child: SelectTag2(
                                  tagList: tagList2,
                                  isSingle: false,
                                ),
                              ):Container(),
                              imgs.length>=2?Container(
                                margin: const EdgeInsets.only(top: 16),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][1]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),
                              imgs.length>=7?Container(
                                margin: const EdgeInsets.only(top: 9.5),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][6]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),


                              Container(
                                height: 350,
                                alignment: Alignment.topLeft,
                                margin:  EdgeInsets.only(left: 0,top: 11.5,right: 0,bottom: 23.5),
                                // decoration: const BoxDecoration(
                                //   color: Colors.white,
                                //   borderRadius: BorderRadius.all(
                                //       Radius.circular(10)),
                                // ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 9.5,right: 9.5,top: 9.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '情感偏向',
                                        style: TextStyle(
                                            fontSize: 18,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildBiDirectionalSlider(
                                        leftLabel: '${_calculatePercentage(_emotionalValue, true)}%\n理性',
                                        rightLabel:
                                        '${_calculatePercentage(_emotionalValue, false)}%\n感性',
                                        value: _emotionalValue,
                                        leftColor: Color(0xff4078FE),
                                        rightColor: Color(0xffFE7A24),
                                      ),
                                      const SizedBox(height: 19.5),
                                      const Text(
                                        '个人追求',
                                        style: TextStyle(
                                            fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildBiDirectionalSlider(
                                        leftLabel: '${_calculatePercentage(_pursuitValue, true)}%\n理想',
                                        rightLabel: '${_calculatePercentage(_pursuitValue, false)}%\n现实',
                                        value: _pursuitValue,
                                        leftColor: Color(0xff4078FE),
                                        rightColor: Color(0xffFE7A24),


                                      ),
                                      const SizedBox(height: 19.5),
                                      const Text(
                                        'IQ',
                                        style: TextStyle(
                                            fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildProgressBar(
                                        leftLabel: '低级',
                                        rightLabel: '高级',
                                        value: _iqValue,
                                        color: Color(0xffFFB700),
                                        centerLabel: '中级',
                                      ),
                                      const SizedBox(height: 19.5),
                                      const Text(
                                        'EQ',
                                        style: TextStyle(
                                            fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      _buildProgressBar(
                                        leftLabel: '低级',
                                        rightLabel: '高级',
                                        value: _eqValue,
                                        color: Color(0xffF77595),
                                        centerLabel: '高级',
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              imgs.length>=3?Container(
                                margin: const EdgeInsets.only(top: 17),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][2]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),

                              imgs.length>=8?Container(
                                margin: const EdgeInsets.only(top: 9.5),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][7]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),

                              Container(
                                margin: const EdgeInsets.only(top: 15,left: 10),
                                child: Row(
                                  children: [

                                    Container(
                                      child: const Text(
                                        "内心独白",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 10.5,right: 10.5, top: 16),
                                child: Text(
                                  userInfoDic['aboutMe']==null?'':userInfoDic['aboutMe'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333333),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              imgs.length>=4?Container(
                                margin: const EdgeInsets.only(top: 17),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][3]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),





                              Container(
                                margin: const EdgeInsets.only(top: 15,left: 9.5),
                                child: Row(
                                  children: [

                                    Container(
                                      child: const Text(
                                        "对另一半期望",
                                        style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              tagListFuture.isNotEmpty?Container(
                                margin: const EdgeInsets.only(left: 10, top: 15.5),
                                child: TagsFutureNochoose(
                                  tagList: tagListFuture,
                                  isSingle: false,
                                ),
                              ):Container(),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(left: 10.5,right: 10.5, top: 16),
                                child: Text(
                                  userInfoDic['partnerWish']==null?'':userInfoDic['partnerWish'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff333333),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              imgs.length>=5?Container(
                                margin: const EdgeInsets.only(top: 17.5),
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [

                                    Container(
                                      width: screenSize.width-30,
                                      height: screenSize.width-30,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, 0.6),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image(
                                        image: NetworkImage(
                                            userInfoDic['albumDOS'][4]['url'] ?? ""),
                                        width: screenSize.width-30,
                                        height: screenSize.width-30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(),


                              Container(
                                margin: const EdgeInsets.only(top: 30,right: 10,left: 10.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [

                                        Container(
                                          child: const Text(
                                            "动态",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext ccontext) {
                                              return UserInfoPage(userId: userInfoDic['id'].toString(),);
                                            }));
                                      },
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 0.0,right: 0),
                                            child: const Text(
                                              "查看更多动态",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff999999),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Color.fromRGBO(171, 171, 171, 1.0),
                                          )





                                        ],
                                      ) ,
                                    ),


                                  ],
                                ),
                              ),
                              userInfoDic['blindMemberMomentDOList']!=null?Container(
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 10.5,top: 16,right: 10.5),
                                      alignment: Alignment.topLeft,
                                      child: Text(userInfoDic['blindMemberMomentDOList'].length!=0?userInfoDic['blindMemberMomentDOList'][0]['content']:'',style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff333333),
                                        fontSize: 14,
                                      ),),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        alignment: Alignment.topLeft,
                                        // width: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                        // height: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                        margin: const EdgeInsets.only(left: 11,top: 13.5,right: 11),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  if(userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null){
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (BuildContext ccontext) {
                                                          return PostDetailPage(
                                                            id: userInfoDic['blindMemberMomentDOList'][0]['id'].toString(),
                                                          );
                                                        }));
                                                  }

                                                },
                                                child: Container(
                                                  child:
                                                  userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList']!=null&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null
                                                      ? _buildImagesWidget(userInfoDic['blindMemberMomentDOList'][0]['imgUrl'])
                                                      : Container(),
                                                ))
                                            //     userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList']!=null&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null?
                                            // Image.network(userInfoDic['blindMemberMomentDOList'][0]['imgUrl'] ?? "", fit: BoxFit.cover,width: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                            //   height: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,):Container()),


                                          ],
                                        )
                                    )
                                  ],
                                ),

                              ):Container(),


                              Container(
                                child: const Text(''),
                              ),



                            ],
                          ),
                        ),



                        //用户id
                        Container(
                          margin: const EdgeInsets.only(left: 30,top: 29.5,right: 30),
                          alignment: Alignment.center,
                          child: Text('用户id：${userInfoDic['id']}',style: const TextStyle(
                              color: Color(0xff999999),
                              fontSize: 13,fontWeight:FontWeight.w500
                          )),
                        ),

                        myuserid!='${userInfoDic['id']}'?GestureDetector(
                          onTap: (){
                            jubaoClick();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(left: 25,top: 7.5,right: 25,bottom: 90),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(child: Container(
                                    color: const Color(0xffEEEEEE),
                                    height: 0.5,
                                    margin: const EdgeInsets.only(left: 0,top: 0,right: 5.5),
                                  ),),
                                  const Text('举报',style: TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: 13,fontWeight:FontWeight.w500
                                  )),
                                  Container(child: Container(
                                    color: const Color(0xffEEEEEE),
                                    height: 0.5,
                                    margin: const EdgeInsets.only(left: 5.5,top: 0,right: 0),
                                  ),)
                                ],
                              )
                          ),
                        ):Container(
                          margin: const EdgeInsets.only(left: 25,top: 15,right: 25,bottom: 90),
                        ),

                        //
                      ],
                    )


                ),
              ),
            ),
          ),



        ],

      ),
    );
  }


  buganxingqu()async{
    BotToast.showLoading();
    String memberid = userInfoDic['id'].toString();
    // SharedPreferences share = await SharedPreferences.getInstance();
    // String userId = share.getString('UserId') ?? '';
    Map<String, dynamic> map = {};
    map['id'] = memberid;
    map['status'] = '1';
    print('map1111'+map.toString());

    NetWorkService service = await NetWorkService().init();
    service.put(Apis.updateMemberLike, data: map, successCallback: (data) async {
      BotToast.closeAllLoading();
      Navigator.pop(context);

      //保存成功
      /* Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return LoginAddressPage();
          }));*/
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }


  chooseLike() async{
    String memberid = userInfoDic['id'].toString();
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    Map<String, dynamic> map = {};
    map['issue'] = userId;
    map['receive'] = memberid;

    NetWorkService service = await NetWorkService().init();
    service.post(Apis.likeMatchBlindMembers, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      log('关注的结果====='+data.toString());
      BotToast.showText(text: '喜欢成功');
      // Map<String, dynamic> userdic11 = {};
      // userdic11['id'] = userInfoDic['id'].toString();
      // userdic11['nickname'] = userInfoDic['nickname'];
      // sendKefuMessage(userdic11);
      print('data[id].toString()'+userInfoDic['nickname'].toString());
      setState(() {
        lickclick = 1;
      });

      //保存成功
      /* Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return LoginAddressPage();
          }));*/
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  sendKefuMessage(data)async{

    print('data[id].toString()'+data['nickname'].toString());
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: data['nickname'].toString()+'，很高兴相互吸引，愿我们有个愉快的开始。', // 文本信息
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
        rightToChat(data);
      }else{

      }
    }
  }


  //跳转聊天
  rightToChat(userdic)async{

    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ChatPage(userInfoDic: userdic,);
        }));
    setState(() {

    });
  }



  Widget _buildBiDirectionalSlider({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color leftColor,
    required Color rightColor,
  }) {
    return Row(
      children: [
        Text(leftLabel, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: value < 0 ? leftColor : Color(0xff999999))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final center = width / 2;
                  final position = (value + 1) / 2 * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              if (value < 0)
                                Positioned(
                                  left: center + (position - center),
                                  right: center,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: leftColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        left: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              if (value > 0)
                                Positioned(
                                  left: center,
                                  right: width - position,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: rightColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        right: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              // Center(
                              //   child: Container(
                              //     width: 2,
                              //     height: 20,
                              //     color: Colors.grey[300],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Text(rightLabel, style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: value < 0 ? Colors.grey : rightColor)),
      ],
    );
  }

  Widget _buildDualProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double leftValue,
    required double rightValue,
    required Color leftColor,
    required Color rightColor,
    required ValueChanged<double> onLeftChanged,
    required ValueChanged<double> onRightChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(leftLabel, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey)),
            const Spacer(),
            Text(rightLabel, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: leftColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: leftColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: leftValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onLeftChanged,
                    ),
                  ),
                ),
              ),
              Container(
                width: 2,
                color: Colors.grey[300],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: rightColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: rightColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: rightValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onRightChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color color,
    String? centerLabel,
  }) {
    String getLevel(double value) {
      if (value < 0.33) {
        return '低级';
      } else if (value < 0.66) {
        return '中级';
      } else {
        return '高级';
      }
    }

    return Row(
      children: [
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(leftLabel, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Color(0xff999999))),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final position = value * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: width - position,
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.horizontal(
                                      left: const Radius.circular(100),
                                      right: Radius.circular(
                                          position < 10 ? 0 : 100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: position - 15,
                        top: -22,
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 7),
                              child: Text(
                                getLevel(value),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(rightLabel, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey)),
        ),
      ],
    );
  }

  int _calculatePercentage(double value, bool isLeft) {
    if (value == 0) {
      return 50;
    } else if (isLeft) {
      return value < 0 ? (50 + 50 * -value).round() : 100-(50 + 50 * value).round();
    } else {
      return value > 0 ? (50 + 50 * value).round() : 100-(50 + 50 * -value).round();
    }
  }






  Widget _buildImagesWidget(String imageStr) {
    if (imageStr.isEmpty) {
      return Container();
    }

    List<String> imageUrls = [];
    if (!imageStr.contains(',')) {
      imageUrls = [imageStr];
    } else {
      imageUrls = _getImageArray(imageStr);
    }

    List<Widget> widgets = [];
    for (int i = 0; i < imageUrls.length; i++) {
      if (i == 3) {
        break;
      }
      widgets.add(Container(
        width: (MediaQuery.of(context).size.width - 90 - 9.5 * 4) / 3.0,
        height: (MediaQuery.of(context).size.width - 90 - 9.5 * 4) / 3.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrls[i].toString())),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
      ));

      widgets.add(const SizedBox(
        width: 9.5,
      ));
    }

    return Row(
      children: widgets,
    );
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    _scrollController.dispose();
    super.dispose();
  }
}


