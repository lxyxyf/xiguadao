import 'dart:async';
import 'dart:developer';
import 'package:xinxiangqin/xingzuo/xingzuo_task_list.dart';

import '../../mine/change_personal_info_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/agreement/agreement_info_page.dart';
import 'package:xinxiangqin/main_page.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import 'login_future_page.dart';
import 'login_page.dart';

class ZhanxingshiLogin extends StatefulWidget {
  const ZhanxingshiLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<ZhanxingshiLogin> {
  String userAgreement = '';
  String privacyAgreement = '';
  String codeStr = '发送验证码';
  int countdown = 60; //倒计时的秒数，默认60秒
  Timer? _timer; //倒计时的计时器
  bool isClickDisable = false; //防止点击过快导致Timer出现无法停止的问题
  Map<String, dynamic> userInfoDic = {};

  TextEditingController phoneController = TextEditingController(text: 'zhanxingshi');
  TextEditingController codeController = TextEditingController(text: '123456');

  ///是否同意用户协议和隐私政策
  bool isAgree = false;
  @override
  void initState() {
    super.initState();
    _getBaseInfo();
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
                      '占星师登录',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '测算星座整体运势',
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
                            'images/login/zhanghao.png',
                            width: 13.5,
                            height: 14.5,
                          ),
                          const SizedBox(
                            width: 8.5,
                          ),
                          const Text(
                            '账号',
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
                            'images/login/mima.png',
                            width: 14.5,
                            height: 15,
                          ),
                          const SizedBox(
                            width: 8.5,
                          ),
                          const Text(
                            '密码',
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
                                    hintText: '请输入密码',
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

                          //验证码
                          // GestureDetector(
                          //   onTap: () {
                          //     _getCode();
                          //   },
                          //   child: Container(
                          //     width: 85,
                          //     height: 32.5,
                          //     alignment: Alignment.center,
                          //     decoration: BoxDecoration(
                          //         border: Border.all(
                          //             color: const Color(0xffFE7A24), width: 0.5),
                          //         borderRadius:
                          //         const BorderRadius.all(Radius.circular(16.25))),
                          //     child: Text(
                          //       codeStr,
                          //       style: const TextStyle(
                          //         color: Color(0xffFE7A24),
                          //         fontSize: 13,
                          //       ),
                          //     ),
                          //   ),
                          // )
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
                          margin: const EdgeInsets.only(left: 25, right: 25,),
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Color(0xffFE7A24),
                              borderRadius: BorderRadius.all(Radius.circular(25))),
                          child: const Text(
                            '登录',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ),


                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return LoginPage();
                              }));
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 29,),
                            child: Column(
                              children: [
                                Text('用户登录',
                                  style: TextStyle(
                                      color: Color(0xffFE7A24),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),),
                                Container(
                                  color: Color(0xffFE7A24),
                                  width: 60,
                                  height: 1,
                                )
                              ],
                            )
                        ),
                      ),


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
                              child: Container(
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
                  ))
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



    if (phoneController.text.isEmpty) {
      BotToast.showText(text: '账号不能为空');
      return;
    }

     String phoneStr = phoneController.text.replaceAll(' ', '');
    // if (!isPhone(phoneStr)) {
    //   BotToast.showText(text: '手机号格式不合法');
    //   return;
    // }

    if (codeController.text.isEmpty) {
      BotToast.showText(text: '密码不能为空');
      return;
    }

    if (!isAgree) {
      BotToast.showText(text: '请阅读并同意用户协议和隐私政策');
      return;
    }
    Map diccc = {'username': phoneStr, 'password': codeController.text,'radio':false};
    log(diccc.toString());
    MTEasyLoading.showLoading('正在登录');
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.zhanxingshiLogin,
        data: diccc,
        successCallback: (data) async {
          MTEasyLoading.dismiss();
          // BotToast.showText(text: '登录成功');

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
              'true',
            );

            share.setString('Phone', phoneController.text);
          }
          log(data.toString());

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const XingzuoTaskList(),
            ),
                (route) => false,
          );
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (BuildContext ccontext) {
          //       return const LoginFuturePage();
          //     }));

          // getuserInfo();


        }, failedCallback: (data) {
          MTEasyLoading.dismiss();
        });
  }

  // getuserInfo() async{
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.userInfo, queryParameters: {},
  //       successCallback: (data) async {
  //         // log('登陆后获取用户信息'+data.toString());
  //         Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const XingzuoTaskList(),
  //           ),
  //               (route) => false,
  //         );
  //       }, failedCallback: (data) {
  //         // log('登陆后获取用户错误信息'+data.toString());
  //       });
  // }

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
