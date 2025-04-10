import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AgreementInfoPage extends StatefulWidget {
  final String htmlStr;
  final String title;
  const AgreementInfoPage({super.key, required this.htmlStr, required this.title});
  @override
  State<StatefulWidget> createState() {
    return AgreementInfoPageState();
  }
}

class AgreementInfoPageState extends State<AgreementInfoPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    initWebController();
  }

  void initWebController() {
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
      ..loadHtmlString(widget.htmlStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }

  @override
  void dispose() {
    BotToast.closeAllLoading();
    super.dispose();
  }
}
