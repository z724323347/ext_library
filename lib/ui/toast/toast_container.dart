import 'dart:math' as math;

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
  }) : super(key: key);

  final Widget child;
  final ContainerType? type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      decoration: BoxDecoration(
        // color: const Color(0xFF000000).withOpacity(0.8),
        color: Colors.grey.shade700,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: DefaultTextStyle.merge(
        textAlign: TextAlign.center,
        child: LayoutBuilder(builder: _buildText),
      ),
    );
  }

  Widget _buildText(BuildContext context, BoxConstraints constraints) {
    final double shortestSide =
        math.min(constraints.maxWidth, constraints.maxHeight);
    final double? fixedWidth =
        shortestSide < double.infinity ? shortestSide / 75 * 40 : null;

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
              minWidth: MediaQuery.of(context).size.width / 3.5,
              maxWidth: MediaQuery.of(context).size.width / 3.5,
              minHeight: MediaQuery.of(context).size.width / 3.5,
            ),
            child: child,
          );
  }
}
