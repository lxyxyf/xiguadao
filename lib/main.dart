import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluwx/fluwx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xinxiangqin/main_page.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:xinxiangqin/pages/login/first_agree_dialog.dart';
import 'package:xinxiangqin/pages/login/login_page.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:xinxiangqin/xingzuo/xingzuo_task_list.dart';
import 'agreement/user_agent_page.dart';
import 'message/generateUserSig.dart';
import 'mine/privacy_policy_page.dart';

void main() {
  // 设置日志级别和输出配置
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[${record.level}]: ${record.time} - ${record.message}');
  });

  // 捕获Flutter错误
  FlutterError.onError = (FlutterErrorDetails details) {
    Logger.root.severe('FlutterErrorDetails: ${details.exception}');
    if (details.stack != null) {
      Logger.root.severe('Stack Trace: ${details.stack}');
    }
  };

  // 运行Flutter应用
  runZoned<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterLocalization.instance.ensureInitialized();
    runApp(MyApp());
  }, onError: (Object error, StackTrace stackTrace) {
    Logger.root.severe('Uncaught error: $error');
    Logger.root.severe('Stack Trace: $stackTrace');
  });
}
  // runApp(const MyApp());


final botToastBuilder = BotToastInit();
final easyload = EasyLoading.init();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}



class MyAppState extends State<MyApp> {
  bool isLogin = false;
  bool isFirstOpen = true;
  bool isZhanxingshi = false;

  @override
  void initState() {

    super.initState();

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 状态栏背景颜色
    ));
    _getLoginStatus();
    initFlutterWX();
    recordFirstOpen();
  }

  recordFirstOpen()async{
    SharedPreferences share = await SharedPreferences.getInstance();

    if (share.getString('isfirstOpen')==''||share.getString('isfirstOpen')==null||share.getString('isfirstOpen')=='true'){
      // share.setString('isfirstOpen', 'true');
      setState(() {
        isFirstOpen = true;
      });
    }else{
      setState(() {
        isFirstOpen = false;
      });
    }
  }

  initFlutterWX(){
    Fluwx fluwx = Fluwx();
    fluwx.registerApi(appId: "wx25358e0163bf4726",universalLink: "https://www.xiguadao.cc/appfile/");
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,//是Flutter的一个本地化委托，用于提供Material组件库的本地化支持
          GlobalWidgetsLocalizations.delegate,//用于提供通用部件（Widgets）的本地化支持
          GlobalCupertinoLocalizations.delegate,//用于提供Cupertino风格的组件的本地化支持
        ],
      supportedLocales: [
        const Locale('zh', 'CN'),// 支持的语言和地区
      ],
      locale: Locale('zh'),
      title: '西瓜岛',
      theme: new ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          platform: TargetPlatform.iOS,
          primaryColor: Colors.orange,
          hintColor: Colors.orangeAccent),
      builder: (context, child) {
        child = easyload(context, child);
        child = botToastBuilder(context, child);
        return child;
      },
      navigatorObservers: [BotToastNavigatorObserver()],

      home: isFirstOpen==true?SplashScreen():isLogin&&isZhanxingshi&&isFirstOpen==false ? const XingzuoTaskList() :isLogin&&isZhanxingshi==false&&isFirstOpen==false? const MainPage() : const LoginPage(),
    );
  }



  void _getLoginStatus() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String userId = share.getString('UserId') ?? '';
    String iszhanxingshi = share.getString('iszhanxingshi') ?? '';

    if (userId.isNotEmpty) {
      setState(() {
        isLogin = true;
      });
    } else {
      setState(() {
        isLogin = false;
      });
    }

    if (iszhanxingshi == 'false') {
      setState(() {
        isZhanxingshi = false;
      });
    } else {
      setState(() {
        isZhanxingshi = true;
      });
    }
  }

}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstOpen = true;
  @override
  void initState() {

    super.initState();
    recordFirstOpen();
    // 在这里进行初始化操作，例如数据加载
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // 假设你的初始化操作完成后需要跳转到另一个页面
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    // });
  }

  recordFirstOpen()async{
    SharedPreferences share = await SharedPreferences.getInstance();
    log('isfirstOpen'+share.getString('isfirstOpen').toString());
    // if (share.getString('isfirstOpen')=='true'){
    //   // share.setString('isfirstOpen', 'false');
    //   // setState(() {
    //   //   isFirstOpen = false;
    //   // });
    // }

    if (share.getString('isfirstOpen')==''||share.getString('isfirstOpen')==null||share.getString('isfirstOpen')=='true'){
      // share.setString('isfirstOpen', 'true');
      setState(() {
        isFirstOpen = true;
      });
      showagreeDialog();
    }else{
      if(mounted){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // 假设你的初始化操作完成后需要跳转到另一个页面
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
    }
  }

  showagreeDialog()async{
    showDialog(
        barrierDismissible:false,
        context: context,
        builder: ((ctx) {
          return FirstAgreeDialog(

            OntapCommit: ()async{
              SharedPreferences share = await SharedPreferences.getInstance();
              await share.setString('isfirstOpen', 'false');
              Navigator.pop(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // 假设你的初始化操作完成后需要跳转到另一个页面
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
            CancelCommit: ()async{
              SharedPreferences share = await SharedPreferences.getInstance();
              await share.setString('isfirstOpen', 'true');
              Navigator.pop(context);
              exitApp();
            },
            yinsizhengceClick: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ccontext) {
                    return const PrivacyPolicyPage();
                  }));
            },
            fuwuxieyiClick: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext ccontext) {
                    return const UserAgentPage();
                  }));
            },
          )


           ;
        }));
  }

  // 调用退出函数
  // void exitApp() async {
  //   print('退出app');
  //   await SystemNavigator.pop();
  // }

 exitApp() async {
    if(Platform.isAndroid){
      SystemNavigator.pop();
    }else{
      exit(0);
    }
    // print('退出app');
    // SystemNavigator.pop();


  }

  @override
  Widget build(BuildContext context) {
    // 这里可以放置启动屏幕的UI
    return Stack(
      children: [
        Positioned(
          left: 0,top: 0,right: 0,
          bottom: 0,
          child: Image(image: AssetImage('images/LaunchImage.png'),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fit: BoxFit.cover,),)
      ],
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,top: 0,
          width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,
          child: Image(image: AssetImage('images/LaunchImage.png'),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,fit: BoxFit.fill,),)
      ],
    );
  }
}

