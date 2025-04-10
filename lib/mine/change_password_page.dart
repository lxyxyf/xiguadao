import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../network/network_manager.dart';

class ChangePasswordPage extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  ChangePasswordPage(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
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
      body: Container(
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
                    '更换手机号',
                    style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 75.5,
            ),
            const Text(
              '更换手机号',
              style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12.5,
            ),
            Text(
              (widget.havePhoneNumber ?? false)
                  ? '检测到您当前登录的手机号为：'
                  : '请输入您要更换的新手机号',
              style: const TextStyle(color: Color(0xff999999), fontSize: 13),
            ),
            Offstage(
              offstage: (widget.havePhoneNumber ?? false) ? false : true,
              child: Column(
                children: [
                  const SizedBox(
                    height: 23,
                  ),
                  Text(
                    phoneStr ?? '',
                    style: const TextStyle(
                        color: Color(0xff333333),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 58.5,
            ),
            Offstage(
              offstage: (widget.havePhoneNumber ?? false) ? true : false,
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(left: 25, right: 25),
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
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    height: 0.5,
                    color: const Color(0xff999999).withOpacity(0.25),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.only(left: 25, right: 25),
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
                                color: const Color(0xff999999).withOpacity(0.25),
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
                          border:
                              Border.all(color: const Color(0xffFE7A24), width: 0.5),
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
              margin: const EdgeInsets.only(left: 25, right: 25),
              height: 0.5,
              color: const Color(0xff999999).withOpacity(0.25),
            ),
            const SizedBox(
              height: 90,
            ),
            GestureDetector(
              onTap: () {
                if (widget.havePhoneNumber ?? false) {
                  if (codeController.text.isEmpty) {
                    BotToast.showText(text: '请输入验证码');
                    return;
                  }
                  //验证验证码
                  codeYanZheng();
                } else {
                  _changePhone();
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 25, right: 25),
                height: 50,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Color(0xffFE7A24),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Text(
                  (widget.havePhoneNumber ?? false) ? '确认' : '确定',
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
    );
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
    MTEasyLoading.dismiss();
    _cancleTimer();
    super.dispose();
  }
}
