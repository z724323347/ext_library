import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import '../log_manager.dart';
import '../page/fps_log_float.dart';
import '../page/network_log_float.dart';

/// DebugLogSer service控制器
class DebugLogSer extends GetxService implements LogManager {
  /// GetxService instance
  static DebugLogSer get to => GetInstance().putOrFind(() => DebugLogSer());

  final LogManager logManager = LogManager();

  OverlayEntry? _overlayEntry;
  OverlayEntry? _networkOverlayEntry;

  OverlayEntry? _fpsOverlayEntry;
  StreamSubscription? _subscription;

  final openLog = false.obs;

  final openFps = false.obs;

  final RxList<LogData> listLog = RxList<LogData>([]);

  void toFps(BuildContext context) {
    openFps.value = !openFps.value;
    if (openFps.value) {
      _fpsOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return const FpsLogFloat();
      });
      Overlay.of(context).insert(_fpsOverlayEntry!);
    } else {
      _fpsOverlayEntry?.remove();
      _fpsOverlayEntry = null;
    }
  }

  void toggle(BuildContext context) {
    openLog.value = !openLog.value;
    if (openLog.value) {
      _networkOverlayEntry = OverlayEntry(builder: (BuildContext context) {
        return const NetWorkLogFloat();
      });
      Overlay.of(context).insert(_networkOverlayEntry!);
    } else {
      _networkOverlayEntry?.remove();
      _networkOverlayEntry = null;
    }
  }

  void loadStream(BuildContext context) {
    _subscription = logManager.logDataStream.listen((LogData event) {
      _addData(event);
    });
  }

  @override
  void addError(DioException error) {
    logManager.addError(error);
  }

  @override
  void addRequest(RequestOptions requestOptions) {
    logManager.addRequest(requestOptions);
  }

  @override
  void addResponse(Response response) {
    logManager.addResponse(response);
  }

  @override
  void dispose() {
    logManager.dispose();
    _overlayEntry?.remove();
    _networkOverlayEntry?.remove();
    _subscription?.cancel();
  }

  void _addData(LogData data) {
    listLog.insert(0, data);
  }

  void clearLog() {
    listLog.clear();
  }

  @override
  Stream<LogData> get logDataStream => logManager.logDataStream;

  @override
  set logDataStream(Stream<LogData> _logDataStream) {}
}
