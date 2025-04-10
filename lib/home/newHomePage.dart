
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:fl_amap/fl_amap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:xinxiangqin/home/home_showdialog_page.dart';
import 'package:xinxiangqin/home/noOpenVipDialog.dart';
import 'package:xinxiangqin/home/peiduisuccess_dialog.dart';
import 'package:xinxiangqin/mine/mine_meseeother_listpage.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_home_page.dart';
import '../hongniang/hongniang_fuwuhome.dart';
import '../message/generateUserSig.dart';
import '../mine/alert_dialog_page.dart';
import '../mine/chat_page.dart';
import '../mine/face_verify.dart';
import '../mine/userinfo_change_page.dart';
import '../network/apis.dart';
import '../network/network_manager.dart';
import '../pages/login/login_page.dart';
import '../shequ/post_detail_page.dart';
import '../post/user_report_page.dart';
import '../user/user_info_page.dart';
import '../vipcenter/vipcenter_home.dart';
import '../widgets/yk_easy_loading_widget.dart';
import '../xingzuo/xingzuo_submit_noreturn.dart';
import '../xingzuo/xingzuo_submit_return.dart';
import 'tags_demo2.dart';
import 'dart:developer';

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FullScreenContainer(),
    );
  }
}

class FullScreenContainer extends StatefulWidget {
  const FullScreenContainer({super.key});

  @override
  State<FullScreenContainer> createState() => _FullScreenContainerState();
}

class _FullScreenContainerState extends State<FullScreenContainer> {

  final ScrollController _scrollController = ScrollController();
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
  Map<String, dynamic> userDic = {};
  Map<String, dynamic> basicDic = {};
  bool get wantKeepAlive => true;
  // 声明实例
  CityPickerUtil cityPickerUtils = CityPickers.utils();
  int selectRow = 0;
  List tagList = [

  ];

  //月收入
  List getMonthIncomeList = [
    '5万以下', '5万-10万','10万-20万','20万-50万'
  ];
  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  //星座标题列表
  final List<String> xingzuoTitleList = [
    '水瓶座','双鱼座','白羊座','金牛座','双子座','巨蟹座','狮子座','处女座','天秤座','天蝎座','射手座','摩羯座'
  ];
//星座图片列表
  final List<String> xingzuoUnselectImageList = [
    'images/xingzuo/shuiping_unselect.png','images/xingzuo/shuangyu_unselect.png','images/xingzuo/baiyang_unselect.png',
    'images/xingzuo/jinniu_unselect.png','images/xingzuo/shuangzi_unselect.png','images/xingzuo/juxie_unselect.png',
    'images/xingzuo/shizi_unselect.png','images/xingzuo/chunv_unselect.png','images/xingzuo/tianping_unselect.png',
    'images/xingzuo/tianxie_unselect.png','images/xingzuo/sheshou_unselect.png','images/xingzuo/mojie_unselect.png'

  ];

  final List<String> xingzuoSelectImageList = [
    'images/xingzuo/shuiping.png','images/xingzuo/shuangyu.png','images/xingzuo/baiyang.png',
    'images/xingzuo/jinniu.png','images/xingzuo/shuangzi.png','images/xingzuo/juxie.png',
    'images/xingzuo/shizi.png','images/xingzuo/chunv.png','images/xingzuo/tianping.png',
    'images/xingzuo/tianxie.png','images/xingzuo/sheshou.png','images/xingzuo/mojie.png'

  ];
  int hasNext = 1;
  double progress = 0;

  double mylatitude = 0;
  double mylongitude = 0;

  List tagList2 = [
    // {'label': '水瓶座', 'select': false},
    // {'label': '天蝎座', 'select': false},
    // {'label': '狮子座', 'select': false},

  ];

  List imgs=[

  ];
  bool canLoadingSeeOther = true;

  List ListData = [];
  List chooseItemArray = ['1'];
  List chooseImageArray = [];
  String backImageUrl = '';
  double _value = 40.0;
  Map userInfoDic = {};

  List dataSource = [];

  double userla =0; // 0.6表示偏右60%（感性）
  double user = 0;

  double _emotionalValue =0; // 0.6表示偏右60%（感性）
  double _pursuitValue = 0; // 修改为0到1的范围
  double _iqValue = 0.5;
  double _eqValue = 0.5;

  bool positionShouquan = false;
  String juli = '';

  @override
  void initState(){
    super.initState();
    _scrollController.addListener(_scrollListener);
    _coreInstance.init(
        sdkAppID: 1600029298, // Replace 0 with the SDKAppID of your IM application when integrating
        // language: LanguageEnum.en, // 界面语言配置，若不配置，则跟随系统语言
        loglevel: LogLevelEnum.V2TIM_LOG_ALL,
        onTUIKitCallbackListener:  (TIMCallback callbackValue){

          log('聊天错误'+callbackValue.infoRecommendText.toString());
        }, // [建议配置，详见此部分](https://cloud.tencent.com/document/product/269/70746#callback)
        listener: V2TimSDKListener());

    // var brightness =
    // !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   // statusBarBrightness: brightness,
    //   // statusBarIconBrightness: brightness,
    //
    // ));



    _getBaseInfo();
    getuserInfo();
    getmineinfo();

    getList();
    initChatInfo();
  }

