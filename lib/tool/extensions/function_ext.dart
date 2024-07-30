// ignore_for_file: strict_raw_type, prefer_function_declarations_over_variables

import 'dart:async';
import 'dart:io';

import 'package:ext_library/lib_ext.dart';
import 'package:ext_library/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

typedef ThrottleCallback = void Function();

class Throttle {
  final Duration duration;
  // 使用一个 StreamController 来控制事件流
  final StreamController<void> _controller = StreamController<void>.broadcast();
  // 保存上一次事件的时间戳
  int _lastEventTimestamp = 0;

  Throttle(this.duration);

  // 启动一个节流的事件
  Stream<void> start(ThrottleCallback callback) {
    // 检查是否在节流时间范围内
    if (_lastEventTimestamp == 0 ||
        DateTime.now().millisecondsSinceEpoch - _lastEventTimestamp >=
            duration.inMilliseconds) {
      // 如果不在节流时间内，则执行回调函数
      callback();
      // 更新时间戳
      _lastEventTimestamp = DateTime.now().millisecondsSinceEpoch;
    } else {
      // 如果在节流时间内，则忽略此次事件
      // 可以通过添加日志或其他方式来记录事件被忽略的情况
      devLogs('Throttle  被拦截 ($_lastEventTimestamp)');
    }
    // 返回事件流，可能用于外部监听
    return _controller.stream;
  }

  // 销毁资源
  void dispose() {
    _controller.close();
  }
}

extension LibFutureFunctionExt on Future Function() {
  /// 函数节流
  ///
  /// (func): 要执行的方法
  Future Function() throttleF(Future Function() func) {
    if (func == null) {
      return func;
    }
    bool enable = true;
    Future Function() target = () async {
      if (enable == true) {
        enable = false;
        func().then((_) {
          enable = true;
        });
      }
    };
    return target;
  }

  Future<T> isMobile<T>() async {
    final completer = Completer<T>();
    if (Platform.isAndroid || Platform.isIOS) {
      final value = await this();
      if (!completer.isCompleted) {
        completer.complete(value);
      }
      return completer.future;
    } else {
      print('logs Platform: ${Platform.operatingSystem} ');
      return await Future.value(null);
    }
  }
}

/// VoidCallback 扩展函数
extension LibVoidCallbackExt on VoidCallback {
  /// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  VoidCallback debounce([Duration delay = const Duration(milliseconds: 300)]) {
    Timer? timer;
    final VoidCallback target = () {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        this.call();
      });
    };
    return target;
  }

  /// 函数节流
  ///
  /// [delay]:设置节流时间默认 2 秒
  VoidCallback throttle([Duration delay = const Duration(milliseconds: 2000)]) {
    Throttle throttle = Throttle(delay);
    return () => throttle.start(() => this.call());
  }

  /// func 添加振动反馈
  ///
  /// [func]: 要执行的方法
  VoidCallback vibration() {
    final VoidCallback target = () {
      libVibration();
      this.call();
    };
    return target;
  }

  /// 隐藏键盘
  ///
  /// [func]: 要执行的方法
  VoidCallback keyBoard() {
    final VoidCallback target = () {
      if (Get.context != null) {
        final FocusScopeNode currentFocus = FocusScope.of(Get.context!);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      }
      this.call();
    };
    return target;
  }

  /// 延迟执行
  VoidCallback delayed([Duration delay = const Duration(milliseconds: 200)]) {
    final VoidCallback target = () {
      Future.delayed(delay, () {
        this.call();
      });
    };
    return target;
  }

  /// 是否是移动端
  VoidCallback isMobile() {
    if (Platform.isAndroid || Platform.isIOS) {
      return this;
    } else {
      devLogs('logs object');
      return () {};
    }
  }
}

extension FunctionExt<T> on Function(T) {
  ///[func] 是否为空
  ///
  ///
  bool get isnull {
    if (this == null) {
      return true;
    } else {
      return false;
    }
  }

  /// 函数防抖
  ///
  /// [func]: 要执行的方法
  /// [delay]: 要迟延的时长
  Function(T) debounce([
    Duration delay = const Duration(milliseconds: 300),
  ]) {
    Timer? timer;
    final Function(T) target = (_) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(delay, () {
        this.call(_);
      });
    };
    return target;
  }

  Function isMobile() {
    if (Platform.isAndroid || Platform.isIOS) {
      return this;
    } else {
      return () {};
    }
  }
}

/// 振动  levle = 0 为重震动 1 为中震动 2 为轻震动
void libVibration({int levle = 0}) {
  if (levle == 0) {
    HapticFeedback.heavyImpact();
    return;
  }
  if (levle == 1) {
    HapticFeedback.mediumImpact();
    return;
  }
  HapticFeedback.lightImpact();
}
