import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tobias/tobias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xinxiangqin/agreement/user_agent_page.dart';
import 'package:xinxiangqin/home/qingshaonian_already_open.dart';
import 'package:xinxiangqin/mine/alert_dialog_page.dart';
import 'package:xinxiangqin/mine/change_password_page.dart';
import 'package:xinxiangqin/mine/delete_account_page.dart';
import 'package:xinxiangqin/mine/face_verify.dart';
import 'package:xinxiangqin/mine/notification_control_page.dart';
import 'package:xinxiangqin/mine/privacy_policy_page.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../home/qingshaonian_dialog.dart';
import '../home/qingshaonian_open.dart';
import '../hongniang/zixundialog.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import 'chat_page.dart';

class SetPage extends StatefulWidget {
  const SetPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SetPageState();
  }
}

class SetPageState extends State<SetPage> {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  String cacheSize = '0M';
  String certifyId = '';
  Map userInfoDic = {};
  Fluwx fluwx = Fluwx();

  bool _isSwitched = false;
  Tobias tobias = Tobias();

  String morningBegin = '';
  String morningEnd = '';
  String afternoonBegin = '';
  String afternoonEnd = '';
  Map<String, dynamic> serviceDic = {};
  @override
  void initState() {
    super.initState();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");

    getUserInfo();
    getSize();
    getNotificationStatus();
    _getBaseInfo();

  }

  ///获取基础配置
  void _getBaseInfo() async {
    MTEasyLoading.showLoading('加载中');
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      MTEasyLoading.dismiss();
      //
      if (data!=null){
        setState(() {
          serviceDic = data;
          morningBegin=timestampToDateString(data['morningBegin']);
          morningEnd= timestampToDateString(data['morningEnd']);
          afternoonBegin= timestampToDateString(data['afternoonBegin']);
          afternoonEnd= timestampToDateString(data['afternoonEnd']);
        });
      }

    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }

  String timestampToDateString(int timestamp) {
    // 将时间戳转换为DateTime对象
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // 使用intl包的DateFormat格式化日期
    final formatter = DateFormat('HH:mm');

    // 将DateTime对象格式化为字符串
    return formatter.format(dateTime);
  }

  bool isTimeBetween(String start, String end) {
    final now = DateTime.now();
    TimeOfDay startTime = TimeOfDay(hour: int.parse(start.split(':').first), minute: int.parse(start.split(':').last));
    TimeOfDay endTime = TimeOfDay(hour: int.parse(end.split(':').first), minute: int.parse(end.split(':').last));

    // 将当前时间与开始和结束时间转换为TimeOfDay
    TimeOfDay nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
    startTime.hour;
    if (nowTime.hour>startTime.hour&&nowTime.hour<endTime.hour){
      return true;
    }

    if (nowTime.hour<startTime.hour||nowTime.hour>endTime.hour){
      return false;
    }

    if (nowTime.hour==startTime.hour&&nowTime.minute<startTime.minute){
      return false;
    }

    if (nowTime.hour==startTime.hour&&nowTime.minute>=startTime.minute){
      return true;
    }

    if (nowTime.hour==endTime.hour&&nowTime.minute<endTime.minute){
      return true;
    }

    // 将TimeOfDay转换为毫秒比较
    // final nowMillis = nowTime.;
    // final startMillis = startTime.inMilliseconds;
    // final endMillis = endTime.inMilliseconds;

    // 如果当前时间在开始和结束时间之后，则返回false
    // if (nowMillis > endMillis || nowMillis < startMillis) {
    //   return false;
    // }
    return false;
  }

  getNotificationStatus()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = sharedPreferences.getBool('PersonSetStatus')!;
    });
  }

  //关闭推送
  closeJGPush()async{
    log('关闭推荐');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('PersonSetStatus',false);
  }


  //恢复极光推送
  resumeJGPush()async{
    log('开启推荐');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('PersonSetStatus',true);
  }

  gochat(){
    Map<String, dynamic> userInfoDic = {
      'id':'1',
      'nickname':'官方客服',
    };
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext ccontext) {
          return  ChatPage(userInfoDic: userInfoDic);
        }));
  }


  showKefu(){
    showDialog(
        useSafeArea:false,
        context:context,
        builder:(context){
          return Zixundialog(
            morningBegin:serviceDic['morningBegin'].toString(),
            morningEnd: serviceDic['morningEnd'].toString(),
            afternoonBegin: serviceDic['afternoonBegin'].toString(),
            afternoonEnd: serviceDic['afternoonEnd'].toString(),
          );
        }
    );
  }



  /// 支付宝支付
  void toAliPay() async {
    //检测是否安装支付宝
    var result = await tobias.isAliPayInstalled;
    if(result){
      log("安装了支付宝");
      // var payResult = await tobias.pay(orderInfo);
      //
      // if (payResult['result'] != null) {
      //   if (payResult['resultStatus'] == '9000') {
      //     log("支付宝支付成功");
      //
      //   } else if (payResult['resultStatus'] == '6001') {
      //     log("支付宝支付失败");
      //   } else {
      //     log("未知错误");
      //   }
      // }
    } else {
      log("未安装支付宝");
    }
  }





