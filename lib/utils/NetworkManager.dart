import 'package:dio/dio.dart';
import 'dart:convert';

// 数据来源：http://www.xbiquge.la/

class HttpUtils {
  static Dio dio;

  /// default options
  static const String API_PREFIX = 'http://www.xbiquge.la';
  static const int CONNECT_TIMEOUT = 1000000;
  static const int RECEIVE_TIMEOUT = 30000;

  // static final Map HEADERS = {
  //   'user-agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) ' +
  //       'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36',
  //   'Content-Type': 'text/html',
  // };

  /// 创建 dio 实例对象
  static Dio getInstance() {
    if (dio == null) {
      dio = new Dio();
      dio.options.baseUrl = API_PREFIX;
      dio.options.connectTimeout = CONNECT_TIMEOUT;
      dio.options.receiveTimeout = RECEIVE_TIMEOUT;
      // dio.options.headers = HEADERS;

      // dio.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
    }
    return dio;
  }
}

class BqgNetworkManager {
  static httpGet(String urlSuffix, Map params) {
    Dio dio = HttpUtils.getInstance();
    if (params != null) {
      dio.options.queryParameters = params;
    }
    var response = dio.get(urlSuffix);
    // Utf8Decoder decode = new Utf8Decoder();
    // String data = decode.convert(response);
    return response;
  }
}
