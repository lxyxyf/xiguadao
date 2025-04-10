import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as FilePath;
import 'apis.dart';
import 'dart:developer';

typedef DynamicCallback = void Function(dynamic data);
BaseOptions option = BaseOptions(responseType: ResponseType.json);

class NetWorkService {
  static final CancelToken _cancelToken = CancelToken();

  var dio = Dio(option);

  Future<NetWorkService> init() async {
    // 配置dio实例
    dio.options.baseUrl = Apis.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30000);
    dio.options.receiveTimeout = const Duration(seconds: 30000);

    //自定义拦截器
    dio.interceptors.add(CustomInterceptor());
    return this;
  }

  ///取消所有请求 对单独设置了canceltoken的请求无效
  static cancelAllRequest() {
    _cancelToken.cancel('');
  }

  Future<dynamic> post(String path,
      {dynamic data,
        bool showErrorToast = true,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      data ??= {};
      options ??= Options();
      options.contentType = "application/json";

      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      var resp = ApiResp.fromJson(result.data!);

      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {
          BotToast.showText(text: resp.msg);
        }
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (kDebugMode) {
        print(errorMsg);
      }

      failedCallback != null ? failedCallback(errorMsg) : null;
      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }


  Future<dynamic> put(String path,
      {dynamic data,
        bool showErrorToast = true,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      data ??= {};
      options ??= Options();
      options.contentType = "application/json";

      var result = await dio.put<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      var resp = ApiResp.fromJson(result.data!);

      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {
          BotToast.showText(text: resp.msg);
        }
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (kDebugMode) {
        print(errorMsg);
      }

      failedCallback != null ? failedCallback(errorMsg) : null;
      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }

  Future<dynamic> delete(String path,
      {dynamic data,
        bool showErrorToast = true,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      data ??= {};
      var result = await dio.delete<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      var resp = ApiResp.fromJson(result.data!);
      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {}
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      debugPrint(errorMsg);
      failedCallback != null ? failedCallback(errorMsg) : null;

      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }

  ///
  Future<dynamic> get(String path,
      {dynamic data,
        bool showErrorToast = true,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      data ??= {};
      var result = await dio.get<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      log('get请求的传参：$queryParameters');
      var resp = ApiResp.fromJson(result.data!);
      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {}
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      debugPrint(errorMsg);
      failedCallback != null ? failedCallback(errorMsg) : null;

      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }

  Future<dynamic> uploadAudioFileWithPath(String path,
      {required String filePath,
        required String filename,
        bool showErrorToast = true,
        ProgressCallback? onSendProgress,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      final file = File(filePath);
      List<String> imageExtensions = [
        '.m4a',

      ];
      String fileExtension = FilePath.extension(filePath).toLowerCase();
      Uint8List? bytes; // 以字节形式打开文件并读取内容
      bytes = await file.readAsBytes();
      // if (imageExtensions.contains(fileExtension)) {
      //   bytes = await imgCompressAndGetFile(filePath);
      // }
      FormData formData = FormData();
      if (bytes != null) {
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(bytes, filename: 'audio.m4a'),
        });
      }

      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: formData,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      var resp = ApiResp.fromJson(result.data!);

      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {
          BotToast.showText(text: resp.msg);
        }
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (kDebugMode) {
        print(errorMsg);
      }

      failedCallback != null ? failedCallback(errorMsg) : null;
      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }

  Future<dynamic> uploadFileWithPath(String path,
      {required String filePath,
        required String filename,
        bool showErrorToast = true,
        ProgressCallback? onSendProgress,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
        DynamicCallback? successCallback,
        DynamicCallback? failedCallback}) async {
    try {
      final file = File(filePath);
      List<String> imageExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.bmp',
        '.webp',
      ];
      String fileExtension = FilePath.extension(filePath).toLowerCase();
      Uint8List? bytes; // 以字节形式打开文件并读取内容
      bytes = await file.readAsBytes();
      if (imageExtensions.contains(fileExtension)) {
        bytes = await imgCompressAndGetFile(filePath);
      }
      FormData formData = FormData();
      if (bytes != null) {
        formData = FormData.fromMap({
          "file": MultipartFile.fromBytes(bytes, filename: 'image.jpg'),
        });
      }

      var result = await dio.post<Map<String, dynamic>>(
        path,
        data: formData,
        cancelToken: cancelToken ?? _cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      String time = result.headers.map['date'].toString();
      print('时间---flutter data: $time');
      var resp = ApiResp.fromJson(result.data!);

      if (resp.code == 0) {
        successCallback != null ? successCallback(resp.data) : null;
      } else {
        if (showErrorToast && resp.msg.trim().isNotEmpty) {
          BotToast.showText(text: resp.msg);
        }
        failedCallback != null ? failedCallback(resp.msg) : null;
      }
      return result.data;
    } catch (error) {
      final errorMsg = '接口：$path  信息：${error.toString()}';
      if (kDebugMode) {
        print(errorMsg);
      }

      failedCallback != null ? failedCallback(errorMsg) : null;
      if (error is DioException) {
        return Future.error(errorMsg);
      } else {
        return Future.error(error);
      }
    }
  }

  Future download(
      String url, {
        required String cachePath,
        CancelToken? cancelToken,
        Function(int count, int total)? onProgress,
      }) {
    return dio.download(
      url,
      cachePath,
      options: Options(receiveTimeout: const Duration(minutes: 10)),
      cancelToken: cancelToken,
      onReceiveProgress: onProgress,
    );
  }
}

class ApiResp {
  int code;
  String msg;
  dynamic data;

  ApiResp.fromJson(Map<String, dynamic> map)
      : code = map["code"] ?? -1,
        msg = map["msg"] ?? '',
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['data'] = data;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

///自定义响应拦截器
class CustomInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.extra['requestTime'] = DateTime.now(); // 请求前记录时间
    if (options.uri.toString().contains('file/upload') ||
        options.uri.toString().contains('user/getMomentPage')) {
    } else {
      // options.headers['contentType'] = 'application/json';
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      String token = sharedPreferences.getString('AccessToken') ?? '';

      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    print(options.headers);

    ///可在请求头按需添加实际使用字段
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestTime =
    response.requestOptions.extra['requestTime'] as DateTime;
    final duration = DateTime.now().difference(requestTime); // 计算请求和响应的总时间
    print('请求时间: ${duration.inMilliseconds}ms');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestTime = err.requestOptions.extra['requestTime'] as DateTime;
    final duration = DateTime.now().difference(requestTime); // 计算请求和响应的总时间
    print('请求时间: ${duration.inMilliseconds}ms');
    super.onError(err, handler);
  }
}

///图片压缩
Future<Uint8List?> imgCompressAndGetFile(String path) async {
  var result = await FlutterImageCompress.compressWithFile(path,
      keepExif: true, quality: 70);
  return result;
}