//获取用户信息
  getUserInfo()async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
          log('设置界面'+data.toString());
          setState(() {
            userInfoDic = data;
          });
        }, failedCallback: (data) {});
  }
  //立即实名认证
  rightNameAuth()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const FaceVerify();
        }));
    getUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFFAFAFA),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top + 24,
              padding: const EdgeInsets.only(left: 15, bottom: 5),
              alignment: Alignment.bottomLeft,
              color: Colors.white,
              child:GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child:  Row(
                  children: [
                    GestureDetector(

                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 11,
                    ),
                    const Text(
                      '设置',
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
                            //更换手机号
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return ChangePasswordPage(
                                    havePhoneNumber: true,
                                    photoNumber: '',
                                  );
                                }));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(7.5))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '更换手机',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),




                        const SizedBox(
                          height: 12.5,
                        ),
                        //青少年模式
                        GestureDetector(
                          onTap: ()async{
                            SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                            String? qingshaonianmoshiStatus = sharedPreferences.getString('qingshaonianmoshi');
                            if (qingshaonianmoshiStatus!=null){
                              if (qingshaonianmoshiStatus=='true'){
                                //青少年模式
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext ccontext) {
                                      return QingshaonianAlreadyOpen(
                                        havePhoneNumber: true,
                                        photoNumber: '',
                                      );
                                    }));
                              }else{
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (BuildContext ccontext) {
                                      return QingshaonianOpen(
                                        havePhoneNumber: true,
                                        photoNumber: '',
                                      );
                                    }));
                              }
                            }else{
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext ccontext) {
                                    return QingshaonianOpen(
                                      havePhoneNumber: true,
                                      photoNumber: '',
                                    );
                                  }));
                            }

                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(7.5))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '青少年模式',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),



                        const SizedBox(
                          height: 12.5,
                        ),
                        //在线客服
                        GestureDetector(
                          onTap: ()async{
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        width:
                                        MediaQuery.of(context).size.width - 30,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                          children: [
                                            const Text(
                                              '拨打客服电话',
                                              style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 12.5,
                                            ),
                                            Container(
                                              height: 0.5,
                                              color: const Color(0xffEEEEEE),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                                onTap: () async{
                                                  final Uri url = Uri.parse('tel:18953386687');
                                                  if (await canLaunchUrl(url)) {
                                                  await launchUrl(url);
                                                  } else {
                                                  throw 'Could not launch $url';
                                                  }

                                                },
                                                child:  Container(
                                                  alignment: Alignment.center,
                                                  width:
                                                  MediaQuery.of(context).size.width - 30,
                                                  child: Text(
                                                    '18953386687',
                                                    style: TextStyle(
                                                        color: Color(0xffD81E06),
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                )
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width -
                                              30,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '取消',
                                            style: TextStyle(
                                                color: Color(0xff4794F4),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  );
                                });


                            // log(morningBegin+morningEnd+afternoonBegin+afternoonEnd);
                            // bool ischaoshi = isTimeBetween(morningBegin,morningEnd);
                            // bool ischaoshi1 = isTimeBetween(afternoonBegin,afternoonEnd);
                            // ischaoshi||ischaoshi1?gochat():showKefu();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(7.5))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '在线客服',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),


                        const SizedBox(
                          height: 12.5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // 跳转实名认证

                          userInfoDic['haveNameAuth']!=1?  rightNameAuth(): MTEasyLoading.showToast('您已完成实名');
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(7.5),topRight: Radius.circular(7.5))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '实名认证',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),




                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const NotificationControlPage();
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '新消息通知',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),


                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const NotificationControlPage();
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '个性化推荐',
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
                              ],
                            ),
                          ),
                        ),


                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const UserAgentPage();
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '服务协议',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const PrivacyPolicyPage();
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '隐私政策',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          onTap: () {
                            //清除缓存
                            showDialog(
                                context: context,
                                builder: ((ctx) {
                                  return ShowAlertDialog(
                                    onTap: (index) {
                                      //0.取消 1.确定

                                      if (index == 1) {
                                        clickClearCache();
                                      }
                                    },
                                    itemTitles: [
                                      DialogItem(
                                        title: '取消',
                                        color: const Color(0xff999999),
                                      ),
                                      DialogItem(
                                          title: '确认', color: const Color(0xffFE7A24))
                                    ],
                                    title: '清除缓存',
                                    content: '所有缓存数据将会被清除',
                                  );
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '清除缓存',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          cacheSize,
                                          style: const TextStyle(
                                              color: Color(0xff999999), fontSize: 14),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Color.fromRGBO(171, 171, 171, 1.0),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 11, right: 11),
                          height: 0.5,
                          color: const Color(0xffEEEEEE),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                  return const DeleteAccountPage();
                                }));
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(7.5),bottomRight: Radius.circular(7.5))),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '注销账号',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12.5,
                        ),
                        GestureDetector(
                          onTap: () {
                            //退出登录
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (BuildContext context) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        width:
                                        MediaQuery.of(context).size.width - 30,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Column(
                                          children: [
                                            const Text(
                                              '确认退出登录?',
                                              style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontSize: 14),
                                            ),
                                            const SizedBox(
                                              height: 12.5,
                                            ),
                                            Container(
                                              height: 0.5,
                                              color: const Color(0xffEEEEEE),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                                behavior: HitTestBehavior.translucent,
                                              onTap: () {
                                                quitLogin();

                                              },
                                              child:  Container(
                                                alignment: Alignment.center,
                                                width:
                                                MediaQuery.of(context).size.width - 30,
                                                child: Text(
                                                  '退出登录',
                                                  style: TextStyle(
                                                      color: Color(0xffD81E06),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width -
                                              30,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          alignment: Alignment.center,
                                          child: const Text(
                                            '取消',
                                            style: TextStyle(
                                                color: Color(0xff4794F4),
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.only(left: 11, right: 6),
                            color: Colors.white,
                            alignment: Alignment.centerLeft,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '退出',
                                  style: TextStyle(
                                      color: Color(0xff333333), fontSize: 14),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color.fromRGBO(171, 171, 171, 1.0),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  showQingshaonian(){
    showDialog(
        barrierDismissible:false,
        context: context,
        builder: ((ctx) {
          return QingshaonianDialog(

            OntapCommit: ()async{
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ccontext) {
                    return QingshaonianOpen(
                      havePhoneNumber: true,
                      photoNumber: '',
                    );
                  }));
            },
            CancelCommit: ()async{
              Navigator.pop(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (BuildContext ccontext) {
              //       return QingshaonianOpen(
              //         havePhoneNumber: true,
              //         photoNumber: '',
              //       );
              //     }));
            },
            yinsizhengceClick: (){

            },
            fuwuxieyiClick: (){

            },
          )


          ;
        }));
  }

  ///MARK: -- 缓存
  getSize() async {
    final tempDir = await getTemporaryDirectory();
    final cache = await getTotalSizeOfFilesInDir(tempDir);
    final sizeStr = renderSize(cache);
    cacheSize = sizeStr;
    setState(() {});
  }

  ///清理缓存
  void clickClearCache() async {
    MTEasyLoading.showLoading('清理中');
    Future.delayed(const Duration(milliseconds: 800), () async {
      try {
        final tempDir = await getTemporaryDirectory();
        await requestPermission(tempDir);
        MTEasyLoading.dismiss();
        MTEasyLoading.showToast('缓存已经清理');
        getSize();
      } catch (err) {
        MTEasyLoading.dismiss();
        MTEasyLoading.showToast('清除失败');
      }
    });
  }

  //循环获取缓存大小
  static Future getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    //  File

    if (file is File && file.existsSync()) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory && file.existsSync()) {
      List children = file.listSync();
      double total = 0;
      if (children.isNotEmpty)
        // ignore: curly_braces_in_flow_control_structures
        for (final FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
      return total;
    }
    return 0;
  }

  //格式化文件大小
  static String renderSize(value) {
    if (value == null) {
      return '0.0';
    }
    List<String> unitArr = []
    // ignore: prefer_inlined_adds
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  static Future<void> requestPermission(FileSystemEntity file) async {
    PermissionStatus status = await Permission.storage.status;
    await delDir(file);
  }

  static Future<void> delDir(FileSystemEntity file) async {
    if (file is Directory && file.existsSync()) {
      final List<FileSystemEntity> children =
      file.listSync(recursive: true, followLinks: true);
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    try {
      if (file.existsSync()) {
        await file.delete(recursive: true);
      }
    } catch (err) {}
  }

  ///退出登录
  void quitLogin() async {
    V2TimCallback logoutRes = await TencentImSDKPlugin.v2TIMManager.logout();
    // 反初始化 SDK
    TencentImSDKPlugin.v2TIMManager.unInitSDK();
    _coreInstance.logout();
    if(logoutRes.code == 0){
    }
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

  @override
  void dispose() {
    MTEasyLoading.dismiss();

    super.dispose();
  }
}
