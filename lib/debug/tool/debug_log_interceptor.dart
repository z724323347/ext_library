import 'package:dio/dio.dart';
import 'debug_config.dart';
import '../store/debug_log_ctrl.dart';

class DebugLogInterceptor extends InterceptorsWrapper {
  DebugLogSer get store => DebugLogSer.to;

  ///记录请求值
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _handleRequest(options);
    super.onRequest(options, handler);
  }

  ///记录请求结果
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _handleResponse(response);
    return super.onResponse(response, handler);
  }

  ///记录异常
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _handleError(err);
    return super.onError(err, handler);
  }

  void _handleRequest(RequestOptions options) {
    options.extra.putIfAbsent(reqtUnixTime, () => DateTime.now());
    if (!store.openLog.value) {
      return;
    }
    store.addRequest(options);
  }

  void _handleResponse(Response<dynamic> response) {
    response.extra.putIfAbsent(respUnixTime, () => DateTime.now());
    if (!store.openLog.value) {
      return;
    }
    store.addResponse(response);
  }

  void _handleError(DioException error) {
    if (!store.openLog.value) {
      return;
    }
    store.addError(error);
  }
}