  initChatInfo()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    String usersig = GenerateDevUsersigForTest(sdkappid: 1600029298, key: 'fdb5b8018dfda4cedc7eacd833d709cfca144ea2e614217a3652cef0873f9cfa').genSig(identifier: userId, expire: 86400);
    log('前端生成的'+usersig.toString());
    await _coreInstance.login(userID: userId,userSig: usersig
      // userSig: 'eJwtzEsLgkAYheH-MuuQcZobQqsiA61FGdTsyhmnjyzHK0X03zN1eZ4Xzgcl8cHrTIUCRDyMZsMGbZ4NZDBwW5uK5DClWt8vzoFGgc8xxkxyycZiXg4q0ztjjPRp1AYefxNzTCnlXEwvYPvnVKx9fMzb96a0oVqe7DVSe0kLW8bKrG7FLtNJGoVtd94u0PcHpycypw__'
    );
    // getChat();
    // getList();
  }


  //配对成功
  peiduisuccess(peiduidicc)async{
    Map<String, dynamic> userdic11 = {};
    userdic11['id'] = peiduidicc['userId'].toString();
    userdic11['nickname'] = peiduidicc['matchNickName'];
    sendKefuMessage(userdic11);
    // Map peiduidicc =
    // {"userId": 10167, "eachOther": 1, "matchNickName": 2222, "matchAge": 0,
    //   "matchAvatar": "https://admin.xiguadao.cc/admin-api/infra/file/0/get/552b4376147a188258dc35a65db45455f01129cc1961fb063d372bae15194c14.jpg",
    //   "ownAvatar": "https://admin.xiguadao.cc/admin-api/infra/file/0/get/b570ef5a051e9718caab968f4ae83317bb596497d025011fa98281a29ccf5f5a.jpg"};
    // showDialog(
    //     context:context,
    //     builder:(context){
    //       return PeiduisuccessDialog(
    //           peiduiDic: peiduidicc,
    //           content: '111',
    //           OntapCommit: ()async{
    //             Navigator.pop(context);
    //             rightToChat(userdic11);
    //           }
    //
    //       );
    //     }
    // );
  }

  void _scrollListener() async{
    if (_scrollController.position.pixels >0) {
      _scrollController.removeListener(_scrollListener);
      //产生了滑动
      print('滑动----'+_scrollController.position.pixels.toString());
      setState(() {
        canLoadingSeeOther = true;
      });
      createBlindMemberSeeMe(ListData[0]);

    }

  }

  ///获取基础配置
  void _getBaseInfo() async {
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      if(mounted){
        setState(() {
          basicDic = data;
          main();
        });
      }
    }, failedCallback: (data) {});
  }

  ///获取数据
  void getList() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getIsSueSeeMeList, queryParameters: {
      'pageNo': '1',
      'pageSize': '10',
    }, successCallback: (data) async {
      if (data!= null) {
        if (mounted){
          setState(() {
            dataSource = data;
          });
        }

      }
    }, failedCallback: (data) {
    });
  }

  userinfochangeshowdialog(content){
    showDialog(
        context:context,
        builder:(context){
          return HomeShowdialogPage(
              content: content,
              OntapCommit: ()async{
                await Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext ccontext) {
                      return const UserinfoChangePage(

                      );
                    }));
                getuserInfo();
              }

          );
        }
    );
  }

  getmineinfo()async{
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.myInformation, queryParameters: {},
        successCallback: (data) async {
          log('myInformation+${data.toString()}');
          if (mounted){ setState(() {
            userDic = data;
          });}
        }, failedCallback: (data) {});
  }

  getuserInfo()async{

    NetWorkService service = await NetWorkService().init();
    service.get(Apis.userInfo, queryParameters: {},
        successCallback: (data) async {

          if (data['correctionStatus'].toString()=='0'){

          }else{
            userinfochangeshowdialog(data['correctionContent'].toString());
          }

          if (data['constellation']==null||data['constellation'].toString()==''){
            quitLogin();
          }
        }, failedCallback: (data) {});
  }

  getuserTuijian() async{

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // String? userID = sharedPreferences.getString('UserId');
    // int? recordyear = sharedPreferences.getInt('${userID}requestYear');
    // int? recordmonth = sharedPreferences.getInt('${userID}requestMonth');
    // int? recordday = sharedPreferences.getInt('${userID}requestDay');
    // int? recordHour = sharedPreferences.getInt('${userID}requestHour');
    // if (sharedPreferences.getString('${userID}jsonData')==''||sharedPreferences.getString('${userID}jsonData')==null){
    // }else{
    //   bool lastRefreshisToday = isToday(recordyear,recordmonth,recordday); //判断上次刷新是不是今天
    //   //如果是今天
    //   if (lastRefreshisToday == true){
    //     //上次刷新是今天，判断到规定的刷新时间了没
    //     //上次刷新时间如果超过了刷新时间，不能刷新，取缓存的数据
    //     if (recordHour!>=basicDic['refreshTime']){
    //       if(mounted){
    //         setState(() {
    //           ListData = jsonDecode(sharedPreferences.getString('${userID}jsonData').toString());
    //           hasNext = sharedPreferences.getInt('${userID}homeHasData')!;
    //           initTagList();
    //         });
    //       }
    //       return;
    //     }else{
    //       //上次刷新没到规定的刷新时间，判断现在到刷新时间了没
    //       DateTime nowTime = DateTime.now();
    //       //当前时间大于等于规定的刷新时间，那就可以刷新了
    //       if (nowTime.hour>=basicDic['refreshTime']){
    //         print('333333');
    //       }else{
    //         //没到点，只能取数据
    //         if (mounted){
    //           setState(() {
    //             ListData = jsonDecode(sharedPreferences.getString('${userID}jsonData').toString());
    //             hasNext = sharedPreferences.getInt('${userID}homeHasData')!;
    //             initTagList();
    //           });
    //         }
    //         return;
    //       }
    //     }
    //
    //   }else{
    //     //如果上次刷新不是今天,判断到刷新时间了没。
    //
    //     DateTime nowTime = DateTime.now();
    //     //当前时间大于等于规定的刷新时间，那就可以刷新了
    //     if (nowTime.hour>=basicDic['refreshTime']){
    //     }else{
    //       //没到点，只能取数据
    //      if (mounted){
    //        setState(() {
    //          ListData = jsonDecode(sharedPreferences.getString('${userID}jsonData').toString());
    //          hasNext = sharedPreferences.getInt('${userID}homeHasData')!;
    //          initTagList();
    //        });
    //      }
    //       return;
    //     }
    //   }
    // }



    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getMatchBlindMembers, queryParameters: {
      'auditStatus': '1',
      'pageNo': '1',
      'pageSize': '1',
      'appType': '1'
    },
        successCallback: (data) async {
          print('1112222222');
          log(data.toString());
          // recordTime();
          String jsonString = json.encode(data);
          // await sharedPreferences.setString('${userID}jsonData', jsonString);
          // await sharedPreferences.setInt('${userID}homeHasData', 1);
          if (mounted){
            setState(() {
              ListData = data!;
              initTagList();
            });
          }
        }, failedCallback: (data) {

        });
  }

  recordTime()async{

    DateTime requestTime = DateTime.now();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('UserId');
    sharedPreferences.setInt('${userID}requestYear', requestTime.year);
    sharedPreferences.setInt('${userID}requestMonth', requestTime.month);
    sharedPreferences.setInt('${userID}requestDay', requestTime.day);
    sharedPreferences.setInt('${userID}requestHour', requestTime.hour);


  }

  bool isToday(recordyear,recordmonth,recordday) {
    final now = DateTime.now();
    return recordyear == now.year &&
        recordmonth == now.month&&
        recordday == now.day;
  }

  void quitLogin() async {
    //删除本地数据
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('UserId');
    sharedPreferences.remove('AccessToken');
    sharedPreferences.remove('RefreshToken');
    await TencentImSDKPlugin.v2TIMManager.logout();
    // 反初始化 SDK
    TencentImSDKPlugin.v2TIMManager.unInitSDK();
    _coreInstance.logout();

    //返回登录
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
          (route) => false,
    );
  }

  //浏览过的次数
  liulanNum()async{
    if(userDic['userLevel'].toString()=='0') {
    }else{
      NetWorkService service = await NetWorkService().init();
      service.post(Apis.businessCardBrowsing, data: {
        'usedBy': ListData[0]['id'],
      },
          successCallback: (data) async {
            log('浏览过卡片'+data.toString());
          }, failedCallback: (data) {

          });
    }

  }


  getMyvipQuanyi()async{
    if(userDic['userLevel'].toString()=='0') {
      netChile();
      BotToast.closeAllLoading();
    }else{
      NetWorkService service = await NetWorkService().init();
      service.get(Apis.memberResidualInterest, queryParameters: {},
          successCallback: (data) async {
            if (data!=null){
              if (data['listPrivilege'][1]['remainingNum']<=0){
                BotToast.closeAllLoading();
                BotToast.showText(text: '您的浏览次数已用完');
                setState(() {
                  hasNext = 0;
                });

              }else{
                BotToast.closeAllLoading();
                netChile();
              }
            }
            BotToast.closeAllLoading();
            log('我的会员权益'+data['listPrivilege'].toString());

          }, failedCallback: (data) {
            BotToast.closeAllLoading();
            setState(() {
              hasNext = 0;
            });
            log('我的权益错误'+data.toString());
          });
    }

  }


  //切换下一个
  netChile()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userID = sharedPreferences.getString('UserId');
    await _scrollController.animateTo(0,
        duration: const Duration(seconds: 1),//动画时间是1秒，
        curve: Curves.fastLinearToSlowEaseIn);//动画曲线

    if (ListData.length>1){
      ListData.removeAt(0);
      String jsonString = json.encode(ListData);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('${userID}jsonData', jsonString);
      await sharedPreferences.setInt('${userID}homeHasData', 1);
      _scrollController.addListener(_scrollListener);
      setState(() {
        ListData;
        hasNext = 1;
        initTagList();
      });
    }else if (ListData.length==1){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setInt('${userID}homeHasData', 0);
      setState(() {
        ListData.removeAt(0);
        hasNext = 0;
        // initTagList();
      });
    }



    // if (ListData.length==1){
    //
    // }
  }

  chooseLike() async{
    BotToast.showLoading();
    String memberid = userInfoDic['id'].toString();
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    Map<String, dynamic> map = {};
    map['issue'] = int.parse(userId);
    map['receive'] = int.parse(memberid);
    log('关注的传值====='+map.toString());
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.likeMatchBlindMembers, data: map, successCallback: (data) async {

      log('关注的结果====='+data.toString());
      BotToast.showText(text: '喜欢成功');
      // Map<String, dynamic> userdic11 = {};
      // userdic11['id'] = userInfoDic['id'].toString();
      // userdic11['nickname'] = userInfoDic['nickname'];
      // sendKefuMessage(userdic11);
      print('data[id].toString()'+map.toString());
      if(data['eachOther'].toString()=='1'){
        BotToast.closeAllLoading();
        peiduisuccess(data);
      }else{
        getMyvipQuanyi();
      }

      //保存成功
      /* Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return LoginAddressPage();
          }));*/
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  sendKefuMessage(data)async{

    print('data[id].toString()'+data['nickname'].toString());
    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: data['nickname'].toString()+'，很高兴相互吸引，愿我们有个愉快的开始。', /// 文本信息
    );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id!, // 创建的messageid
          receiver: data['id'].toString(), // 接收人id
          groupID: "", // 接收群组id
          priority: MessagePriorityEnum.V2TIM_PRIORITY_DEFAULT, // 消息优先级
          onlineUserOnly:
          false, // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
          isExcludedFromUnreadCount: false, // 发送消息是否计入会话未读数
          isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
          needReadReceipt:
          false, // 消息是否需要已读回执（只有 Group 消息有效，6.1 及以上版本支持，需要您购买旗舰版套餐）
          offlinePushInfo: OfflinePushInfo(), // 离线推送时携带的标题和内容
          cloudCustomData: "", // 消息云端数据，消息附带的额外的数据，存云端，消息的接收者可以访问到
          localCustomData:
          "" // 消息本地数据，消息附带的额外的数据，存本地，消息的接收者不可以访问到，App 卸载后数据丢失
      );
      print('sendMessageRes.code'+sendMessageRes.code.toString());
      if (sendMessageRes.code == 0) {
        // 发送成功

      }else{
        getMyvipQuanyi();
      }
    }
  }


  //跳转聊天
  rightToChat(userdic)async{

    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ChatPage(userInfoDic: userdic,);
        }));
    getMyvipQuanyi();
  }


  chooseSuperLike() async{
    if(userDic['userLevel'].toString()=='0'){
      showDialog(
          context:context,
          builder:(context){
            return Noopenvipdialog(
                content: '',
                OntapCommit: ()async{
                  await  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext ccontext) {
                        return  VipcenterHome();
                      }));
                  getmineinfo();
                }

            );
          }
      );
      return;
    }

    String memberid = userInfoDic['id'].toString();
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    Map<String, dynamic> map = {};
    map['userId'] = userId;
    map['matchedId'] = memberid;

    print(map);
    // MTEasyLoading.showLoading('保存中');
    NetWorkService service = await NetWorkService().init();
    service.post(Apis.reallyLikeUser, data: map, successCallback: (data) async {
      MTEasyLoading.dismiss();
      BotToast.showText(text: '已设置超级喜欢');
      Map<String, dynamic> userdic11 = {};
      userdic11['id'] = data['userId'].toString();
      userdic11['nickname'] = data['matchNickName'];
      print('data[id].toString()'+data.toString());
      sendKefuMessage1(userdic11);
      //保存成功
      /* Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ccontext) {
            return LoginAddressPage();
          }));*/
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }


  sendKefuMessage1(data)async{


    // 创建文本消息
    V2TimValueCallback<V2TimMsgCreateInfoResult> createTextMessageRes =
    await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createTextMessage(
      text: '嗨，'+data['nickname'].toString()+'！很高兴用了‘超级喜欢’来认识你。期待你的回复，这样我们就可以正式开启愉快的聊天了！', // 文本信息
    );
    if (createTextMessageRes.code == 0) {
      // 文本信息创建成功
      String? id = createTextMessageRes.data?.id;
      // 发送文本消息
      // 在sendMessage时，若只填写receiver则发个人用户单聊消息
      //                 若只填写groupID则发群组消息
      //                 若填写了receiver与groupID则发群内的个人用户，消息在群聊中显示，只有指定receiver能看见
      V2TimValueCallback<V2TimMessage> sendMessageRes =
      await TencentImSDKPlugin.v2TIMManager.getMessageManager().sendMessage(
          id: id!, // 创建的messageid
          receiver: data['id'].toString(), // 接收人id
          groupID: "", // 接收群组id
          priority: MessagePriorityEnum.V2TIM_PRIORITY_DEFAULT, // 消息优先级
          onlineUserOnly:
          false, // 是否只有在线用户才能收到，如果设置为 true ，接收方历史消息拉取不到，常被用于实现“对方正在输入”或群组里的非重要提示等弱提示功能，该字段不支持 AVChatRoom。
          isExcludedFromUnreadCount: false, // 发送消息是否计入会话未读数
          isExcludedFromLastMessage: false, // 发送消息是否计入会话 lastMessage
          needReadReceipt:
          false, // 消息是否需要已读回执（只有 Group 消息有效，6.1 及以上版本支持，需要您购买旗舰版套餐）
          offlinePushInfo: OfflinePushInfo(), // 离线推送时携带的标题和内容
          cloudCustomData: "", // 消息云端数据，消息附带的额外的数据，存云端，消息的接收者可以访问到
          localCustomData:
          "" // 消息本地数据，消息附带的额外的数据，存本地，消息的接收者不可以访问到，App 卸载后数据丢失
      );
      print('sendMessageRes.code'+sendMessageRes.code.toString());
      if (sendMessageRes.code == 0) {
        // 发送成功
        rightToChat1(data);
      }else{
        getMyvipQuanyi();
      }
    }
  }


  //跳转聊天
  rightToChat1(userdic)async{

    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext ccontext) {
          return ChatPage(userInfoDic: userdic,);
        }));
    getMyvipQuanyi();
  }

  jubaoClick(){
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) {
          return UseReportPage(
            userName: userInfoDic[
            'nickname'],
          );
        },
        fullscreenDialog: true));
  }

  //立即实名认证
  rightNameAuth()async{
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return const FaceVerify();
        }));
    getuserInfo();
  }

  initTagList()async{


    log('userInfoDic======'+ListData[selectRow].toString());
    setState(() {
      imgs = ListData[selectRow]['albumDOS'];
      if (ListData[selectRow]['memberUserTagRespVOS'].length==0){
        tagList2 = [];
      }else{
        tagList2 = ListData[selectRow]['memberUserTagRespVOS'];
      }

      userInfoDic = ListData[selectRow];

      // backImageUrl = data['bgUrl'].toString();
      // chooseItemArray = data['memberUserTagRespVOS'];
      List newTagList = [];
      Map map1 = {};
      String str1 = ListData[selectRow]['height'].toString();
      String str2 = ListData[selectRow]['weight'].toString();
      map1['label'] = '${str1}cm/${str2}kg';
      newTagList.add(map1);

      String str3 = ListData[selectRow]['marriageName'].toString();
      Map map2 = {};
      map2['label'] = str3;
      newTagList.add(map2);

      String str4 = ListData[selectRow]['educationName'].toString();
      Map map3 = {};
      map3['label'] = str4;
      newTagList.add(map3);

      String str5 = getMonthIncomeList[int.parse(ListData[selectRow]['monthIncome'].toString())];

      Map map4 = {};
      map4['label'] = str5;
      newTagList.add(map4);

      String str6 = ListData[selectRow]['career'].toString();
      Map map5 = {};
      map5['label'] = '从事$str6';
      newTagList.add(map5);

      String str7 = ListData[selectRow]['areaName'].toString();
      Map map6 = {};
      map6['label'] = str7;
      newTagList.add(map6);

      String str8 = ListData[selectRow]['graduatFrom'].toString();
      Map map7 = {};
      map7['label'] = str8;
      newTagList.add(map7);

      print(newTagList);
      print('就大姐大姐家大姐大姐dkdkkddkkdk');
      tagList = newTagList;
      liulanNum();
    });


  }

  Future<void> main() async {
    BotToast.showLoading();
    WidgetsFlutterBinding.ensureInitialized();

    final bool key = await setAMapKey(
        iosKey: 'd7b5cb7f36906a827392540b377da96b',
        androidKey: '73368d689ef463c33da954292bee4956');

    if (key != null && key)  print('高德地图ApiKey设置成功');
    requestLocationPermission();
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<void> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      final bool data = await FlAMapLocation().initialize();
      if (data) {
        print('初始化成功');
        getLocation();
      }
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        final bool data = await FlAMapLocation().initialize();
        if (data) {
          print('初始化成功');
          getLocation();
        }
      } else {
        BotToast.closeAllLoading();
        BotToast.showText(text: '请前往设置开启定位权限');
        getuserTuijian();

      }
    }
  }


  Future<void> getLocation() async {

    /// 务必先初始化 并获取权限
    // if (getPermissions) return;
    AMapLocation? location = await FlAMapLocation().getLocation();
    if (_isAndroid) {
      AMapLocation is AMapLocationForAndroid;
    }
    if (_isIOS) {
      AMapLocation is AMapLocationForIOS;
    }

    if (location!=null){
      log('纬度${location.latitude}'+'经度${location.longitude}');
      saveLocation(location.latitude,location.longitude);
      // setState(() {
      //   mylatitude = location.latitude!;
      //   mylongitude = location.longitude!;
      // });
    }
  }

  saveLocation(latitude,longitude)async{

    log('获取双方的距离'+'${latitude},${longitude}');
    Map<String, dynamic> map = {};
    map['position'] = '${latitude},${longitude}';
    print(map);
    NetWorkService service = await NetWorkService().init();
    service.put(Apis.saveUserInfo, data: map, successCallback: (data) async {
      // getUsersLocation(latitude, longitude);
      positionShouquan = true;
      getuserTuijian();
      BotToast.closeAllLoading();
    }, failedCallback: (data) {
      BotToast.closeAllLoading();
    });
  }

  // getUsersLocation(latitude,longitude)async{
  //   if(userInfoDic['position'] == null||userInfoDic['position'].toString() ==''){
  //     setState(() {
  //       positionShouquan = true;
  //       juli = '距离未知';
  //     });
  //     BotToast.closeAllLoading();
  //     return;
  //   }else{
  //
  //   }
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   NetWorkService service = await NetWorkService().init();
  //   service.get(Apis.getDistance, queryParameters: {
  //     'latitude1': latitude,
  //     'longitude1': longitude,
  //     'latitude2': userInfoDic['position'].toString().split(',')[0],
  //     'longitude2': userInfoDic['position'].toString().split(',')[1],
  //   }, successCallback: (data) async {
  //     setState(() {
  //       positionShouquan = true;
  //       juli = '${double.parse(data.toStringAsFixed(2))}';
  //     });
  //     log('获取双方的距离'+data.toString());
  //     BotToast.closeAllLoading();
  //   }, failedCallback: (data) {
  //     BotToast.closeAllLoading();
  //   });
  // }


  createBlindMemberSeeMe(data)async{

    if (canLoadingSeeOther == false){
      debugPrint('不能调用了');
      return;
    }

    // BotToast.showLoading();
    _scrollController.removeListener(_scrollListener);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    NetWorkService service = await NetWorkService().init();
    log('我看过谁传递参数'+sharedPreferences.get('UserId').toString()+data['id'].toString());
    service.post(Apis.createBlindMemberSeeMe, data: {
      'issue': sharedPreferences.get('UserId').toString(),
      'receive': data['id'].toString(),
    }, successCallback: (data) async {
      log('我看过谁成功'+data.toString());
      setState(() {
        canLoadingSeeOther = false;
      });
      // Future.delayed(const Duration(seconds: 1), () {
      //   BotToast.closeAllLoading();
      // });

    }, failedCallback: (data) {
      log('我看过谁失败'+data.toString());
      BotToast.closeAllLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return
      hasNext==1?
      Container(
        color: Color(0xffF3F5F9),
        width: screenSize.width,
        height: screenSize.height,
        child:Stack(
          children: [
            Positioned(
                left:0,right: 0,
                height: 480.5,
                child: Image(image: AssetImage('images/home/hometop.png'),fit: BoxFit.cover,)
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 15,
              child:Text('西瓜岛',style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
            ),




            Positioned(
              // color: Colors.white,
                left: 15,right: 15,bottom: 0,top: MediaQuery.of(context).padding.top+40,
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: screenSize.height-MediaQuery.of(context).padding.top-40,
                    padding: EdgeInsets.only(bottom: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: Colors.white
                    ),
                    child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),

                              ),
                              child: Column(
                                children: [

                                  Column(
                                    children: [
                                      // userInfoDic['bgUrl']==null?
                                      Stack(
                                        children: [


                                          userInfoDic['avatar']!=null?Container(
                                            margin: EdgeInsets.only(top: 0),
                                            height: screenSize.height - MediaQuery.of(context).padding.top-40 - MediaQuery.of(context).padding.bottom - 110 ,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage( userInfoDic['avatar'].toString()),fit: BoxFit.cover),
                                            ),
                                          ):Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                              ),
                                              // color: Colors.yellow,
                                            ),
                                            margin: EdgeInsets.only(left: 15,right: 15,top: MediaQuery.of(context).padding.top+40),
                                            height: screenSize.height - MediaQuery.of(context).padding.top-40,

                                          ),
                                          Positioned(
                                              left: 10,
                                              bottom: 10,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            userInfoDic['nickname'].toString()+' '+'${userInfoDic['age']}',
                                                            style: const TextStyle(color: Colors.white, fontSize: 18),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      // width: 100,
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Image(image: AssetImage('images/home/career.png',),width:13 ,height: 13,),
                                                              SizedBox(width: 7),
                                                              Text(
                                                                ListData.length!=0&&ListData[selectRow]['career'].isEmpty==false?ListData[selectRow]['career']:'职业未知',
                                                                style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                                                              ),
                                                              // const Text(
                                                              //   '岁',
                                                              //   style: TextStyle(color: Colors.white, fontSize: 16),
                                                              // ),
                                                            ],
                                                          ),)
                                                    ),

                                                    Container(
                                                      // width: 100,
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: 5),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Image(image: AssetImage('images/home/jinniuzuo.png',),width:13 ,height: 13,),
                                                              SizedBox(width: 7),
                                                              Text(
                                                                ListData.length!=0&&ListData[selectRow]['constellation'].isEmpty==false?xingzuoTitleList[int.parse(ListData[selectRow]['constellation'])]:'星座未知',
                                                                style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                                                              ),
                                                              // const Text(
                                                              //   '岁',
                                                              //   style: TextStyle(color: Colors.white, fontSize: 16),
                                                              // ),
                                                            ],
                                                          ),)
                                                    ),
                                                  ],
                                                ),
                                              )),



                                          Positioned(
                                              right: 0,
                                              bottom: 10,
                                              child: Container(
                                                alignment: Alignment.bottomRight,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [

//                                   Container(
//                                     margin: EdgeInsets.only(bottom: 17.5,right: 15),
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         //超级喜欢
//                                         chooseSuperLike();
//                                       },
//                                       child:Image(image: AssetImage('images/home/chaojixihuan.png',),width:66 ,height: 66,),
//                                     ),
//                                   ),
//                                   Container(
//                                     margin: EdgeInsets.only(bottom: 17.5,right: 15),
//                                     child: GestureDetector(
//                                       onTap: (){
//                                         //喜欢，收藏
//                                         chooseLike();
// // showDialog(
//                                         //     context:context,
//                                         //     builder:(context){
//                                         //       return HomeShowdialogPage(
//                                         //           OntapCommit: (){
//                                         //
//                                         //           }
//                                         //
//                                         //       );
//                                         //     }
//                                         // );
//
//                                       },
//                                       child:Image(image: AssetImage('images/home/buganxingqu.png',),width:66 ,height: 66,),
//                                     ),
//                                   ),
//                                  Container(
//                                    margin: EdgeInsets.only(bottom: 45,right: 15),
//                                    child:  GestureDetector(
//                                      onTap: (){
//                                        //不感兴趣下一个
//                                        netChile();
//                                      },
//                                      child:Image(image: AssetImage('images/home/cancel.png',),width:66 ,height: 66,),
//                                    ),
//                                  ),

                                                    Container(
                                                      margin: EdgeInsets.only(top: 5,right: 10),
                                                      padding: EdgeInsets.only(top: 3,bottom: 3,left: 4.5,right: 7),
                                                      decoration: const BoxDecoration(
                                                        color: Color.fromRGBO(0, 0, 0, 0.25),
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(18)
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Image(image: AssetImage('images/home/location.png',),width:13 ,height: 13,),
                                                          SizedBox(width: 3,),
                                                          Text(
                                                            ListData.length!=0&&ListData[selectRow]['getDistance']!=null&&ListData[selectRow]['getDistance'].toString()!=''&&positionShouquan==true?'距你'+ListData[selectRow]['getDistance']+'km':'距离未知',
                                                            style: const TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                                                          ),
                                                          // const Text(
                                                          //   '岁',
                                                          //   style: TextStyle(color: Colors.white, fontSize: 16),
                                                          // ),
                                                        ],
                                                      ),)
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                      Container(
                                        width: screenSize.width,
                                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 10,left: 9.5),
                                              child: const Text(
                                                "基本资料",
                                                style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.5, top: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),

                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/height.png'),width: 10.5,height: 14,),
                                                    SizedBox(width: 4,),
                                                    Text(tagList.isNotEmpty&&tagList[0]!=null?tagList[0]["label"]:"",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )
                                            ),
                                            Container(
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(left: 16),
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),

                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/hunyin.png'),width: 14.5,height: 12,),
                                                    SizedBox(width: 4,),
                                                    Text(tagList.isNotEmpty&&tagList[1]!=null?tagList[1]["label"]:"",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 12.5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/xueli.png'),width: 14,height: 12,),
                                                    SizedBox(width: 4,),
                                                    Text(tagList.isNotEmpty&&tagList[2]!=null?tagList[6]["label"]+'·'+tagList[2]["label"]:"",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )


                                            ),



                                          ],
                                        ),
                                        Container(
                                          height: 12.5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),

                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/gongzuo.png'),width: 13,height: 12.5,),
                                                    SizedBox(width: 4,),
                                                    Text(tagList.isNotEmpty&&tagList[4]!=null?tagList[4]["label"]:"",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )
                                            ),


                                          ],
                                        ),
                                        Container(
                                          height: 12.5,
                                        ),

                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/income.png'),width: 12,height: 13,),
                                                    SizedBox(width: 4,),
                                                    Text("年收入"+(tagList.isNotEmpty&&tagList[3]!=null?tagList[3]["label"]:""),
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )


                                            ),
                                          ],
                                        ),

                                        Container(
                                          height: 12.5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                decoration: const BoxDecoration(
                                                  color: Color.fromRGBO(226, 225, 223, 0.28),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                ),

                                                child: Row(
                                                  children: [
                                                    Image(image: AssetImage('images/home/address.png'),width: 14.5,height: 12.5,),
                                                    SizedBox(width: 4,),
                                                    Text(tagList.isNotEmpty&&tagList[5]!=null?tagList[5]["label"]:"",
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333),
                                                          fontSize: 14,
                                                        ),
                                                        softWrap: true),
                                                  ],
                                                )
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  imgs.isNotEmpty?Container(
                                    margin: const EdgeInsets.only(top: 17.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][0]['url']),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),
                                  imgs.length>=6?Container(
                                    margin: const EdgeInsets.only(top: 9.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][5]['url']),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),

                                  Container(
                                    margin: const EdgeInsets.only(top: 16.5,left: 9.5),
                                    child: Row(
                                      children: [

                                        Container(
                                          child: const Text(
                                            "个性标签",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  tagList2.isNotEmpty?Container(
                                    margin: const EdgeInsets.only(left: 10.5, top: 15.5),
                                    child: SelectTag2(
                                      tagList: tagList2,
                                      isSingle: false,
                                    ),
                                  ):Container(),
                                  imgs.length>=2?Container(
                                    margin: const EdgeInsets.only(top: 17.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][1]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),
                                  imgs.length>=7?Container(
                                    margin: const EdgeInsets.only(top: 9.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][6]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),


                                  Container(
                                    height: 350,
                                    alignment: Alignment.topLeft,
                                    margin:  EdgeInsets.only(left: 0,top: 17,right: 0,bottom: 23.5),
                                    // decoration: const BoxDecoration(
                                    //   color: Colors.white,
                                    //   borderRadius: BorderRadius.all(
                                    //       Radius.circular(10)),
                                    // ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            '情感偏向',
                                            style: TextStyle(
                                                fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildBiDirectionalSlider(
                                            leftLabel: '${_calculatePercentage(double.parse(userInfoDic['disposition']!=null?userInfoDic['disposition'].toString():'0'), true)}%\n理性',
                                            rightLabel:
                                            '${_calculatePercentage(double.parse(userInfoDic['disposition']!=null?userInfoDic['disposition'].toString():'0'), false)}%\n感性',
                                            value: double.parse(userInfoDic['disposition']!=null?userInfoDic['disposition'].toString():'0'),
                                            leftColor: Color(0xff4078FE),
                                            rightColor: Color(0xffFE7A24),
                                          ),
                                          const SizedBox(height: 19.5),
                                          const Text(
                                            '个人追求',
                                            style: TextStyle(
                                                fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildBiDirectionalSlider(
                                            leftLabel: '${_calculatePercentage(double.parse(userInfoDic['personPursuit']!=null?userInfoDic['personPursuit'].toString():'0'), true)}%\n理想',
                                            rightLabel: '${_calculatePercentage(double.parse(userInfoDic['personPursuit']!=null?userInfoDic['personPursuit'].toString():'0'), false)}%\n现实',
                                            value: double.parse(userInfoDic['personPursuit']!=null?userInfoDic['personPursuit'].toString():'0'),
                                            leftColor: Color(0xff4078FE),
                                            rightColor: Color(0xffFE7A24),


                                          ),
                                          const SizedBox(height: 19.5),
                                          const Text(
                                            'IQ',
                                            style: TextStyle(
                                                fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildProgressBar(
                                            leftLabel: '低级',
                                            rightLabel: '高级',
                                            value: double.parse(userInfoDic['iqValue']!=null?userInfoDic['iqValue'].toString():'0.5'),
                                            color: Color(0xffFFB700),
                                            centerLabel: '中级',
                                          ),
                                          const SizedBox(height: 19.5),
                                          const Text(
                                            'EQ',
                                            style: TextStyle(
                                                fontSize: 16,color: Color(0xff999999), fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          _buildProgressBar(
                                            leftLabel: '低级',
                                            rightLabel: '高级',
                                            value: double.parse(userInfoDic['eqValue']!=null?userInfoDic['eqValue'].toString():'0.5'),
                                            color: Color(0xffF77595),
                                            centerLabel: '高级',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  imgs.length>=3?Container(

                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][2]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),

                                  imgs.length>=8?Container(
                                    margin: const EdgeInsets.only(top: 9.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][7]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),

                                  Container(
                                    margin: const EdgeInsets.only(top: 15,left: 9.5),
                                    child: Row(
                                      children: [

                                        Container(
                                          margin: const EdgeInsets.only(top: 0),
                                          child: const Text(
                                            "内心独白",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 16),
                                    child: Text(
                                      userInfoDic['aboutMe']==null?'':userInfoDic['aboutMe'].toString(),
                                      style: const TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                  imgs.length>=4?Container(
                                    margin: const EdgeInsets.only(top: 17),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][3]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),





                                  Container(
                                    margin: const EdgeInsets.only(top: 15,left: 9.5),
                                    child: Row(
                                      children: [

                                        Container(
                                          child: const Text(
                                            "对另一半期望",
                                            style: TextStyle(
                                              color: Color(0xff999999),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: const EdgeInsets.only(left: 10,right: 10, top: 16),
                                    child: Text(
                                      userInfoDic['partnerWish']==null?'':userInfoDic['partnerWish'].toString(),
                                      style: const TextStyle(
                                          color: Color(0xff333333),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                  imgs.length>=5?Container(
                                    margin: const EdgeInsets.only(top: 17.5),
                                    child:  Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Container(
                                          width: screenSize.width-30,
                                          height: screenSize.width-30,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 255, 255, 0.6),
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(0),
                                          child: Image(
                                            image: NetworkImage(
                                                userInfoDic['albumDOS'][4]['url'] ?? ""),
                                            width: screenSize.width-30,
                                            height: screenSize.width-30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ):Container(),


                                  Container(
                                    margin: const EdgeInsets.only(top: 17,right: 9.5,left: 9.5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [

                                            Container(
                                              child: const Text(
                                                "动态",
                                                style: TextStyle(
                                                  color: Color(0xff999999),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (BuildContext ccontext) {
                                                  return UserInfoPage(userId: userInfoDic['id'].toString(),);
                                                }));
                                          },
                                          child:Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(top: 0.0,right: 0),
                                                child: const Text(
                                                  "查看更多动态",
                                                  style: TextStyle(
                                                    color: Color(0xff999999),
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.keyboard_arrow_right,
                                                color: Color.fromRGBO(171, 171, 171, 1.0),
                                              )





                                            ],
                                          ) ,
                                        ),


                                      ],
                                    ),
                                  ),
                                  userInfoDic['blindMemberMomentDOList']!=null?Container(
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(left: 10,top: 16,right: 10),
                                          alignment: Alignment.topLeft,
                                          child: Text(userInfoDic['blindMemberMomentDOList'].length!=0?userInfoDic['blindMemberMomentDOList'][0]['content']:'',style: const TextStyle(
                                              color: Color(0xff333333),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500
                                          ),),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            alignment: Alignment.topLeft,
                                            // width: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                            // height: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                            margin: const EdgeInsets.only(left: 10.5,top: 16,right: 10.5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                    onTap: (){
                                                      if(userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null){
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (BuildContext ccontext) {
                                                              return PostDetailPage(
                                                                id: userInfoDic['blindMemberMomentDOList'][0]['id'].toString(),
                                                              );
                                                            }));
                                                      }

                                                    },
                                                    child: Container(
                                                      child:
                                                      userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList']!=null&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null
                                                          ? _buildImagesWidget(userInfoDic['blindMemberMomentDOList'][0]['imgUrl'])
                                                          : Container(),
                                                    ))
                                                //     userInfoDic['blindMemberMomentDOList'].length!=0&&userInfoDic['blindMemberMomentDOList']!=null&&userInfoDic['blindMemberMomentDOList'][0]['imgUrl']!=null?
                                                // Image.network(userInfoDic['blindMemberMomentDOList'][0]['imgUrl'] ?? "", fit: BoxFit.cover,width: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,
                                                //   height: (MediaQuery.of(context).size.width - 30 - 9.5 * 4) / 3.0,):Container()),


                                              ],
                                            )
                                        )
                                      ],
                                    ),

                                  ):Container(),


                                  Container(
                                    child: const Text(''),
                                  ),



                                ],
                              ),
                            ),



                            //用户id
                            Container(
                              margin: const EdgeInsets.only(left: 30,top: 20,right: 30),
                              alignment: Alignment.center,
                              child: Text('用户id：${userInfoDic['id']}',style: const TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 16,fontWeight:FontWeight.w500
                              )),
                            ),

                            GestureDetector(
                              onTap: (){
                                jubaoClick();
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(left: 25,top: 15,right: 25,bottom: 90),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(child: Container(
                                        color: const Color(0xffEEEEEE),
                                        height: 0.5,
                                        margin: const EdgeInsets.only(left: 0,top: 0,right: 5.5),
                                      ),),
                                      const Text('举报',style: TextStyle(
                                          color: Color(0xff999999),
                                          fontSize: 16,fontWeight:FontWeight.w500
                                      )),
                                      Container(child: Container(
                                        color: const Color(0xffEEEEEE),
                                        height: 0.5,
                                        margin: const EdgeInsets.only(left: 5.5,top: 0,right: 0),
                                      ),)
                                    ],
                                  )
                              ),
                            ),

                            //
                          ],
                        )


                    ),
                  ),
                )
            ),


            Positioned(
                right: 0,
                bottom: 10,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                      Container(
                        margin: EdgeInsets.only(bottom: 17.5,right: 15),
                        child: GestureDetector(
                          onTap: (){
                            //超级喜欢
                            chooseSuperLike();
                          },
                          child:Image(image: AssetImage('images/home/chaojixihuan.png',),width:66 ,height: 66,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 17.5,right: 15),
                        child: GestureDetector(
                          onTap: (){
                            //喜欢，收藏
                            chooseLike();
// showDialog(
                            //     context:context,
                            //     builder:(context){
                            //       return HomeShowdialogPage(
                            //           OntapCommit: (){
                            //
                            //           }
                            //
                            //       );
                            //     }
                            // );

                          },
                          child:Image(image: AssetImage('images/home/buganxingqu.png',),width:66 ,height: 66,),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 45,right: 15),
                        child:  GestureDetector(
                          onTap: (){
                            //不感兴趣下一个
                            BotToast.showLoading();
                            getMyvipQuanyi();
                          },
                          child:Image(image: AssetImage('images/home/cancel.png',),width:66 ,height: 66,),
                        ),
                      ),


                    ],
                  ),
                )),

          ],

        ),
      ):
      Container(
        margin: EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                left:0,right: 0,
                height: 480.5,
                child: Image(image: AssetImage('images/home/hometop.png'),fit: BoxFit.fill,)
            ),
            Positioned(
                top: MediaQuery.of(context).padding.top,
                left: 15,
                child:
                Container(
                    margin: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('西瓜岛',style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('每天',style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.w500),),
                            Text('12:00',style: TextStyle(color: Color(0xffFE7A24 ),fontSize: 16,fontWeight: FontWeight.w500),),
                            Text('，为您推荐新朋友',style: TextStyle(color: Color(0xff333333),fontSize: 16,fontWeight: FontWeight.w500),)
                          ],
                        ),

                        Container(
                          margin: EdgeInsets.all(0),
                          width: screenSize.width-16,
                          height: 235,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/home/home_xiayilun.png'),fit: BoxFit.fill)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 37.5,),
                              Container(
                                margin: EdgeInsets.only(left: 31),
                                child: Image(image: AssetImage('images/home/home_genghao.png'),width: 195.5,height: 19.5,),
                              ),
                              SizedBox(height: 5,),
                              Container(
                                margin: EdgeInsets.only(left: 33),
                                child: Text('我更懂你啦，即将推荐更多你喜欢的人',style: TextStyle(color: Color(0xffFEFEFE),fontSize: 11,fontWeight: FontWeight.normal),),
                              ),


                              //我看过的人的集合
                              Container(

                                margin: const EdgeInsets.only(left: 35,top: 20,right: 15),
                                height: 43.5,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    //头像集合

                                    SizedBox(
                                        width: dataSource.length<=6?dataSource.length.toDouble()*28:168,
                                        height: 28,
                                        child: MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (BuildContext context, int index1) {
                                                return _buildNumListItem(context, index1);
                                              },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return Container(

                                                );
                                              },
                                              itemCount: dataSource.length<=6?dataSource.length:6),
                                        )),
                                    const SizedBox(width: 10.5,),
                                    //多少人

                                    Text(
                                      '我看过的人',
                                      style: const TextStyle(color: Colors.white, fontSize: 12,fontWeight: FontWeight.w500),
                                    ),

                                    // Text(
                                    //   '${dataSource.length}+',
                                    //   style: const TextStyle(color: Color(0xffFE7A24 ), fontSize: 20,fontWeight: FontWeight.bold),
                                    // ),
                                  ],
                                ),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext ccontext) {
                                        return  MineMeseeotherListpage();
                                      }));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(left: 30,right: 30,top: 18),
                                  width: screenSize.width-60,
                                  height: 52,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(26)
                                  ),
                                  child: Text('查看我看过的人',style: TextStyle(color: Color(0xffFE7A24),fontSize: 15,fontWeight: FontWeight.w500),),
                                ),
                              )

                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text('去探索更多服务',
                            style: TextStyle(color: Color(0xff999999),fontSize: 16,fontWeight: FontWeight.w500),),
                        ),

                        //星座
                        basicDic['virtualDisplay']==1?GestureDetector(
                          onTap: ()async{

                            if (userDic['userLevel']==0){
                              showDialog(
                                  context:context,
                                  builder:(context){
                                    return Noopenvipdialog(
                                        content: '',
                                        OntapCommit: ()async{
                                          await  Navigator.push(context, MaterialPageRoute(
                                              builder: (BuildContext ccontext) {
                                                return  VipcenterHome();
                                              }));
                                          getmineinfo();
                                        }

                                    );
                                  }
                              );
                              return;
                            }


                            if (userDic['isConstellationCommit']==null||userDic['isConstellationCommit'].toString()=='0'){
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext ccontext) {
                                    return  XingzuoHomePage();
                                  }));
                              getmineinfo();
                            }

                            //已提交测试没有回复
                            if (userDic['isConstellationCommit']!=null&&userDic['isConstellationCommit'].toString()=='1'&&userDic['isConstellationTest'].toString()=='0'){
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext ccontext) {
                                    return  XingzuoSubmitNoreturn();
                                  }));
                              getmineinfo();
                            }

                            //已提交测试已有回复
                            if (userDic['isConstellationCommit']!=null&&userDic['isConstellationCommit'].toString()=='1'&&userDic['isConstellationTest'].toString()=='1'){
                              await Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext ccontext) {
                                    return  XingzuoSubmitReturn();
                                  }));
                              getmineinfo();
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left:0,right: 15,top: 18),
                              width: screenSize.width-30,
                              height: 82,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(153, 153, 153, 0.1)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10,top: 0),
                                        child: Image(image: AssetImage('images/home/home_xingzuo.png'),width: 50.5,height: 50.5,),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 12,top: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('星座测算',
                                              style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 3,),
                                            Text('快速解析星座动向',
                                              style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w400),),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),

                                  GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        width: 20,height: 20,
                                        decoration: BoxDecoration(
                                            color: Color(0xff999999),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Icon(Icons.navigate_next,size: 20,color: Colors.white,)
                                    ),
                                  )
                                ],
                              )
                          ),
                        ):Container(),

                        //红娘
                        basicDic['virtualDisplay']==1?GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext ccontext) {
                                  return  HongniangFuwuhome();
                                }));
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left:0,right: 15,top: 15),
                              width: screenSize.width-30,
                              height: 82,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(153, 153, 153, 0.1)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10,top: 0),
                                        child: Image(image: AssetImage('images/home/home_hongniang.png'),width: 50.5,height: 50.5,),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 12,top: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('红娘服务',
                                              style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 3,),
                                            Text('牵线美好姻缘',
                                              style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w400),),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),

                                  GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        width: 20,height: 20,
                                        decoration: BoxDecoration(
                                            color: Color(0xff999999),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Icon(Icons.navigate_next,size: 20,color: Colors.white,)
                                    ),
                                  )
                                ],
                              )
                          ),
                        ):Container(),



                        //实名
                        GestureDetector(
                          onTap: ()async{
                            userDic['haveNameAuth']!=1?rightNameAuth():MTEasyLoading.showToast('您已完成实名');
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left:0,right: 15,top: 15),
                              width: screenSize.width-30,
                              height: 82,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Color.fromRGBO(153, 153, 153, 0.1)
                                  )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 10,top: 0),
                                        child: Image(image: AssetImage('images/home/home_shiming.png'),width: 50.5,height: 50.5,),
                                      ),

                                      Container(
                                        margin: EdgeInsets.only(left: 12,top: 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('实名认证',
                                              style: TextStyle(color: Color(0xff333333),fontSize: 17.5,fontWeight: FontWeight.bold),),
                                            SizedBox(height: 3,),
                                            Text('安全你我，诚信互联',
                                              style: TextStyle(color: Color(0xff999999),fontSize: 13,fontWeight: FontWeight.w400),),
                                          ],
                                        ),
                                      ),


                                    ],
                                  ),

                                  GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        width: 20,height: 20,
                                        decoration: BoxDecoration(
                                            color: Color(0xff999999),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Icon(Icons.navigate_next,size: 20,color: Colors.white,)
                                    ),
                                  )
                                ],
                              )
                          ),
                        )
                      ],
                    )
                ))
          ],
        ),
      );
  }




  Widget _buildBiDirectionalSlider({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color leftColor,
    required Color rightColor,
  }) {
    return Row(
      children: [
        Text(leftLabel, style: TextStyle(color: value < 0 ? leftColor : Color(0xff999999))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final center = width / 2;
                  final position = (value + 1) / 2 * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              if (value < 0)
                                Positioned(
                                  left: center + (position - center),
                                  right: center,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: leftColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        left: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              if (value > 0)
                                Positioned(
                                  left: center,
                                  right: width - position,
                                  child: Container(
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: rightColor,
                                      borderRadius:
                                      const BorderRadius.horizontal(
                                        right: Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                              // Center(
                              //   child: Container(
                              //     width: 2,
                              //     height: 20,
                              //     color: Colors.grey[300],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Text(rightLabel, style: TextStyle(color: value < 0 ? Colors.grey : rightColor)),
      ],
    );
  }

  Widget _buildDualProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double leftValue,
    required double rightValue,
    required Color leftColor,
    required Color rightColor,
    required ValueChanged<double> onLeftChanged,
    required ValueChanged<double> onRightChanged,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Text(leftLabel, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Text(rightLabel, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 20,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: leftColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: leftColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: leftValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onLeftChanged,
                    ),
                  ),
                ),
              ),
              Container(
                width: 2,
                color: Colors.grey[300],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(4),
                  ),
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 20,
                      activeTrackColor: rightColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                        elevation: 2,
                      ),
                      overlayColor: rightColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: rightValue,
                      min: 0.0,
                      max: 1.0,
                      onChanged: onRightChanged,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar({
    required String leftLabel,
    required String rightLabel,
    required double value,
    required Color color,
    String? centerLabel,
  }) {
    String getLevel(double value) {
      if (value < 0.33) {
        return '低级';
      } else if (value < 0.66) {
        return '中级';
      } else {
        return '高级';
      }
    }

    return Row(
      children: [
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(leftLabel, style: const TextStyle(color: Color(0xff999999))),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 32,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final position = value * width;

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: width - position,
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.horizontal(
                                      left: const Radius.circular(100),
                                      right: Radius.circular(
                                          position < 10 ? 0 : 100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: position - 15,
                        top: -22,
                        child: Column(
                          children: [
                            Transform.translate(
                              offset: const Offset(0, 7),
                              child: Text(
                                getLevel(value),
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, 6),
          child: Text(rightLabel, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }

  int _calculatePercentage(double value, bool isLeft) {
    if (value == 0) {
      return 50;
    } else if (isLeft) {
      return value < 0 ? (50 + 50 * -value).round() : 100-(50 + 50 * value).round();
    } else {
      return value > 0 ? (50 + 50 * value).round() : 100-(50 + 50 * -value).round();
    }
  }





  //共多少人参与的列表
  Widget _buildNumListItem(BuildContext context, int index1) {
    return
      SizedBox(

        width: 28,
        height: 28,
        child:  Stack(
          children: [
            Positioned(
                left: 0,
                top: 0,
                // 将溢出部分剪裁
                child: ClipOval(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 1,
                    child: Image(image: NetworkImage(dataSource[index1]['avatar']),width: 28,height: 28,fit: BoxFit.cover,), //宽度设为原来宽度一半
                  ),
                )
            ),
          ],
        ),
      )
    ;
  }

  Widget _buildImagesWidget(String imageStr) {
    if (imageStr.isEmpty) {
      return Container();
    }

    List<String> imageUrls = [];
    if (!imageStr.contains(',')) {
      imageUrls = [imageStr];
    } else {
      imageUrls = _getImageArray(imageStr);
    }

    List<Widget> widgets = [];
    for (int i = 0; i < imageUrls.length; i++) {
      if (i == 3) {
        break;
      }
      widgets.add(Container(
        width: (MediaQuery.of(context).size.width - 90 - 9.5 * 3) / 3.0,
        height: (MediaQuery.of(context).size.width - 90 - 9.5 * 3) / 3.0,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrls[i].toString())),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
      ));

      widgets.add(const SizedBox(
        width: 9.5,
      ));
    }

    return Row(
      children: widgets,
    );
  }

  List<String> _getImageArray(String imageStr) {
    List<String> list = imageStr.split(',');
    return list;
  }
}


