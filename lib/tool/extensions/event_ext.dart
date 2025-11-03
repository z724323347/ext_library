import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
export 'package:event_bus/event_bus.dart';

/// event_bus 扩展函数 EventBusTools
extension LibEventBus on EventBus {
  /// 监听
  StreamSubscription<T> listen<T>(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return on<T>().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// 发送事件
  void send<T>(T event) {
    fire(event);
  }
}

/// EventBus tools
final EventBusTools busTools = EventBusTools._internal();

class EventBusTools {
  // static EventBus? bus;
  late EventBus bus;
  EventBusTools._internal() {
    bus = EventBus();
  }

  /// 创建
  List<StreamSubscription<dynamic>> create() {
    return <StreamSubscription<dynamic>>[];
  }

  /// 关闭
  void close(List<StreamSubscription<dynamic>> stream) {
    // destroy();
    for (final sub in stream) {
      sub.cancel();
    }
  }
}

/// 测试 eventBus
///
/// 流程
///
/// 1.初始化  final _stream = EventBusTools.create();
///
/// 2.init添加监听  _stream.addAll([kTestBus.listen])  todo:同时 kTestBus.send(data)
///
/// 3.dispose关闭 EventBusTools.close(_stream);
///
final kTestBus = EventBus();

class EventBusData {
  ///  类型
  int type;

  /// 数据
  dynamic data;

  /// 额外msg
  Map<String, dynamic>? ext;

  EventBusData({required this.type, this.data, this.ext});
}



/// 封装后的高级事件总线
class AppEventBus {
  static final EventBus _instance = EventBus();

  // 私有构造，确保单例
  AppEventBus._internal();

  /// 获取单例实例
  static EventBus get instance => _instance;

  /// 发送事件
  static void sendEvent<T>(T event) {
    if (kDebugMode) {
      print('[EventBus] Firing event: ${event.runtimeType}');
    }
    instance.fire(event);
  }

  /// 订阅事件，返回可取消的订阅对象
  static StreamSubscription<T> on<T>(void Function(T event) handler, {
    bool handleError = true,
    ErrorCallback? onError,
  }) {
    final subscription = instance.on<T>().listen((event) {
      if (kDebugMode) {
        print('[EventBus] Received event: ${event.runtimeType}');
      }
      _safeRun(() => handler(event), onError: onError);
    }, onError: handleError ? (error, stack) {
      _safeRun(() => onError?.call(error, stack));
    } : null);

    return subscription;
  }

  static void _safeRun(void Function() action, {ErrorCallback? onError}) {
    try {
      action();
    } catch (e, s) {
      if (kDebugMode) {
        print('[EventBus] Handler error: $e\n$s');
      }
      onError?.call(e, s);
    }
  }
}

/// Flutter Widget 集成扩展
mixin EventBusMixin<T extends StatefulWidget> on State<T> {
  final List<StreamSubscription> _eventSubscriptions = [];

  /// 安全订阅事件，自动管理生命周期
  void subscribe<Event>(void Function(Event event) handler, {
    bool handleError = true,
    ErrorCallback? onError,
  }) {
    _eventSubscriptions.add(
        AppEventBus.on<Event>(handler, handleError: handleError, onError: onError)
    );
  }

  @override
  void dispose() {
    for (final sub in _eventSubscriptions) {
      sub.cancel();
    }
    if (kDebugMode) {
      print('[EventBus] Canceled ${_eventSubscriptions.length} subscriptions');
    }
    super.dispose();
  }
}

typedef ErrorCallback = void Function(Object error, StackTrace stackTrace);