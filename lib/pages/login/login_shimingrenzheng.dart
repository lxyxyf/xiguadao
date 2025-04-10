import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/agreement/agreement_info_page.dart';
import 'package:xinxiangqin/mine/newmine.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

import 'package:aliyun_face_plugin/aliyun_face_plugin.dart';

import '../../main_page.dart';
import '../../message/generateUserSig.dart'; // 阿里云实名认证

class LoginShimingrenzheng extends StatefulWidget {
  const LoginShimingrenzheng({super.key});

  @override
  State<StatefulWidget> createState() {
    return FaceVerifyState();
  }
}

class FaceVerifyState extends State<LoginShimingrenzheng> {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  String userAgreement = '';
  String privacyAgreement = '';
  bool isAgree = false; // 是否同意用户协议和隐私政策
  final _aliyunFacePlugin = AliyunFacePlugin(); // 实名认证
  Map<String, dynamic> userInfoDic = {};

  // 获取控制器
  TextEditingController nameController = TextEditingController();
  TextEditingController identityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _coreInstance.init(
        sdkAppID: 1600029298, // Replace 0 with the SDKAppID of your IM application when integrating
        // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
        loglevel: LogLevelEnum.V2TIM_LOG_ALL,
        onTUIKitCallbackListener:  (TIMCallback callbackValue){

          log('聊天错误'+callbackValue.infoRecommendText.toString());
        }, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
        listener: V2TimSDKListener());
    initChatInfo();
    _getBaseInfo();
    getuserInfo();// 获取基础信息
  }

  initChatInfo()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    String usersig = GenerateDevUsersigForTest(sdkappid: 1600029298, key: 'fdb5b8018dfda4cedc7eacd833d709cfca144ea2e614217a3652cef0873f9cfa').genSig(identifier: userId, expire: 86400);
    log('前端生成的'+usersig.toString());
    _coreInstance.login(userID: userId,userSig: usersig
      // userSig: 'eJwtzEsLgkAYheH-MuuQcZobQqsiA61FGdTsyhmnjyzHK0X03zN1eZ4Xzgcl8cHrTIUCRDyMZsMGbZ4NZDBwW5uK5DClWt8vzoFGgc8xxkxyycZiXg4q0ztjjPRp1AYefxNzTCnlXEwvYPvnVKx9fMzb96a0oVqe7DVSe0kLW8bKrG7FLtNJGoVtd94u0PcHpycypw__'
    );
  }


  getuserInfo() async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {
      setState(() {
        userInfoDic = data;
      });
        }, failedCallback: (data) {
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // title: const Text('实名认证'),
      // ),
      body: _bodyView(),
      resizeToAvoidBottomInset: true,
    );
  }

  /// 自定义 主内容
  Widget _bodyView() {
    return GestureDetector(
      onTap: () {
        //点击空白区域，键盘收起
        //收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      // 主内容区
      // 主内容区
      child: Stack(
        children: [
          // 背景颜色
          Container(
            color: const Color.fromARGB(255, 243, 245, 249),
          ),

          // 顶部背景图片
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300.0, // 设置顶部背景图片的高度
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/face_verify_bg.png'), // 本地图片
                  fit: BoxFit.cover, // 设置图片填充模式
                ),
              ),
            ),
          ),

          // 主内容视图
          Positioned.fill(
            child: Container(
              child: Column(
                children: [
                  // 表单
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // 自定义顶部栏
                          _topBarView(),
                          // 标题 banner
                          _bannerView(),
                          // 表单
                          _formView(),
                          // 提示信息
                          _noteView(),
                        ],
                      ),
                    ),
                  ),
                ],
              ), // 你的内容
            ),
          ),
        ],
      ),
    );
  }

  // 自定义 顶部栏
  Widget _topBarView() {
    return Container(
      height: MediaQuery.of(context).padding.top + 24,
      padding: const EdgeInsets.only(left: 15, bottom: 5),
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),

           GestureDetector(
             onTap: ()async{
               SharedPreferences sharedPreferences =
                   await SharedPreferences.getInstance();
               await sharedPreferences.setString('isFirstLogin', 'yes');
               await sharedPreferences.setString('hulueshiming', 'yes');
               sendKefuMessage();
             },
             child:Container(
               margin: EdgeInsets.only(right: 15),
               child: Text(
                 '跳过',
                 style: TextStyle(
                     color: Color(0xff666666),
                     fontSize: 15,
                     fontWeight: FontWeight.w500),
               ),
             ),
           )
        ],
      ),
    );
  }

  // 自定义 Banner
  Widget _bannerView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      alignment: Alignment.bottomLeft,
      child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // 对齐方式
          children: [
            Text(
              '实名认证',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '更加真实，更受欢迎',
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ]
      ),
    );
  }



  // 自定义 表单
  Widget _formView() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25),
      decoration: BoxDecoration(
        color: Colors.white,  // 设置背景颜色
        borderRadius: BorderRadius.circular(10),  // 设置圆角半径
      ),
      clipBehavior: Clip.hardEdge,  // 启用裁剪，防止溢出
      child: Column(
        children: [
          // 提示信息
          Container(
            width: double.infinity,  // 占用一整行
            color: const Color.fromARGB(255, 243, 245, 249),  // 设置背景颜色
            padding: const EdgeInsets.only(left: 25),
            child: const Text(
              '请您使用有效身份证信息认证！',
              style: TextStyle(
                height: 4,
                fontSize: 16,
                color: Color(0xff333333),
              ),
              // textAlign: TextAlign.center,  // 文本居中
            ),
          ),
          // 输入框
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      // Image.asset(
                      //   'images/icon_phone.png',
                      //   width: 9.5,
                      //   height: 13.5,
                      // ),
                      const SizedBox(
                        width: 8.5,
                      ),
                      const Text(
                        '真实姓名' ,
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
                            controller: nameController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                hintText: '请输入您的真实姓名',
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
                      // Image.asset(
                      //   'images/icon_code.png',
                      //   width: 9.5,
                      //   height: 13.5,
                      // ),
                      const SizedBox(
                        width: 8.5,
                      ),
                      const Text(
                        '证件号码',
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
                            controller: identityController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                hintText: '请输入您的真实证件号码',
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
          // 立即认证
          GestureDetector(
            onTap: () {
              _save();
            },
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - 50,
              margin: const EdgeInsets.all(25),
              height: 50,
              decoration: const BoxDecoration(
                  color: Color(0xffFE7A24),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: const Text(
                '立即认证',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
          ),
          // 协议
          // Container(
          //   margin: const EdgeInsets.only(bottom: 25),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             isAgree = !isAgree;
          //           });
          //         },
          //         child: Container(
          //           width: 12.5,
          //           height: 12.5,
          //           decoration: const BoxDecoration(
          //               borderRadius: BorderRadius.all(
          //                   Radius.circular(12.5 / 2.0))),
          //           child: Image.asset(
          //             isAgree
          //                 ? 'images/select.png'
          //                 : 'images/unselect.png',
          //             width: 12.5,
          //             height: 12.5,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         width: 10,
          //       ),
          //       const Text(
          //         '勾选后点击前往认证，即同意',
          //         style:
          //         TextStyle(color: Color(0xff999999), fontSize: 12),
          //       ),
          //       GestureDetector(
          //         onTap: () {
          //           if (userAgreement.isNotEmpty) {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (BuildContext context) {
          //                       return AgreementInfoPage(
          //                           htmlStr: userAgreement,
          //                           title: '《人脸认证服务协议》'
          //                       );
          //                     }
          //                 )
          //             );
          //           }
          //         },
          //         child: const Text(
          //           '《人脸认证服务协议》',
          //           style:
          //           TextStyle(color: Color(0xffFE7A24), fontSize: 12),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // 自定义 提示信息
  Widget _noteView() {
    return Container(
      width: double.infinity,  // 占用一整行
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,  // 设置背景颜色
        borderRadius: BorderRadius.circular(7.5),  // 设置圆角半径
      ),
      clipBehavior: Clip.hardEdge,  // 启用裁剪，防止溢出
      child: const Text(
        '实名仅用于您是否为真人用户，不会对信息做任何采集与保留，请放心使用。',
        style: TextStyle(
          fontSize: 11,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  // [方法] 提交表单
  void _save() async {
    // 获取姓名
    String nameStr = nameController.text.replaceAll(' ', '');
    String identityStr = identityController.text.replaceAll(' ', '');

    debugPrint('-- 提交表单 ----------------------------------> name: $nameStr');
    debugPrint('-- 提交表单 ----------------------------------> identity: $identityStr');

    if (nameController.text.isEmpty) {
      BotToast.showText(text: '姓名不能为空');
      return;
    }

    if (identityController.text.isEmpty) {
      BotToast.showText(text: '身份证不能为空');
      return;
    }

    if (!isIDCard(identityStr)) {
      BotToast.showText(text: '身份证格式不合法');
      return;
    }

    MTEasyLoading.showLoading('正在请求');
    NetWorkService service = await NetWorkService().init();
    service.post(
        Apis.idCardAuthentication,
        data: {
          'certName':nameController.text,
          'certNo':identityController.text
        },
        successCallback: (res) async {
          log('实名认证的请求接口'+res.toString());
          updateMemberUser(nameStr, identityStr); // 更新用户信息
        },
        failedCallback: (data) {
          MTEasyLoading.dismiss();
          BotToast.closeAllLoading();
        }
    );



    // if (!isAgree) {
    //   BotToast.showText(text: '请阅读并同意用户协议和隐私政策');
    //   return;
    // }

    // MTEasyLoading.showLoading('开始认证');
    // // 1、获取认证ID
    // final metaInfos = await getMetaInfos();
    // debugPrint('metaInfos: --------------> $metaInfos');
    // // 2、获取认证ID
    // final certifyId = await getCertifyId({
    //   'certName': nameStr,
    //   'certNo': identityStr,
    //   'metaInfo': metaInfos,
    // });
    // // 3、调用认证
    // debugPrint('certifyId: --------------> $certifyId');
    // await startVerify(certifyId, nameStr, identityStr);
  }

  // [方法] 获取基础配置
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

  // [方法] 身份证验证规则
  bool isIDCard(String input) {
    // 正则表达式，匹配18位身份证号
    RegExp idCardPattern = RegExp(
      r'^(?:\d{17}[\dX]|[1-9]\d{5}(?:\d{2}(?:0[1-9]|1[0-2])(?:[0-2][0-9]|3[0-1])|[0-9]{3}))$',
    );
    return idCardPattern.hasMatch(input);
  }

  // [人脸] 获取客户端 MetaInfos
  Future<String> getMetaInfos() async {
    String metaInfos = '';

    try {
      // 获取客户端 MetaInfos，将信息发送到服务器端，调用服务器端相关接口获取认证ID，即CertifyId。
      metaInfos = await _aliyunFacePlugin.getMetaInfos() ?? 'Unknown MetaInfos';
    } on PlatformException {
      metaInfos = 'Failed to get MetaInfos.';
    }

    return metaInfos;
  }

  // [人脸] 获取 CertifyId
  Future<String> getCertifyId(Object params) async {
    // 确保异步操作完成后才返回数据
    Completer<String> completer = Completer<String>();

    debugPrint('getCertifyIdParams: >>>>>>>>>>>>>> $params');

    // 获取 CertifyId
    MTEasyLoading.showLoading('正在请求');
    NetWorkService service = await NetWorkService().init();
    service.post(
        Apis.identityAuthentication,
        data: params,
        successCallback: (res) async {
          MTEasyLoading.dismiss();

          debugPrint('getCertifyIdRes: >>>>>>>>>>>>>> $res');

          if (res != null) {
            completer.complete(res);  // 请求成功后，完成 completer
          } else {
            completer.completeError('请求结果为空');
          }
        },
        failedCallback: (data) {
          MTEasyLoading.dismiss();
          BotToast.closeAllLoading();
          completer.completeError('请求失败');
        }
    );

    return completer.future;
  }

  // [人脸] 调用认证接口
  Future<void> startVerify(String certifyId, String nameStr, String identityStr) async {
    String verifyResult;
    try {
      // 调用认证接口，CertifyId需要调用服务器端接口获取。
      // 每个CertifyId只能使用一次，否则会返回code: "2002(iOS), 1001(Android)"。
      verifyResult = await _aliyunFacePlugin.verify(
          "certifyId", certifyId) ?? '-1,error';

      if(verifyResult.contains('1000')) {
        BotToast.showText(text: '刷脸成功!');
        updateMemberUser(nameStr, identityStr); // 更新用户信息
      } else {
        BotToast.showText(text: '刷脸失败!');
        log('失败原因'+verifyResult);
        // updateMemberUser(nameStr, identityStr); // 更新用户信息
      }
    } on PlatformException {
      verifyResult = '-2,exception';
    }

    setState(() {
      debugPrint('verifyResult: >>>>>>>>>>>>>> $verifyResult');
    });
  }

  // 更新用户信息
  void updateMemberUser(String nameStr, String identityStr) async {
    debugPrint('更新用户信息: >>>>>>>>>>>>>> $nameStr / $nameStr');

    // 确保异步操作完成后才返回数据
    Completer<String> completer = Completer<String>();

    // MTEasyLoading.showLoading('正在更新');
    NetWorkService service = await NetWorkService().init();
    service.put(
        Apis.saveUserInfo,
        data: {
          'name': nameStr,
          'idNumber': identityStr,
          'haveReal': 1,
        },
        successCallback: (res) async {
          MTEasyLoading.dismiss();
          BotToast.showText(text: '实名认证成功');

          debugPrint('接口返回结果: >>>>>>>>>>>>>> $res');
          await sendKefuMessage();

          // 返回上一级
          // Navigator.pop(context);

        },
        failedCallback: (data) {
          MTEasyLoading.dismiss();
          BotToast.closeAllLoading();
          completer.completeError('更新失败：$data');
        }
    );
  }


  // jumpshimingtoMain()async{
  //   SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   // sharedPreferences.setString('isFirstLogin', 'yes');
  //   // sharedPreferences.setString('hulueshiming', 'yes');
  //   await sharedPreferences.setString('page', 'mine');
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => MainPage(),
  //     ),
  //         (route) => false,
  //   );
  // }

  //注册流程结束后，客户端用客服账号给用户发送一条消息
  sendKefuMessage()async{

    List msgBodydic = [
      {
        'MsgType':'TIMTextElem',
        "MsgContent":{
          'Text':'嗨，您好！欢迎来到西瓜岛，客服在这里，期待您找到美好缘分！'
      }
      }];

    Map<String,dynamic> dataDic = {
      'fromAccount':1,
      'toAccount':userInfoDic['id'],
      'msgBody':jsonEncode(msgBodydic)
    };

    debugPrint('---传值聊天'+dataDic.toString());
    BotToast.showLoading();
    NetWorkService service = await NetWorkService().init();
    service.post(
        Apis.sendNotification,
        data: dataDic,
        successCallback: (res) async {
          MTEasyLoading.dismiss();
          debugPrint('getCertifyIdRes: >>>>>>>>>>>>>> $res');
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          // await sharedPreferences.setString('page', 'mine');
          //返回主页面
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
                (route) => false,
          );
        },
        failedCallback: (data) {
          BotToast.closeAllLoading();
        }
    );
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
