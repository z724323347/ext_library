import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ext_library/lib_ext.dart';
import 'package:rxdart/rxdart.dart';

import 'debug_config.dart';

class LogData {
  LogData({
    required this.url,
    required this.path,
    required this.method,
    required this.params,
    required this.paramsType,
    required this.header,
    required this.respType,
    this.respCode,
    this.respMsg,
    this.respText,
    this.errorType,
    this.errorMessage,
    this.error,
    this.isExpand = false,
    this.duration,
    this.time,
  });

  // 请求地址
  String url;
  // 请求路径
  String path;
  // 请求方式
  String method;
  // 请求参数
  String params;
  // 请求参数类型
  String paramsType;
  // header信息
  Map<String, dynamic> header;
  // 返回类型
  String respType;
  // 返回码
  String? respCode;
  // 返回信息
  String? respMsg;
  // 返回文本值
  String? respText;
  // 错误类型
  String? errorType;
  // 错误信息
  String? errorMessage;
  // 错误对象
  Object? error;
  //
  bool isExpand;
  // 响应时间
  Duration? duration;
  // 请求时间时间
  DateTime? time;

  bool get isSuccess => errorType == null;

  @override
  String toString() {
    return 'LogData{url: $url, method: $method, params: $params, paramsType: $paramsType, header: ${jsonEncode(header)}, respText: $respText, respType: $respType, respCode: $respCode, respMsg: $respMsg, errorMessage: $errorMessage, errorType: $errorType, error: $error, duration:$duration, time:$time}';
  }
}

class LogManager {
  LogManager() {
    final Stream<LogData> error = _errorStream.map<LogData>(_parseError);
    final Stream<LogData> response =
        _responseStream.map<LogData>(_parseResponse);
    final PublishConnectableStream<LogData> stream =
        MergeStream([error, response]).publish();

    logDataStream = stream;
    _subscription = stream.connect();
  }

  final Map<String, RequestOptions> _requestCache = <String, RequestOptions>{};

  /// 错误流
  final PublishSubject<DioException> _errorStream =
      PublishSubject<DioException>();

  /// 结果流
  final PublishSubject<Response> _responseStream =
      PublishSubject<Response<dynamic>>();

  /// 向外输出日志流
  late final Stream<LogData> logDataStream;
  late final StreamSubscription _subscription;

  LogData _parseError(DioException error) {
    final RequestOptions request = error.requestOptions;

    final String? errorMessage = error.message;
    final String errorType = error.type.toString();
    final Object? errorObj = error.error;
    final String respType = request.responseType.toString();
    final String? respCode = error.response?.statusCode.toString();
    final String? respMsg = error.response?.statusMessage.toString();
    String? respText = error.response?.data.toString();
    if (error.response?.data is Map) {
      // respText = jsonEncode(error.response?.data ?? {});
      respText = (error.response?.data as Map).jsonFormat;
    }
    // 请求地址
    final String url = request.uri.toString();
    final String path = request.path;
    // 请求方式
    final String method = request.method;
    String postParams = request.data.toString();
    String postFields = jsonEncode(request.data).jsonFormat;
    if (request.data is FormData) {
      postParams = (request.data as FormData)
          .fields
          .map((MapEntry<String, String> e) => '${e.key}:${e.value}')
          .jsonFormat;
      postFields = (request.data as FormData)
          .files
          .map((MapEntry<String, MultipartFile> e) =>
              '${e.key}:${e.value.filename}-${e.value.contentType}-${e.value.length}')
          .jsonFormat;
    }
    // 请求参数
    String params =
        '${method.toLowerCase()}:${request.queryParameters.jsonFormat}';
    if (method.toLowerCase() == 'post') {
      params = 'POST:\n参数:$postParams';
    }
    if (request.uri
        .toString()
        .contains('nls-gateway-cn-shanghai.aliyuncs.com')) {
      params = 'POST:\n参数: aliyun  不监控';
    }

    // header信息
    final Map<String, dynamic> header = request.headers;

    return LogData(
      url: url,
      path: path,
      method: method,
      params: params,
      paramsType: '--',
      header: header,
      respType: respType,
      respCode: respCode,
      respText: respText,
      respMsg: respMsg,
      errorType: errorType,
      errorMessage: errorMessage,
      error: errorObj,
    );
  }

  LogData _parseResponse(Response<dynamic> response) {
    final beginTime = response.requestOptions.extra[reqtUnixTime];
    final endTime = response.requestOptions.extra[respUnixTime];
    Duration? duration;
    if (beginTime != null && beginTime is DateTime) {
      final now = endTime ?? DateTime.now();
      duration = now.difference(beginTime);
    }
    final RequestOptions request = response.requestOptions;

    final String respType = request.responseType.toString();
    final String respCode = response.statusCode.toString();
    final String respMsg = response.statusMessage.toString();

    String respText = response.data.toString();
    if (response.data is Map) {
      // respText = jsonEncode(response.data);
      respText = (response.data as Map).jsonFormat;
    }
    // 请求地址
    final String url = request.uri.toString();
    //
    final String path = request.path;
    // 请求方式
    final String method = request.method;
    // 请求参数
    String postParams = request.data.toString();
    String postFields = jsonEncode(request.data);
    if (request.data is FormData) {
      postParams = (request.data as FormData)
          .fields
          .map((MapEntry<String, String> e) => '${e.key}:${e.value}')
          .join(',');
      postFields = (request.data as FormData)
          .files
          .map((MapEntry<String, MultipartFile> e) {
        return '${e.key}:${e.value.filename}-${e.value.contentType}-${e.value.length}';
      }).join(',');
    }
    // 请求参数
    String params = 'GET:${request.queryParameters.jsonFormat}';
    if (method.toLowerCase() == 'post') {
      params = 'POST:\n参数:\n${postParams}\n文件:\n$postFields';
    }
    if (method.toLowerCase() == 'put') {
      params = 'PUT:\n参数:\n$postParams\n文件:\n$postFields';
    }
    if (request.uri.toString().contains('nls-gateway')) {
      params = 'POST:\n参数: aliyun不监控(${request.uri.host})';
    }

    // header信息
    final Map<String, dynamic> header = request.headers;
    return LogData(
      url: url,
      path: path,
      method: method,
      params: params,
      paramsType: '--',
      header: header,
      respType: respType,
      respCode: respCode,
      respMsg: respMsg,
      respText: respText,
      duration: duration,
      time: beginTime,
    );
  }

  void addRequest(RequestOptions requestOptions) {
    _requestCache[requestOptions.uri.toString()] = requestOptions;
  }

  void addResponse(Response<dynamic> response) {
    _responseStream.add(response);
  }

  void addError(DioException error) {
    _errorStream.add(error);
  }

  void dispose() {
    _subscription.cancel();
    _errorStream.close();
    _responseStream.close();
  }
}
