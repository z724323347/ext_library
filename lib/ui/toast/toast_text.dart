import 'package:ext_library/tool/extensions/iterable_ext.dart';
import 'package:flutter/material.dart';

import 'toast_container.dart';

class ToastText extends StatelessWidget {
  const ToastText({
    Key? key,
    this.icon,
    this.text,
    this.textColor,
  }) : super(key: key);

  final IconData? icon;
  final String? text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ToastContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null)
            Icon(
              icon,
              size: 30,
              color: textColor ?? Colors.white,
            ),
          if (text != null)
            Flexible(
              child: Text(
                text!,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
        ].divide(const SizedBox(height: 4)),
      ),
    );
  }
}
