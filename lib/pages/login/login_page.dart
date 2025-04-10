import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/pages/login/first_agree_dialog.dart';
import 'package:xinxiangqin/pages/login/login_character_page.dart';
import 'package:xinxiangqin/pages/login/zhanxingshi_login.dart';
import '../../agreement/user_agent_page.dart';
import 'permission_service.dart';
import '../../message/generateUserSig.dart';
import '../../mine/change_personal_info_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/agreement/agreement_info_page.dart';
import 'package:xinxiangqin/main_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../../mine/privacy_policy_page.dart';
import 'login_future_page.dart';
import 'login_heightweight_page.dart';
import 'login_shimingrenzheng.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  String userAgreement = '';
  String privacyAgreement = '';
  String codeStr = '发送验证码';
  int countdown = 60; //倒计时的秒数，默认60秒
  Timer? _timer; //倒计时的计时器
  bool isClickDisable = false; //防止点击过快导致Timer出现无法停止的问题
  Map<String, dynamic> userInfoDic = {};
  Map<String, dynamic> basicDic = {};
  final PermissionService _permissionService = PermissionService();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String deviceName = '';
  ///是否同意用户协议和隐私政策
  bool isAgree = false;
  @override
  void initState() {
    _coreInstance.init(
        sdkAppID: 1600029298, // Replace 0 with the SDKAppID of your IM application when integrating
        // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
        loglevel: LogLevelEnum.V2TIM_LOG_ALL,
        onTUIKitCallbackListener:  (TIMCallback callbackValue){

          log('聊天错误'+callbackValue.infoRecommendText.toString());
        }, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
        listener: V2TimSDKListener());

    super.initState();
    _getBaseInfo();
    getDeviceInfo();
    getNotification();
  }


  getNotification()async{
    bool isGranted = await _permissionService.requestNotificationPermission();

    if (isGranted) {
      // 权限已被授予
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('通知权限已授予')),
      // );
    } else {
      // 权限被拒绝
      await _permissionService.requestNotificationPermission();
    }
  }

  getDeviceInfo()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();


    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.brand;
      log('安卓111${androidInfo.manufacturer}');
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = 'iOS: ${iosInfo.utsname.machine}, ${iosInfo.identifierForVendor}';
      log('苹果${iosInfo}');
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _createView(),
    );
  }

  Widget _createView() {
    return GestureDetector(
      onTap: () {
        //点击空白区域，键盘收起
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Image.asset(
                  'images/login_top_bg.png',
                  width: MediaQuery.of(context).size.width - 20,
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 33),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '登录/注册',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '快来寻找适合你的灵魂伴侣！',
                      style: TextStyle(
                          color: Color(0xff666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon_phone.png',
                            width: 9.5,
                            height: 13.5,
                          ),
                          const SizedBox(
                            width: 8.5,
                          ),
                          const Text(
                            '+86',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 20,
                            width: 0.5,
                            color: const Color(0xff999999).withOpacity(0.25),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: phoneController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: '请输入手机号',
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    hintStyle: TextStyle(
                                        color:
                                        const Color(0xff999999).withOpacity(0.25),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: const Color(0xff999999).withOpacity(0.25),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Image.asset(
                            'images/icon_code.png',
                            width: 9.5,
                            height: 13.5,
                          ),
                          const SizedBox(
                            width: 8.5,
                          ),
                          const Text(
                            '验证码',
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 20,
                            width: 0.5,
                            color: const Color(0xff999999).withOpacity(0.25),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: codeController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: '请输入验证码',
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    hintStyle: TextStyle(
                                        color:
                                        const Color(0xff999999).withOpacity(0.25),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _getCode();
                            },
                            child: Container(
                              width: 85,
                              height: 32.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffFE7A24), width: 0.5),
                                  borderRadius:
                                  const BorderRadius.all(Radius.circular(16.25))),
                              child: Text(
                                codeStr,
                                style: const TextStyle(
                                  color: Color(0xffFE7A24),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 0.5,
                      color: const Color(0xff999999).withOpacity(0.25),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _login();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 50,
                        margin: const EdgeInsets.only(left: 25, right: 25),
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Color(0xffFE7A24),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: const Text(
                          '登录/注册',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),

                    // basicDic['constellatSwitch']==1?GestureDetector(
                    //   onTap: (){
                    //     Navigator.push(context, MaterialPageRoute(
                    //         builder: (BuildContext context) {
                    //           return ZhanxingshiLogin();
                    //         }));
                    //   },
                    //   child: Container(
                    //       margin: EdgeInsets.only(top: 29,),
                    //       child: Column(
                    //         children: [
                    //           Text('占星师入口',
                    //             style: TextStyle(
                    //                 color: Color(0xffFE7A24),
                    //                 fontWeight: FontWeight.bold,
                    //                 fontSize: 14),),
                    //           Container(
                    //             color: Color(0xffFE7A24),
                    //             width: 80,
                    //             height: 2,
                    //           )
                    //         ],
                    //       )
                    //   ),
                    // ):Container(),

                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                isAgree = !isAgree;
                              });
                            },
                            child:
                            Container(
                                width: 30,
                                height: 30,

                                // decoration: const BoxDecoration(
                                //     borderRadius: BorderRadius.all(
                                //         Radius.circular(12.5 / 2.0))),
                                child: Container(
                                  padding: EdgeInsets.only(left: 15,),
                                  width: 12.5,
                                  height: 12.5,
                                  child:
                                  isAgree
                                      ? Icon(Icons.check_circle,color: Color(0xffFE7A24 ),size: 18,)
                                      :Image.asset('images/unselect.png',
                                    width: 12.5,
                                    height: 12.5,
                                    fit: BoxFit.fitWidth,

                                  ),
                                )
                            ),
                          ),


                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            '登录即同意',
                            style:
                            TextStyle(color: Color(0xff999999), fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userAgreement.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return AgreementInfoPage(
                                          htmlStr: userAgreement, title: '服务协议');
                                    }));
                              }
                            },
                            child: const Text(
                              '《服务协议》',
                              style:
                              TextStyle(color: Color(0xffFE7A24), fontSize: 12),
                            ),
                          ),
                          const Text(
                            '和',
                            style:
                            TextStyle(color: Color(0xff999999), fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (privacyAgreement.isNotEmpty) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return AgreementInfoPage(
                                          htmlStr: privacyAgreement, title: '隐私政策');
                                    }));
                              }
                            },
                            child: const Text(
                              '《隐私政策》',
                              style:
                              TextStyle(color: Color(0xffFE7A24), fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  ///获取验证码
  void _getCode() async {
    if (phoneController.text.isEmpty) {
      BotToast.showText(text: '手机号不能为空');
      return;
    }

    if (!isPhone(phoneController.text)) {
      BotToast.showText(text: '手机号格式不合法');
      return;
    }

    MTEasyLoading.showLoading('正在发送');
    NetWorkService service = await NetWorkService().init();
    service.post(
      Apis.getSmsCode,
      data: {'mobile': phoneController.text, 'scene': '1'},
      successCallback: (data) {
        MTEasyLoading.dismiss();

        setState(() {
          isClickDisable = true;
          _startTimer();
          MTEasyLoading.showToast('发送成功');
        });
      },
      failedCallback: (data) {
        MTEasyLoading.dismiss();
      },
    );
  }

  void _login() async {

    SharedPreferences share = await SharedPreferences.getInstance();


    if (phoneController.text.isEmpty) {
      BotToast.showText(text: '手机号不能为空');
      return;
    }

    String phoneStr = phoneController.text.replaceAll(' ', '');
    if (!isPhone(phoneStr)) {
      BotToast.showText(text: '手机号格式不合法');
      return;
    }

    if (codeController.text.isEmpty) {
      BotToast.showText(text: '验证码不能为空');
      return;
    }

    if (!isAgree) {
      BotToast.showText(text: '请阅读并同意用户协议和隐私政策');
      return;
    }

    MTEasyLoading.showLoading('正在登录');
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.login,
        data: {'mobile': phoneStr, 'code': codeController.text},
        successCallback: (data) async {

      // BotToast.showText(text: '登录成功');
      await initChatInfo(data['userId'].toString());
      //登录成功报错用户信息
      SharedPreferences share = await SharedPreferences.getInstance();
      if (data != null && data['userId'] != null) {
        share.setString(
          'UserId',
          data['userId'].toString(),
        );

        share.setString(
          'AccessToken',
          data['accessToken'].toString(),
        );

        share.setString(
          'RefreshToken',
          data['refreshToken'].toString(),
        );
        share.setString(
          'sex',
          data['sex'].toString(),
        );
        share.setString(
          'iszhanxingshi',
          'false',
        );

        share.setString('Phone', phoneController.text);

      }

      // Navigator.push(context,
      //     MaterialPageRoute(builder: (BuildContext ccontext) {
      //       return LoginShimingrenzheng();
      //     }));
      // return;


      if (data['haveFirstLogin']==1){
        MTEasyLoading.dismiss();

        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return ChangePersonalInfoPage(userInfoDic: userInfoDic,);
            }));

      }else{
        getuserInfo();
      }


    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }

  initChatInfo(userid)async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    String usersig = GenerateDevUsersigForTest(sdkappid: 1600029298, key: 'fdb5b8018dfda4cedc7eacd833d709cfca144ea2e614217a3652cef0873f9cfa').genSig(identifier: userid, expire: 86400);
    log('前端生成的'+usersig.toString());
    await _coreInstance.login(userID: userid,userSig: usersig
      // userSig: 'eJwtzEsLgkAYheH-MuuQcZobQqsiA61FGdTsyhmnjyzHK0X03zN1eZ4Xzgcl8cHrTIUCRDyMZsMGbZ4NZDBwW5uK5DClWt8vzoFGgc8xxkxyycZiXg4q0ztjjPRp1AYefxNzTCnlXEwvYPvnVKx9fMzb96a0oVqe7DVSe0kLW8bKrG7FLtNJGoVtd94u0PcHpycypw__'
    );
    await Future.delayed(Duration(seconds: 2)); // 模拟异步操作，延迟2秒
    await initTIMPush();

  }

  initTIMPush()async{

    if (Platform.isAndroid) {

    } else if (Platform.isIOS) {
      TencentCloudChatPush().registerPush(
          onNotificationClicked: _onNotificationClicked,
          sdkAppId:1600029298,
          appKey:'UBDjDQBU6RaLgFOnwi0i9atZOKEzcduj23PKgGngKVJ0DmhafHwtqaMz7leT1eTB'

      );
    }

    if(deviceName=='OPPO'||deviceName=='oppo'||deviceName=='Oppo'){
      TencentCloudChatPush().registerPush(
          apnsCertificateID:39782,
          onNotificationClicked: _onNotificationClicked,
          sdkAppId:1600029298,
          appKey:'UBDjDQBU6RaLgFOnwi0i9atZOKEzcduj23PKgGngKVJ0DmhafHwtqaMz7leT1eTB'

      );
    }

    if(deviceName=='vivo'||deviceName=='VIVO'){
      TencentCloudChatPush().registerPush(
          apnsCertificateID:39785,
          onNotificationClicked: _onNotificationClicked,
          sdkAppId:1600029298,
          appKey:'UBDjDQBU6RaLgFOnwi0i9atZOKEzcduj23PKgGngKVJ0DmhafHwtqaMz7leT1eTB'

      );
    }


    if(deviceName=='HUAWEI'||deviceName=='huawei'){
      TencentCloudChatPush().registerPush(
          apnsCertificateID:40818,
          onNotificationClicked: _onNotificationClicked,
          sdkAppId:1600029298,
          appKey:'UBDjDQBU6RaLgFOnwi0i9atZOKEzcduj23PKgGngKVJ0DmhafHwtqaMz7leT1eTB'

      );
    }

    if(deviceName=='XIAOMI'||deviceName=='xiaomi'||deviceName=='Redmi'||deviceName=='Xiaomi'){
      TencentCloudChatPush().registerPush(
          apnsCertificateID:39781,
          onNotificationClicked: _onNotificationClicked,
          sdkAppId:1600029298,
          appKey:'UBDjDQBU6RaLgFOnwi0i9atZOKEzcduj23PKgGngKVJ0DmhafHwtqaMz7leT1eTB'

      );
    }


    TencentCloudChatPush().getRegistrationID(
    );


  }

  void _onNotificationClicked({required String ext, String? userID, String? groupID}) {
    print("_onNotificationClicked: $ext, userID: $userID, groupID: $groupID");
    if (userID != null || groupID != null) {
      // 根据 userID 或 groupID 跳转至对应 Message 页面.
    } else {
      // 根据 ext 字段, 自己写解析方式, 跳转至对应页面.
    }
  }

  getuserInfo() async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (BuildContext ccontext) {
          //       return ChangePersonalInfoPage(userInfoDic: data,);
          //     }));

          log('登录返回的数据'+data.toString());
          MTEasyLoading.dismiss();
          //测试记得去掉注释
          if (data['constellation']==null||data['constellation'].toString()==''){
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext ccontext) {
                  return ChangePersonalInfoPage(userInfoDic: data,);
                }));
          }else{
            MTEasyLoading.dismiss();
            SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
            await sharedPreferences.setString('page', 'home');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>  MainPage(),
              ),
                  (route) => false,
            );
          }

        }, failedCallback: (data) {
        });
  }

  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      //用户协议
      String userAgreement = data['userAgreement'];
      //隐私政策
      String privacyAgreement = data['privacyAgreement'];
      if (userAgreement.isNotEmpty) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('UserAgreement', userAgreement);
        this.userAgreement = userAgreement;
        sharedPreferences.setString('PrivacyAgreement', privacyAgreement);
        this.privacyAgreement = privacyAgreement;
      }
      setState(() {
        basicDic = data!;
      });
    }, failedCallback: (data) {});
  }

  bool isPhone(String input) {
    RegExp mobile = RegExp(r"1[0-9]\d{9}$");
    return mobile.hasMatch(input);
  }

  //启动倒计时计时器
  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (countdown <= 0) {
          isClickDisable = false;
          countdown = 60;
          codeStr = "重新发送";
          _cancleTimer();
          return;
        }
        countdown = 60 - _timer!.tick;
        codeStr = "已发送$countdown" "s";
      });
    });
  }

  //取消到倒计时的计时器
  _cancleTimer() {
    isClickDisable = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    _cancleTimer();
    super.dispose();
  }
}
