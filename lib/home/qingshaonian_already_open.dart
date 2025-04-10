import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/home/changepassword.dart';
import 'package:xinxiangqin/home/closeqingshaonianmoshi.dart';
import 'package:xinxiangqin/home/qingshaonianxieyi.dart';
import 'package:xinxiangqin/home/sendcode.dart';
import 'package:xinxiangqin/home/setpassword.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../mine/change_password_page.dart';
import '../network/network_manager.dart';

class QingshaonianAlreadyOpen extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  QingshaonianAlreadyOpen(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<QingshaonianAlreadyOpen> {

  ///是否同意用户协议和隐私政策
  bool isAgree = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
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
                        child:
                        Row(
                          children: [
                            const Icon(Icons.arrow_back_ios),
                            const SizedBox(
                              width: 11,
                            ),
                            const Text(
                              '青少年模式',
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
                      height: 20.5,
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width-89-89,
                      height: 121.5*(MediaQuery.of(context).size.width-89-89)/197,
                      child: Image(image: AssetImage('images/home/openqingshaoniantop.png')),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Container(
                      child: Text(
                        '青少年模式已开启',
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 14.5,),

                    Container(
                      margin: EdgeInsets.only(left: 27,right: 27),
                      alignment: Alignment.center,
                      child: Text(
                        textAlign: TextAlign.center,
                        '为呵护未成年人健康成长,西瓜岛特别推出青少年模式，'
                            '该模式下部分功能无法正常使用。请监护人主动选择，并设置监护密码。',
                        style: TextStyle(
                            color: Color(0xff999999),
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 51,),

              Container(
                  margin: EdgeInsets.only(bottom: 96.5),
                  child: GestureDetector(
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
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 26, right: 25),
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: Color(0xffFE7A24),
                              borderRadius: BorderRadius.all(Radius.circular(25))),
                          child: Text(
                            '关闭青少年模式',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        // GestureDetector(
                        //   onTap: (){
                        //     Navigator.push(context,
                        //         MaterialPageRoute(builder: (BuildContext ccontext) {
                        //           return Changepassword(
                        //             codeStr: '111111',
                        //           );
                        //         }));
                        //   },
                        //   child: Container(
                        //     margin: const EdgeInsets.only(top: 10),
                        //     padding: const EdgeInsets.only(bottom: 0),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         const Text(
                        //           '修改密码',
                        //           style:
                        //           TextStyle(color: Color(0xff999999), fontSize: 12,fontWeight: FontWeight.w500),
                        //         ),
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
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
          return Closeqingshaonianmoshi(
            codeStr: '111111',
          );
        }));
  }



  @override
  void dispose() {
    super.dispose();
  }
}
