
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:event_bus/event_bus.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';

import 'package:xinxiangqin/shequ/shequ_home_page.dart';
import 'package:xinxiangqin/mine/mine_page.dart';
import 'package:xinxiangqin/mine/newmine.dart';
import 'package:xinxiangqin/activity/activity_home_page.dart';
import 'package:xinxiangqin/message/message_home_page.dart';
import 'package:xinxiangqin/home/SecondPage.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/tools/event_tools.dart';

import 'home/home_showdialog_page.dart';
import 'message/generateUserSig.dart';
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  final SecondPage secondPage = const SecondPage();
  final ShequHomePage homePage = const ShequHomePage();
  final NewMinePage minePage = const NewMinePage();
  final ActivityHomePage activityPage = const ActivityHomePage();
  final MessageHomePage messagePage = const MessageHomePage();
  List<Widget> _pages = [];
  int _selectedIndex = 0;
  bool showMinePoint = false;
  bool showMessagePoint = false;
  String qingshaonianmoshi = '';
  EventBus eventBus = EventBus();
  // final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  @override
  void initState() {



    // _coreInstance.init(
    //     sdkAppID: 1600029298, // Replace 0 with the SDKAppID of your IM application when integrating
    //     // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
    //     loglevel: LogLevelEnum.V2TIM_LOG_ALL,
    //     onTUIKitCallbackListener:  (TIMCallback callbackValue){
    //
    //       log('聊天错误'+callbackValue.infoRecommendText.toString());
    //     }, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
    //     listener: V2TimSDKListener());
    // _coreInstance.init(
    //     sdkAppID: 1600058685, // Replace 0 with the SDKAppID of your IM application when integrating
    //     // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
    //     loglevel: LogLevelEnum.V2TIM_LOG_DEBUG,
    //     onTUIKitCallbackListener:  (TIMCallback callbackValue){}, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
    //     listener: V2TimSDKListener());
    super.initState();
    eventTools.on('showMinePointHave', (arg) {
      showMinePointHave();
    });

    eventTools.on('showMinePointNo', (arg) {
      showMinePointNo();
    });


    eventTools.on('showMessageHave', (arg) {
      showMessageHave();
    });

    eventTools.on('showMessageNo', (arg) {
      showMessageNo();
    });
    // setpageNum();

    // initChatInfo();


    initUI();
    // initJPush();
    // initTIMPush();
  }



  // initJPush() async {
  //   ///创建 JPush
  //   JPush jpush = new JPush();
  //   jpush.addEventHandler(
  //     // 接收通知回调方法。
  //     onReceiveNotification: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveNotification: $message");
  //     },
  //     // 点击通知回调方法。
  //     onOpenNotification: (Map<String, dynamic> message) async {
  //       print("flutter onOpenNotification: $message");
  //     },
  //     // 接收自定义消息回调方法。
  //     onReceiveMessage: (Map<String, dynamic> message) async {
  //       print("flutter onReceiveMessage: $message");
  //     },
  //   );
  //   jpush.setAuth(enable: true);
  //   ///配置应用 Key
  //   jpush.setup(
  //     appKey: "55e3a8be95ba1470bae4e077",
  //     channel: "theChannel",
  //     production: false,
  //     /// 设置是否打印 debug 日志
  //     debug: true,
  //   );
  //
  //   jpush.applyPushAuthority(
  //       new NotificationSettingsIOS(sound: true, alert: true, badge: true));
  //   jpush.setBadge(0);
  //
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   jpush.getRegistrationID().then((rid) {
  //     log("flutter get registration id : $rid");
  //     setState(() {
  //       log("flutter getRegistrationID: $rid");
  //     });
  //   });
  //
  //
  //
  //   // jpush.setBadge(55).then((map) {
  //   //   setState(() {
  //   //     log("setBadge success: $map");
  //   //     // debugLable = "setBadge success: $map";
  //   //   });
  //   // }).catchError((error) {
  //   //   setState(() {
  //   //     log("setBadge error: $error");
  //   //     // debugLable = "setBadge error: $error";
  //   //   });
  //   // });
  //
  // }

  initUI()async{
    SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (sharedPreferences.getString('qingshaonianmoshi')==null){
      log('没有开启1');
      setState(() {
        qingshaonianmoshi = 'false';
      });
      _pageController =
          PageController(initialPage: _selectedIndex, keepPage: false);
      _pages = [secondPage,homePage,activityPage,messagePage,minePage];
    }else{
      setState(() {
        qingshaonianmoshi = sharedPreferences.getString('qingshaonianmoshi')!;
      });
      if (qingshaonianmoshi=='true'){
        log('开启了');
        _pageController =
            PageController(initialPage: _selectedIndex, keepPage: false);
        _pages = [secondPage,homePage,minePage];
      }else{
        log('没有开启2');
        _pageController =
            PageController(initialPage: _selectedIndex, keepPage: false);
        _pages = [secondPage,homePage,activityPage,messagePage,minePage];
      }
    }


  }

  //
  showMinePointHave(){
    if(mounted){
      setState(() {
        showMinePoint = true;
      });
    }
  }


  showMinePointNo(){
    if (mounted){
      setState(() {
        showMinePoint = false;
      });
    }
  }

  showMessageHave(){
    if (mounted){
      setState(() {
        showMessagePoint = true;
      });
    }
  }


  showMessageNo(){
    if (mounted){
      setState(() {
        showMessagePoint = false;
      });
    }
  }

  // setpageNum()async{
  //   SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //
  //   if (sharedPreferences.getString("page") == 'mine'){
  //     _selectedIndex = 4;
  //     _pageController?.jumpToPage(4);
  //     print('1111111');
  //   }else{
  //     _selectedIndex = 0;
  //     _pageController?.jumpToPage(0);
  //     print('22222222');
  //   }
  //
  // }




  // //判断是否有权限
  // Future<void> checkPermission() async {
  //   Permission permission = Permission.location;
  //   PermissionStatus status = await permission.status;
  //   print('检测权限$status');
  //   if (status.isGranted) {
  //     //权限通过
  //
  //   } else if (status.isDenied) {
  //     //权限拒绝， 需要区分IOS和Android，二者不一样
  //     requestPermission(permission);
  //   } else if (status.isPermanentlyDenied) {
  //     //权限永久拒绝，且不在提示，需要进入设置界面
  //     openAppSettings();
  //   } else if (status.isRestricted) {
  //     //活动限制（例如，设置了家长///控件，仅在iOS以上受支持。
  //   }
  // }


    // //申请权限
    // void requestPermission(Permission permission) async {
    //   PermissionStatus status = await permission.request();
    //   print('权限状态$status');
    //   if (!status.isGranted) {
    //    await  openAppSettings();
    //    checkPermission();
    //   }
    // }

  // Future<void> getLocation() async {
  //   /// 务必先初始化 并获取权限
  //   if (getPermissions) return;
  //   AMapLocation location = await FlAMapLocation().getLocation();
  //   if (isAndroid) {
  //     AMapLocation is AMapLocationForAndroid;
  //   }
  //   if (isIOS) {
  //     AMapLocation is AMapLocationForIOS;
  //   }
  // }


  // initChatInfo()async{
  //   SharedPreferences share = await SharedPreferences.getInstance();
  //   String userId = share.getString('UserId') ?? '';
  //   String usersig = GenerateDevUsersigForTest(sdkappid: 1600029298, key: 'fdb5b8018dfda4cedc7eacd833d709cfca144ea2e614217a3652cef0873f9cfa').genSig(identifier: userId, expire: 86400);
  //   log('前端生成的'+usersig.toString());
  //   _coreInstance.login(userID: userId,userSig: usersig
  //     // userSig: 'eJwtzEsLgkAYheH-MuuQcZobQqsiA61FGdTsyhmnjyzHK0X03zN1eZ4Xzgcl8cHrTIUCRDyMZsMGbZ4NZDBwW5uK5DClWt8vzoFGgc8xxkxyycZiXg4q0ztjjPRp1AYefxNzTCnlXEwvYPvnVKx9fMzb96a0oVqe7DVSe0kLW8bKrG7FLtNJGoVtd94u0PcHpycypw__'
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xfffafafa),
      body: PageView(

        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _pageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: qingshaonianmoshi=='true'?Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 0;
                    _pageController?.jumpToPage(0);
                  });
                }

              },
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                // height: 49,
                width: MediaQuery.of(context).size.width/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 0
                          ? "images/home_select.png"
                          : "images/home_unselect.png"),
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "首页",
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),

            //社区
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 1;
                    _pageController?.jumpToPage(1);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width/6,
                alignment: Alignment.center,
                // height: 49,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 1
                          ? "images/shequ_select.png"
                          : "images/shequ_unselect.png"),
                      width: 21,
                      height: 18.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "社区",
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),

            //SizedBox(), //发布

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 2;
                    _pageController?.jumpToPage(2);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                // height: 49,
                width: MediaQuery.of(context).size.width/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showMinePoint==true?Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.topRight,
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xffED0D0D),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                    ):Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 2
                          ? "images/mine_select.png"
                          : "images/my_unselect.png"),
                      width: 19,
                      height: 17.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "我的",
                      style: TextStyle(
                        color: _selectedIndex == 2
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 0;
                    _pageController?.jumpToPage(0);
                  });
                }

              },
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                // height: 49,
                width: MediaQuery.of(context).size.width/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 0
                          ? "images/home_select.png"
                          : "images/home_unselect.png"),
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "首页",
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),

            //社区
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 1;
                    _pageController?.jumpToPage(1);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width/6,
                alignment: Alignment.center,
                // height: 49,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 1
                          ? "images/shequ_select.png"
                          : "images/shequ_unselect.png"),
                      width: 21,
                      height: 18.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "社区",
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),

            //活动
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 2;
                    _pageController?.jumpToPage(2);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width/6,
                alignment: Alignment.center,
                // height: 49,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 2
                          ? "images/activity_select.png"
                          : "images/activity_unselect.png"),
                      width: 18,
                      height: 19.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "活动",
                      style: TextStyle(
                        color: _selectedIndex == 2
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),



            //消息
            GestureDetector(

              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 3;
                    _pageController?.jumpToPage(3);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                width: MediaQuery.of(context).size.width/6,
                alignment: Alignment.center,
                // height: 49,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showMessagePoint==true?Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.topRight,
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xffED0D0D),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                    ):Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 3
                          ? "images/message_select.png"
                          : "images/message_unselect.png"),
                      width: 19.5,
                      height: 22.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "消息",
                      style: TextStyle(
                        color: _selectedIndex == 3
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),




            //SizedBox(), //发布

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _selectedIndex = 4;
                    _pageController?.jumpToPage(4);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                // height: 49,
                width: MediaQuery.of(context).size.width/6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showMinePoint==true?Container(
                      margin: EdgeInsets.only(left: 15),
                      alignment: Alignment.topRight,
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Color(0xffED0D0D),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                    ):Container(width: 10,
                      height: 10,),
                    (Image.asset(
                      (_selectedIndex == 4
                          ? "images/mine_select.png"
                          : "images/my_unselect.png"),
                      width: 19,
                      height: 17.5,
                      fit: BoxFit.cover,
                    )),
                    SizedBox(height: 5,),
                    Text(
                      "我的",
                      style: TextStyle(
                        color: _selectedIndex == 4
                            ? const Color(0xff333333)
                            : const Color(0xff999999),
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //     elevation: 0,
      //     backgroundColor: Colors.transparent,
      //     focusColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //     //悬浮按钮
      //     child: Container(
      //       width: 52,
      //       height: 43,
      //       child: Image.asset('images/publish.png'),
      //     ),
      //     onPressed: () {
      //       Navigator.push(context, MaterialPageRoute(
      //         builder: (BuildContext ccontext) {
      //           return PublishPage();
      //         },
      //       ));
      //     })
    );
  }

  void _pageChanged(int index) {
    if (mounted) {
      setState(() {
        if (_selectedIndex != index) _selectedIndex = index;
      });
    }
  }
}
