import 'dart:math' as math;

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';

enum ContainerType {
  /// 文本
  text,

  /// loading
  loading,
}

class ToastContainer extends StatelessWidget {
  const ToastContainer({
    Key? key,
    required this.child,
    this.type = ContainerType.text,
    this.color,
  }) : super(key: key);

  final Widget child;
  final ContainerType? type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    Widget view = Container(
      padding: isTablet ? 20.horizontal.copyWith(top: 15, bottom: 20) : 15.all,
      decoration: BoxDecoration(
        // color: const Color(0xFF000000).withOpacity(0.8),
        color: color ?? Colors.grey.shade700,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        child: LayoutBuilder(builder: _buildText),
      ),
    );

    // 处理 600 以上的屏幕
    if (isTablet) {
      return Transform.scale(scale: 0.6, child: view);
    }
    return view;
  }

  Widget _buildText(BuildContext context, BoxConstraints constraints) {
    final double shortestSide =
        math.min(constraints.maxWidth, constraints.maxHeight);
    final double? fixedWidth =
        shortestSide < double.infinity ? shortestSide / 75 * 40 : null;
    double minWidth = MediaQuery.of(context).size.width / 4;
    bool isTablet = MediaQuery.of(context).size.width > 600;
    if (isTablet) {
      return type == ContainerType.text
          ? child
          : ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: fixedWidth ?? constraints.minWidth,
                maxWidth: fixedWidth ?? constraints.maxWidth,
                maxHeight: constraints.hasBoundedHeight
                    ? constraints.maxHeight / 2
                    : constraints.maxHeight,
              ),
              child: child,
            );
    }
    return type == ContainerType.text
        ? ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: fixedWidth ?? constraints.minWidth,
              maxWidth: fixedWidth ?? constraints.maxWidth,
              maxHeight: constraints.hasBoundedHeight
                  ? constraints.maxHeight / 2
                  : constraints.maxHeight,
            ),
            child: child,
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
              // minWidth: MediaQuery.of(context).size.width / 3.5,
              // maxWidth: MediaQuery.of(context).size.width / 3.5,
              // minHeight: MediaQuery.of(context).size.width / 3.5,
              minWidth: minWidth,
              maxWidth: minWidth,
              maxHeight: constraints.hasBoundedHeight
                  ? constraints.maxHeight / 2
                  : constraints.maxHeight,
            ),
            child: child,
          );
  }
}
