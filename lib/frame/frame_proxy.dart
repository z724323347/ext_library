import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'frame_notify.dart';

class ItemSizeInfoNotifier extends SingleChildRenderObjectWidget {
  const ItemSizeInfoNotifier({
    Key? key,
    required this.index,
    required Widget? child,
  }) : super(key: key, child: child);
  final int? index;

  @override
  InitialRenderSizeChangedWithCallback createRenderObject(
      BuildContext context) {
    return InitialRenderSizeChangedWithCallback(
        onLayoutChangedCallback: (size) {
      LayoutInfoNotification(index, size).dispatch(context);
    });
  }
}

class InitialRenderSizeChangedWithCallback extends RenderProxyBox {
  InitialRenderSizeChangedWithCallback({
    RenderBox? child,
    required this.onLayoutChangedCallback,
  }) : super(child);

  final Function(Size size) onLayoutChangedCallback;

  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      onLayoutChangedCallback(size);
    }
    _oldSize = size;
  }
}
