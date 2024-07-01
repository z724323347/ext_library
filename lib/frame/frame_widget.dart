// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'frame_task.dart';
import 'frame_proxy.dart';
import 'frame_cache_widget.dart';
import 'frame_logcat.dart';

/// 帧渲染组件
class FrameWidget extends StatefulWidget {
  const FrameWidget({
    Key? key,
    this.index,
    this.placeHolder,
    required this.child,
  }) : super(key: key);

  /// The Widget
  ///
  /// 实际需要渲染的 widget
  final Widget child;

  /// The placeholder widget
  ///
  /// 占位 widget，尽量设置简单的占位，不传默认是 Container()
  final Widget? placeHolder;

  /// Identifies its own ID
  ///
  /// 分帧组件 id，使用 FrameCacheWidget 的场景必传，
  final int? index;

  @override
  FrameWidgetState createState() => FrameWidgetState();
}

class FrameWidgetState extends State<FrameWidget> {
  Widget? result;

  @override
  void initState() {
    super.initState();
    result = widget.placeHolder ?? Container(height: 20);
    final Map<int?, Size>? size = FrameCacheWidget.of(context)?.itemsSizeCache;
    Size? itemSize;
    if (size != null && size.containsKey(widget.index)) {
      itemSize = size[widget.index];
      logcat('cache hit：${widget.index} ${itemSize.toString()}');
    }
    if (itemSize != null) {
      result = SizedBox(
        width: itemSize.width,
        height: itemSize.height,
        child: result,
      );
    }
    transformWidget();
  }

  @override
  void didUpdateWidget(FrameWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    transformWidget();
  }

  @override
  Widget build(BuildContext context) {
    return ItemSizeInfoNotifier(index: widget.index, child: result);
  }

  void transformWidget() {
    SchedulerBinding.instance.addPostFrameCallback((Duration t) {
      FrameTaskQueue.instance!.scheduleTask(() {
        if (mounted)
          setState(() {
            result = widget.child;
          });
      }, Priority.animation, () => !mounted, id: widget.index);
    });
  }
}
