import 'package:ext_library/tool/extensions/iterable_ext.dart';
import 'package:flutter/material.dart';

import 'toast_container.dart';

class ToastText extends StatelessWidget {
  const ToastText({
    Key? key,
    this.icon,
    this.text,
  }) : super(key: key);

  final IconData? icon;
  final String? text;

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
              color: Colors.white,
            ),
          if (text != null)
            Flexible(
              child: Text(
                text!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ].divide(const SizedBox(height: 4)),
      ),
    );
  }
}
