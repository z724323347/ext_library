import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'fps_observer_widget.dart';

const double _kInspectButtonMargin = 10.0;
const double _kErrorReminderButtonMargin = 40.0;
late OverlayState overlayState;

class FpsWidgetInspector extends StatefulWidget {
  /// 展示性能监控数据
  static bool debugShowPerformanceMonitor = true;

  /// Creates a widget that enables inspection for the child.
  ///
  /// The [child] argument must not be null.
  const FpsWidgetInspector({Key? key, required this.child}) : super(key: key);

  /// The widget that is being inspected.
  final Widget child;

  @override
  _FpsWidgetInspectorState createState() => _FpsWidgetInspectorState();
}

class _FpsWidgetInspectorState extends State<FpsWidgetInspector> {
  final GlobalKey rootGlobalKey = GlobalKey();
  final InspectorSelection selection =
      WidgetInspectorService.instance.selection;

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    //release模式不打开FPS监控
    if (const bool.fromEnvironment('dart.vm.product')) {
      return child;
    }

    Widget performanceObserver = Container();

    if (FpsWidgetInspector.debugShowPerformanceMonitor) {
      performanceObserver = FpsObserverWidget();
    }

    if (FpsWidgetInspector.debugShowPerformanceMonitor) {
      child = Stack(
        children: <Widget>[
          IgnorePointer(
            ignoring: false,
            key: rootGlobalKey,
            child: child,
          ),
          Positioned(
            right: _kInspectButtonMargin,
            bottom: _kErrorReminderButtonMargin,
            child: performanceObserver,
          )
        ],
      );
    }
    return child;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
