import 'dart:async';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../network/network_manager.dart';

class Sendcode extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  Sendcode(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<Sendcode> {
  String phoneStr = '';
  String codeStr = '已发送60s';
  int countdown = 60; //倒计时的秒数，默认60秒
  Timer? _timer; //倒计时的计时器
  bool isClickDisable = true; //防止点击过快导致Timer出现无法停止的问题

  TextEditingController codeController1 = TextEditingController();
  TextEditingController codeController2 = TextEditingController();
  TextEditingController codeController3 = TextEditingController();
  TextEditingController codeController4 = TextEditingController();
  TextEditingController codeController5 = TextEditingController();
  TextEditingController codeController6 = TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  FocusNode _focusNode6 = FocusNode();

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
      body: GestureDetector(
        onTap: () {
          //点击空白区域，键盘收起
          //收起键盘
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
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
                  height: 75.5,
                ),
                const Text(
                  '忘记密码',
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  '请输入验证码',
                  style: const TextStyle(color: Color(0xff999999), fontSize: 14),
                ),


                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text.rich(
                            TextSpan(
                                children:[
                                  TextSpan(
                                      text: '验证码已发送至',
                                      style: TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal)
                                  ),
                                  TextSpan(
                                      text: phoneStr,
                                      style: TextStyle(
                                          color: Color(0xffFE7A24),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)
                                  ),

                                ]
                            )
                        ),
                      ),
                      SizedBox(width: 15,),
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
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
                      ),
                    ],
                  ),
                ),

                // Container(
                //   margin: const EdgeInsets.only(left: 25, right: 25),
                //   height: 0.5,
                //   color: const Color(0xff999999).withOpacity(0.25),
                // ),
                const SizedBox(
                  height: 24,
                ),

                Container(
                  width: 38*6+50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController1,
                          focusNode: _focusNode1,
                          onChanged: (value){

                            if (value.isNotEmpty){
                              log(value);
                              FocusScope.of(context).requestFocus(_focusNode2);
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController2,
                          focusNode: _focusNode2,
                          onChanged: (value){
                            if (value.isNotEmpty){
                              FocusScope.of(context).requestFocus(_focusNode3);
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController3,
                          focusNode: _focusNode3,
                          onChanged: (value){
                            if (value.isNotEmpty){
                              FocusScope.of(context).requestFocus(_focusNode4);
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController4,
                          focusNode: _focusNode4,
                          onChanged: (value){
                            if (value.isNotEmpty){
                              FocusScope.of(context).requestFocus(_focusNode5);
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController5,
                          focusNode: _focusNode5,
                          onChanged: (value){
                            if (value.isNotEmpty){
                              FocusScope.of(context).requestFocus(_focusNode6);
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(209, 208, 207, 0.34),
                            borderRadius: BorderRadius.circular(3)
                        ),
                        width: 38,
                        height: 38,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: codeController6,
                          focusNode: _focusNode6,
                          onChanged: (value){
                            // if (value.isNotEmpty){
                            //   FocusScope.of(context).requestFocus(_focusNode2);
                            // }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 10),
                            // border: OutlineInputBorder(borderSide: BorderSide.none),
                            border: InputBorder.none, // 移除所有边框
                            enabledBorder: InputBorder.none, // 非聚焦状态下的边框样式
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 51,),

                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    codeYanZheng();
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
                      '确认',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     if (codeController.text.isEmpty) {
                //       BotToast.showText(text: '请输入验证码');
                //       return;
                //     }
                //     //验证验证码
                //     codeYanZheng();
                //   },
                //   child: Container(
                //     margin: const EdgeInsets.only(left: 25, right: 25),
                //     height: 50,
                //     alignment: Alignment.center,
                //     decoration: const BoxDecoration(
                //         color: Color(0xffFE7A24),
                //         borderRadius: BorderRadius.all(Radius.circular(25))),
                //     child: Text(
                //       (widget.havePhoneNumber ?? false) ? '确认' : '确定',
                //       style: const TextStyle(
                //           color: Colors.white,
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
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
        FocusScope.of(context).requestFocus(_focusNode1);
      });
      _startTimer();
    }
  }

  ///获取验证码
  void _getCode() async {
    if (isClickDisable == true) {
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
    // if (oriPhone.isEmpty) {
    //   return;
    // }
    log('输入的验证码'+codeController1.text+codeController2.text+codeController3.text+
        codeController4.text+codeController5.text+codeController6.text);
    if (codeController1.text.isEmpty||codeController2.text.isEmpty||codeController3.text.isEmpty||
        codeController4.text.isEmpty||codeController5.text.isEmpty||codeController6.text.isEmpty) {
      BotToast.showText(text: '请填写完整验证码');
      return;
    }
    return;
    MTEasyLoading.showLoading('');

    NetWorkService service = await NetWorkService().init();
    service.post(
      Apis.codeYanZheng,
      data: {'mobile': oriPhone, 'code': codeController1.text+codeController2.text+codeController3.text+
          codeController4.text+codeController5.text+codeController6.text},
      successCallback: (data) {
        MTEasyLoading.dismiss();
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext ccontext) {
        //       return ChangePasswordPage(
        //         codeStr: codeController.text,
        //       );
        //     }));
      },
      failedCallback: (data) {
        MTEasyLoading.dismiss();
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
    codeController1.dispose();
    codeController2.dispose();
    codeController3.dispose();
    codeController4.dispose();
    codeController5.dispose();
    codeController6.dispose();
    _cancleTimer();
    super.dispose();
  }
}
