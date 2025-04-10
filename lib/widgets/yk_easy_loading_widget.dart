import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MTEasyLoading {
  static void init() {
    EasyLoading.init();
  }

  static void config() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCube
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 30.0
      ..radius = 10.0
      ..progressColor = Colors.white.withAlpha(122)
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false
      ..customAnimation = OLLoadingAnimation();
  }

  /// 显示loading
  static void showLoading(String msg) {
    EasyLoading.instance.userInteractions = false;
    EasyLoading.show(
      status: msg,
      maskType: EasyLoadingMaskType.black,
    );
  }

  /// 显示toast
  static showToast(String? msg) async {
    EasyLoading.instance.userInteractions = true;
    await EasyLoading.showToast(
      msg ?? '数据错误',
      // maskType: EasyLoadingMaskType.clear,
    );
  }

  static void dismiss() {
    EasyLoading.dismiss();
  }
}

class OLLoadingAnimation extends EasyLoadingAnimation {
  OLLoadingAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class BotToastInfo {
  static showMsgNofit(
      {String? title,
      Duration? duration = const Duration(seconds: 2),
      Function()? onTap}) {
    BotToast.showSimpleNotification(
        hideCloseButton: true,
        title: title ?? "有未读新消息",
        duration: duration,
        titleStyle: const TextStyle(color: Color(0xFF998FA6), fontSize: 14),
        backgroundColor: const Color(0xFF000000).withOpacity(0.8),
        onTap: onTap);
  }

  //授权提示文案 华为专属
  static showLimit(
      {String? title,
      Duration? duration = const Duration(seconds: 3),
      Function()? onTap}) {
    showMsgNofit(title: title, duration: duration, onTap: onTap);
  }
}
