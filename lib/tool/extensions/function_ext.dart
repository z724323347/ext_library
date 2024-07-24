// ignore_for_file: strict_raw_type, prefer_function_declarations_over_variables

import 'dart:async';
import 'dart:io';

import 'package:ext_library/lib_ext.dart';
import 'package:ext_library/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

extension LibFutureExt on Future {}

extension LibFutureFunctionExt on Future Function() {
  Future _debounces<T>([
    Duration delay = const Duration(milliseconds: 300),
  ]) async {
    final completer = Completer<T>();

    void _cancel() {
      if (!completer.isCompleted) {
        completer.completeError(Exception());
      }
    }

    void _execute() async {
      _cancel(); // Cancel any pending operation
      try {
        final value = await this();
        if (!completer.isCompleted) {
          completer.complete(value);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    }

    Timer? timer;
    timer = Timer(delay, () async {
      timer?.cancel();
      _execute();
    });

    return completer.future;
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
  VoidCallback debounce([
    Duration delay = const Duration(milliseconds: 300),
  ]) {
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
  /// [func]: 要执行的方法
  VoidCallback throttle(
    Future Function() func,
  ) {
    if (func == null) {
      return func;
    }
    bool enable = true;
    final VoidCallback target = () {
      if (enable == true) {
        enable = false;
        func().then((_) {
          enable = true;
        });
      }
    };
    return target;
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
  VoidCallback delayed([Duration delay = const Duration(milliseconds: 300)]) {
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
