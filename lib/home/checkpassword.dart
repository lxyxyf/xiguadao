import 'dart:async';
import 'dart:developer';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../main_page.dart';
import '../network/network_manager.dart';

class Checkpassword extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  Checkpassword(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<Checkpassword> {

  TextEditingController codeController1 = TextEditingController();
  TextEditingController codeController2 = TextEditingController();
  TextEditingController codeController3 = TextEditingController();
  TextEditingController codeController4 = TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();

  ///原始手机号
  String oriPhone = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getLoginAccount();
    });

  }

  _getLoginAccount(){
    if(mounted){
      setState(() {
        FocusScope.of(context).requestFocus(_focusNode1);
      });
    }
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_ios),
                        const SizedBox(
                          width: 11,
                        ),
                        const Text(
                          '开启青少年模式',
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 75.5,
                ),
                const Text(
                  '验证密码',
                  style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 11,
                ),
                Text(
                  '请输入密码进行验证',
                  style: const TextStyle(color: Color(0xff999999), fontSize: 14),
                ),

                const SizedBox(
                  height: 24,
                ),

                Container(
                  width: 38*4+30,
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
                            EdgeInsets.symmetric(vertical: -16, horizontal: 0),
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
                            EdgeInsets.symmetric(vertical: -16, horizontal: 0),
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
                            EdgeInsets.symmetric(vertical: -16, horizontal: 0),
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
                            }
                          },
                          maxLength: 1,
                          showCursor: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding:
                            EdgeInsets.symmetric(vertical: -16, horizontal: 0),
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





  ///验证码验证
  void codeYanZheng() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String? password = share.getString('qingshaonianPassword');
    // if (oriPhone.isEmpty) {
    //   return;
    // }

    log('输入的验证码'+codeController1.text+codeController2.text+codeController3.text+
        codeController4.text);
    if (codeController1.text.isEmpty||codeController2.text.isEmpty||codeController3.text.isEmpty||
        codeController4.text.isEmpty) {
      BotToast.showText(text: '请填写完整密码');
      return;
    }
    if (password==codeController1.text+codeController2.text+codeController3.text+
        codeController4.text){

    }else{
      BotToast.showText(text: '密码错误');
      return;
    }
    BotToast.showText(text: '开启成功，进入青少年模式');
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    await sharedPreferences.setString('qingshaonianmoshi', 'true');
    Future.delayed(Duration(milliseconds: 500), () {
      //执行代码写在这里
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>  MainPage(),
        ),
            (route) => false,
      );
    });


    return;
    MTEasyLoading.showLoading('');

    NetWorkService service = await NetWorkService().init();
    service.post(
      Apis.codeYanZheng,
      data: {'mobile': oriPhone, 'code': codeController1.text+codeController2.text+codeController3.text+
          codeController4.text},
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



  @override
  void dispose() {
    BotToast.cleanAll();
    codeController1.dispose();
    codeController2.dispose();
    codeController3.dispose();
    codeController4.dispose();
    super.dispose();
  }
}
