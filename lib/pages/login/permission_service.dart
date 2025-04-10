import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // 请求通知权限
  Future<bool> requestNotificationPermission() async {
    // 检查通知权限状态
    var status = await Permission.notification.status;

    // 如果权限未被授予，则请求权限
    if (!status.isGranted) {
      var result = await Permission.notification.request();
      return result.isGranted;
    }

    // 权限已经被授予
    return true;
  }
}