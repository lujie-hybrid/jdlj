/*
 * @author: lujie
 * @Date: 2020-07-27 16:40:01
 * @LastEditTime: 2020-07-28 09:30:03
 * @FilePath: \jdlj\lib\components\ajax.dart
 * @descripttion: [desc]
 * @editor: [lj]
 */
import 'package:dio/dio.dart';
import 'package:jdlj/config/Config.dart';

// 或者通过传递一个 `options`来创建dio实例
BaseOptions options = BaseOptions(
  baseUrl: "${JdConfig.domain}/api",
  connectTimeout: 5000,
  receiveTimeout: 3000,
);

Dio jdDio = Dio(options);

class JdAjax extends InterceptorsWrapper {
  static Response _response;
  static Future get(String url) async {
    _response = await jdDio.get(url);
    return _response;
  }

  static Future post(String url, Map<String, dynamic> data) async {
    _response = await jdDio.post(url, data: data);
    return _response;
  }

  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
