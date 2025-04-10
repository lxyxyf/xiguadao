import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xinxiangqin/network/apis.dart';
import 'package:xinxiangqin/network/network_manager.dart';
import 'package:xinxiangqin/widgets/yk_easy_loading_widget.dart';

class UserAgentPage extends StatefulWidget {
  const UserAgentPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserAgentPageState();
  }
}

class UserAgentPageState extends State<UserAgentPage> {
  @override
  void initState() {
    super.initState();
    _getBaseInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Color(0xff333333),
          ),
        ),
        title: const Text(
          '服务协议',
          style: TextStyle(
              color: Color(0xff333333),
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _controller != null
              ? WebViewWidget(controller: _controller!)
              : Container(),
        ),
      ),
    );
  }

  WebViewController? _controller;

  void initWebController(String htmlStr) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            BotToast.showLoading();
          },
          onPageFinished: (String url) {
            BotToast.closeAllLoading();
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(htmlStr);

    setState(() {});
  }

  ///获取基础配置
  void _getBaseInfo() async {
    MTEasyLoading.showLoading('加载中');
    NetWorkService service = await NetWorkService().init();
    service.get(Apis.getBasicSetting, successCallback: (data) async {
      MTEasyLoading.dismiss();
      //用户协议
      String privacyAgreement = data['userAgreement'];
      initWebController(privacyAgreement);
    }, failedCallback: (data) {
      MTEasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    MTEasyLoading.dismiss();
    super.dispose();
  }
}
