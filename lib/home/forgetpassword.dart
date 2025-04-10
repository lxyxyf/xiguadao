import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/home/sendcode.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../mine/change_password_page.dart';
import '../network/network_manager.dart';

class Forgetpassword extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  Forgetpassword(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<Forgetpassword> {
  String phoneStr = '';
  String codeStr = '发送验证码';
  int countdown = 60; //倒计时的秒数，默认60秒
  Timer? _timer; //倒计时的计时器
  bool isClickDisable = false; //防止点击过快导致Timer出现无法停止的问题

  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ///原始手机号
  String oriPhone = '';
  @override
  void initState() {
    super.initState();
    _getLoginAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top + 24,
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text(
                      '忘记密码',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.5,
              ),

              Container(
                width: MediaQuery.of(context).size.width-90.5-90,
                height: 194.3*(MediaQuery.of(context).size.width-90.5-90)/194.3,
                child: Image(image: AssetImage('images/home/forgetpassword.png')),
              ),

              SizedBox(
                height: 3,
              ),

              Container(
                child: Text(
                  '通过手机号验证后重置密码请确认你的手机',
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 3,),
              Container(
                child: Text.rich(
                  TextSpan(
                    children:[
                      TextSpan(
                          text: phoneStr,
                          style: TextStyle(
                              color: Color(0xffFE7A24),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)
                      ),
                      TextSpan(
                          text: '能接收短信。',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontWeight: FontWeight.normal)
                      )
                    ]
                  )
                ),
              ),
              SizedBox(height: 51,),

              GestureDetector(
                onTap: () {
                  sendcode();
                  // if (widget.havePhoneNumber ?? false) {
                  //   if (codeController.text.isEmpty) {
                  //     BotToast.showText(text: '请输入验证码');
                  //     return;
                  //   }
                  //   //验证验证码
                  //   codeYanZheng();
                  // } else {
                  //   _changePhone();
                  // }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color(0xffFE7A24),
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Text(
                    '发送验证短信',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendcode()async{
    //发送成功后跳转
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return Sendcode(
            codeStr: '111111',
          );
        }));
  }

  ///获取登录账号
  void _getLoginAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String phone = sharedPreferences.getString('Phone') ?? '';
    oriPhone = phone;
    if (phone.isNotEmpty) {
      String ploPhone = '${phone.substring(0, 3)}****${phone.substring(7, 11)}';
      setState(() {
        phoneStr = ploPhone;
      });
    }
  }

  ///获取验证码
  void _getCode() async {
    if (oriPhone.isEmpty) {
      return;
    }

    MTEasyLoading.showLoading('正在发送');
    NetWorkService service = await NetWorkService().init();
    service.post(
      Apis.getSmsCode,
      data: {'mobile': oriPhone, 'scene': '1'},
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

  ///验证码验证
  void codeYanZheng() async {
    if (oriPhone.isEmpty) {
      return;
    }
    if (codeController.text.isEmpty) {
      BotToast.showText(text: '验证码不能为空');
      return;
    }

    MTEasyLoading.showLoading('');
    NetWorkService service = await NetWorkService().init();
    service.post(
      Apis.codeYanZheng,
      data: {'mobile': oriPhone, 'code': codeController.text},
      successCallback: (data) {
        MTEasyLoading.dismiss();
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext ccontext) {
              return ChangePasswordPage(
                codeStr: codeController.text,
              );
            }));
      },
      failedCallback: (data) {
        MTEasyLoading.dismiss();
      },
    );
  }

  ///更换手机号
  void _changePhone() async {
    if (phoneController.text.isEmpty) {
      BotToast.showText(text: '手机号不能为空');
      return;
    }

    if (!isPhone(phoneController.text)) {
      BotToast.showText(text: '手机号格式不合法');
      return;
    }

    if (codeController.text.isEmpty) {
      BotToast.showText(text: '验证码不能为空');
      return;
    }

    MTEasyLoading.showLoading('');
    NetWorkService service = await NetWorkService().init();
    service.put(
      Apis.changePhone,
      data: {'mobile': phoneController.text, 'code': codeController.text},
      successCallback: (data) {
        MTEasyLoading.dismiss();

        MTEasyLoading.showToast('修改成功，请重新登录');
        quitLogin();
      },
      failedCallback: (data) {
        MTEasyLoading.dismiss();
        MTEasyLoading.showToast('修改失败，请稍后再试');
      },
    );
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
        builder: (context) => const LoginPage(),
      ),
          (route) => false,
    );
  }

  //取消到倒计时的计时器
  _cancleTimer() {
    isClickDisable = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    codeController.dispose();
    phoneController.dispose;
    _cancleTimer();
    super.dispose();
  }
}
