import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart';
// import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:tencent_cloud_chat_push/tencent_cloud_chat_push.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tobias/tobias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/agreement/user_agent_page.dart';
import 'package:xinxiangqin/home/qingshaonian_already_open.dart';
import 'package:xinxiangqin/mine/alert_dialog_page.dart';
import 'package:xinxiangqin/mine/change_password_page.dart';
import 'package:xinxiangqin/mine/delete_account_page.dart';
import 'package:xinxiangqin/mine/face_verify.dart';
import 'package:xinxiangqin/mine/privacy_policy_page.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';
import 'dart:async';

import '../home/qingshaonian_dialog.dart';
import '../home/qingshaonian_open.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';

class NotificationControlPage extends StatefulWidget {
  const NotificationControlPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SetPageState();
  }
}

class SetPageState extends State<NotificationControlPage> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    getNotificationStatus();
  }


  getNotificationStatus()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = sharedPreferences.getBool('NotificationStatus')!;
    });
  }


//获取用户信息
  getUserInfo()async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          log('设置界面'+data.toString());
          setState(() {
          });
        }, failedCallback: (data) {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAFAFA),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:
              Container(
                height: MediaQuery.of(context).padding.top + 24,
                padding: const EdgeInsets.only(left: 15, bottom: 5),
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                child: Row(
                  children: [
                    GestureDetector(
                      // onTap: () {
                      //   Navigator.pop(context);
                      // },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text(
                      '通知开关',
                      style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(7.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '接收新消息通知',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),

                            CupertinoSwitch(
                              value: _isSwitched,
                              onChanged: (bool value) async{
                                setState(() {
                                  _isSwitched = value;
                                });

                                if (value==false){
                                  closeJGPush();
                                }else{
                                  resumeJGPush();
                                }
                              },
                              activeColor: CupertinoColors.activeGreen,
                              trackColor: CupertinoColors.systemGrey,
                            )
                           // Container(
                           //   width: 80,
                           //   height: 20,
                           //   child:  Switch(
                           //     value: _isSwitched,
                           //     onChanged: (bool value) {
                           //       setState(() {
                           //         _isSwitched = value;
                           //       });
                           //     },
                           //     activeColor: Colors.green, // 打开时的颜色
                           //     inactiveThumbColor: Colors.white, // 关闭时圆形部分的颜色
                           //     inactiveTrackColor: Color(0xffeeeeee), // 关闭时轨道的颜色
                           //   ),
                           // )
                                // Icon(
                                //   Icons.keyboard_arrow_right,
                                //   color: Color.fromRGBO(171, 171, 171, 1.0),
                                // )
                              ],
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  //关闭推送
  closeJGPush()async{
    log('关闭推送');
    // JPush jpush = new JPush();
    // jpush.stopPush();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('NotificationStatus',false);

    // TencentCloudChatPush.disablePostNotificationInForeground(disable: true);
    TencentCloudChatPush().disablePostNotificationInForeground(disable: true);
    //
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String? userID = sharedPreferences.getString('UserId');
  }


  //恢复极光推送
  resumeJGPush()async{
    log('开启推送');
    // JPush jpush = new JPush();
    // jpush.resumePush();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('NotificationStatus',true);
    TencentCloudChatPush().disablePostNotificationInForeground(disable: false);
  }



  @override
  void dispose() {
    MTEasyLoading.dismiss();

    super.dispose();
  }
}
