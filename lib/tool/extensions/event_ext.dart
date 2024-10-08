import 'dart:async';

import 'package:event_bus/event_bus.dart';
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
