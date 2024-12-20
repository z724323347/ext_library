import 'dart:collection';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 设计图 标准尺寸  375.0 x 812.0
const Size appSize = Size(375.0, 812.0);

void runAutoApp(Widget app) {
  AutoWidgetsFlutterBinding.ensureInitialized()
    // ignore: invalid_use_of_protected_member
    ..scheduleAttachRootWidget(app)
    ..scheduleWarmUpFrame();
}

/// 获取 适配的 MediaQuery 对象
MediaQuery getMediaQuery({
  required BuildContext context,
  required Widget widget,
}) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(
      size: Size(
        appSize.width,
        window.physicalSize.height /
            (window.physicalSize.width / appSize.width),
      ),
      devicePixelRatio: window.physicalSize.width / appSize.width,
    ),
    child: widget,
  );
}

/// 一个自定义的 WidgetsFlutterBinding 子类
///
///   part1
///
/// ```dart
///   void main() {
///      AutoSizeUtil.setStandard(375.0);
///      runAutoApp(const MyApp());
///   }
/// ```
///   part2
///
/// ```dart
///   void runAutoApp(Widget app) {
///
///     AutoWidgetsFlutterBinding.ensureInitialized()
///       ..scheduleAttachRootWidget(app)
///       ..scheduleWarmUpFrame();
///   }
/// ```
///
///   part3
///
/// ```dart
///  MaterialApp(
///       title: 'AutoWidgets Demo',
///       builder: AutoSizeUtil.appBuilder,
///       theme: ThemeData(primarySwatch: Colors.blue),
///       home: Scaffold(body: HomePage()),
///     )
/// ```
class AutoWidgetsFlutterBinding extends WidgetsFlutterBinding {
  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  static WidgetsFlutterBinding ensureInitialized() {
    AutoWidgetsFlutterBinding();
    return WidgetsBinding.instance as AutoWidgetsFlutterBinding;
  }

  @override
  void scheduleAttachRootWidget(Widget rootWidget) {
    super.scheduleAttachRootWidget(rootWidget);
  }

  @override
  void initInstances() {
    super.initInstances();
    window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    print(
        'AutoWidgetsFlutterBinding ---width:${window.physicalSize.width / (window.physicalSize.width / appSize.width)}  height:${window.physicalSize.height / (window.physicalSize.width / appSize.width)}');
    return ViewConfiguration(
      size: Size(
        appSize.width,
        window.physicalSize.height /
            (window.physicalSize.width / appSize.width),
      ),
      devicePixelRatio: window.physicalSize.width / appSize.width,
    );
  }

  void _handlePointerDataPacket(PointerDataPacket packet) {
    // We convert pointer data to logical pixels so that e.g. the touch slop can be
    // defined in a device-independent manner.
    _pendingPointerEvents.addAll(
      PointerEventConverter.expand(
        packet.data,
        window.physicalSize.width / appSize.width,
      ),
    );
    if (!locked) {
      _flushPointerEventQueue();
    }
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty) {
      handlePointerEvent(_pendingPointerEvents.removeFirst());
    }
  }
}
