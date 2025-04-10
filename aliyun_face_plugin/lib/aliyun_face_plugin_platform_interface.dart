import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aliyun_face_plugin_method_channel.dart';

abstract class AliyunFacePluginPlatform extends PlatformInterface {
  /// Constructs a AliyunFacePluginPlatform.
  AliyunFacePluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliyunFacePluginPlatform _instance = MethodChannelAliyunFacePlugin();

  /// The default instance of [AliyunFacePluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliyunFacePlugin].
  static AliyunFacePluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliyunFacePluginPlatform] when
  /// they register themselves.
  static set instance(AliyunFacePluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<String?> verify(String key, String value) {
    throw UnimplementedError('verify() has not been implemented.');
  }

  Future<String?> getMetaInfos() {
    throw UnimplementedError('getMetaInfos() has not been implemented.');
  }
}
