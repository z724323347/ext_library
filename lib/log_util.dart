// ignore_for_file: avoid_redundant_argument_values, unnecessary_late

import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:chalkdart/chalkstrings.dart';
import 'package:ext_library/tool/tool_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:logarte/logarte.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';
import 'debug/store/logs_ctrl.dart';

export 'package:chalkdart/chalkstrings.dart';
export 'package:logarte/logarte.dart' hide NavigationAction;
extension LibLogarte on Logarte{
  Logarte copy({
    String? password,
    bool ignorePassword = true,
  }){
    return Logarte(
      password: password ?? this.password,
      ignorePassword: ignorePassword,
      onShare: onShare,
      onExport: onExport,
      logBufferLength: logBufferLength,
      onRocketLongPressed: onRocketLongPressed,
      onRocketDoubleTapped: onRocketDoubleTapped,
      disableDebugConsoleLogs: disableDebugConsoleLogs,
      customTab: customTab,
    );
  }
}


final Logarte logarte = Logarte(
  password: 'dev',
  ignorePassword: true,
  disableDebugConsoleLogs: true,
);


///logs 日志
void devLogs(Object? msg, {Function(AppLogsEvent)? addLog}) {
  /// TODO 不要上传
  // if (kReleaseMode) {
  //   // release模式不打印
  //   return;
  // }
  Chain chain = Chain.current(); // Chain.forTrace(StackTrace.current);
  // 将 core 和 flutter 包的堆栈合起来（即相关数据只剩其中一条）
  chain = chain
      .foldFrames((Frame frame) => frame.isCore || frame.package == 'flutter');
  // 取出所有信息帧
  final List<Frame> frames = chain.toTrace().frames;
  // 找到当前函数的信息帧
  final int idx =
      frames.indexWhere((Frame element) => element.member == 'logs');
  if (idx == -1 || idx + 1 >= frames.length) {
    return;
  }
  // 调用当前函数的函数信息帧
  final Frame frame = frames[idx + 1];

  // time
  final String d = DateTime.now().hmsDotSS;
  String str = msg.toString();
  final String path = frame.uri.toString().split('/').last;

  // log 长度切分
  // while (str.isNotEmpty) {
  //   if (str.length > 512) {
  //     _defaultLog(
  //         '💙 $d $path(Line:${frame.line}) =>  ${str.substring(0, 512)}');
  //     str = str.substring(512, str.length);
  //   } else {
  //     _defaultLog('💙 $d $path(Line:${frame.line}) =>  $str');
  //     str = '';
  //   }
  // }
  _defaultLog('[🖨‼️] ${d.yellow} ${path.darkOrange.bold} ${'(Line:${frame.line})'.yellowBright.italic} =>  ${str.greenBright}'.orangeRed);
  logarte.log('[文件:${frame.uri.toString().fixLines}] \n[🖨] $d $path ${'(Line:${frame.line})'} =>  $str');
  final Completer<AppLogsEvent> completer = Completer<AppLogsEvent>()
    ..complete(
      AppLogsEvent(
        time: d,
        msg: msg.toString(),
        breakpoint: '$path(Line:${frame.line})',
        file: frame.uri.toString(),
      ),
    );
  // completer.future.then((v) => DevLogsEventSer.to.add(v));
  completer.future.then((value) {
    if (addLog != null) {
      addLog(value);
    }
  });
}

void _defaultLog(String value, {bool isError = true}) {
  if (isError || kDebugMode) {
    dev.log(value, name: 'LOGS'.orangeRed);
    // devlLogU.i('LOGS: $value');
  }else{
    print(value);
  }
}

///// ************************ LogU ************************ /////

final LogU devlLogU = LogU._internal();

class LogU {
  LogU._internal() {
    if (kDebugMode) {
      Logger.level = Level.debug;
    } else if (kProfileMode) {
      Logger.level = Level.error;
    } else {
      Logger.level = Level.off;
    }
  }

  final Logger _logger = Logger(
    filter: DevelopmentFilter(),
    printer: () {
      final PrettyPrinter realPrinter = PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 10,
        // width of the output
        lineLength: stdout.hasTerminal ? stdout.terminalColumns : 120,
        colors: false,
        printEmojis: false,
        printTime: false,
      );

      if (!realPrinter.colors) {
        return PrefixPrinter(realPrinter);
      }

      return realPrinter;
    }(),
    level: Level.trace,
  );

  void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  dynamic onError<T>(dynamic error, StackTrace stackTrace) {
    e('', error, stackTrace);
  }
}
