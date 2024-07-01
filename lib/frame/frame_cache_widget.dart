import 'package:flutter/cupertino.dart';
import 'frame_task.dart';

import 'frame_logcat.dart';
import 'frame_notify.dart';

/// 帧渲染缓存组件
class FrameCacheWidget extends StatefulWidget {
  const FrameCacheWidget(
      {Key? key, required this.child, this.estimateCount = 0})
      : super(key: key);

  /// 子节点中如果包含分帧组件，则缓存**实际的 widget 尺寸**
  final Widget child;

  /// 预估屏幕上子节点的数量，提高快速滚动时的响应速度
  final int estimateCount;

  static FrameCacheWidgetState? of(BuildContext context) {
    return context.findAncestorStateOfType<FrameCacheWidgetState>();
  }

  @override
  FrameCacheWidgetState createState() => FrameCacheWidgetState();
}

class FrameCacheWidgetState extends State<FrameCacheWidget> {
  Map<int?, Size> itemsSizeCache = <int?, Size>{};

  @override
  void initState() {
    super.initState();
    setFramingTaskQueue();
  }

  @override
  void didUpdateWidget(FrameCacheWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setFramingTaskQueue();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext ctx) {
        return NotificationListener<LayoutInfoNotification>(
          onNotification: (LayoutInfoNotification notification) {
            logcat(
                'size info :  index = ${notification.index}  size = ${notification.size.toString()}');
            saveLayoutInfo(notification.index, notification.size);
            return true;
          },
          child: widget.child,
        );
      },
    );
  }

  void saveLayoutInfo(int? index, Size size) {
    itemsSizeCache[index] = size;
  }

  void setFramingTaskQueue() {
    if (widget.estimateCount != 0) {
      FrameTaskQueue.instance!.maxTaskSize = widget.estimateCount;
    }
  }

  @override
  void dispose() {
    FrameTaskQueue.instance!.resetMaxTaskSize();
    super.dispose();
  }
}
