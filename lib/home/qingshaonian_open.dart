import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/home/checkpassword.dart';
import 'package:xinxiangqin/home/qingshaonianxieyi.dart';
import 'package:xinxiangqin/home/sendcode.dart';
import 'package:xinxiangqin/home/setpassword.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import '../mine/change_password_page.dart';
import '../network/network_manager.dart';

class QingshaonianOpen extends StatefulWidget {
  final bool? havePhoneNumber;
  final String? photoNumber;
  String codeStr;
  QingshaonianOpen(
      {super.key, this.havePhoneNumber, this.photoNumber, this.codeStr = ''});

  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<QingshaonianOpen> {

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
                        '青少年模式',
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
                           '我知道了',
                           style: const TextStyle(
                               color: Colors.white,
                               fontSize: 14,
                               fontWeight: FontWeight.bold),
                         ),
                       ),

                       Container(
                         margin: const EdgeInsets.only(top: 10),
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
                               '我已阅读并同意',
                               style:
                               TextStyle(color: Color(0xff999999), fontSize: 12,fontWeight: FontWeight.w500),
                             ),
                             GestureDetector(
                               onTap: () {
                                 Navigator.push(context, MaterialPageRoute(
                                     builder: (BuildContext context) {
                                       return Qingshaonianxieyi(
                                       );
                                     }));
                               },
                               child: const Text(
                                 '《西瓜岛青少年模式功能使用条款》',
                                 style:
                                 TextStyle(color: Color(0xffFE7A24), fontSize: 12,fontWeight: FontWeight.w500),
                               ),
                             ),

                           ],
                         ),
                       ),
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
    if (isAgree==false){
      BotToast.showText(text: '请先阅读并同意《西瓜岛青少年模式功能使用条款》');
      return;
    }
    SharedPreferences share = await SharedPreferences.getInstance();
    String? password = share.getString('qingshaonianPassword');
    if(password!=null){
      //发送成功后跳转
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return Checkpassword(
              codeStr: '111111',
            );
          }));
    }else{
      //发送成功后跳转
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return Setpassword(
              codeStr: '111111',
            );
          }));
    }

  }



  @override
  void dispose() {
    BotToast.cleanAll();
    super.dispose();
  }
}
