import 'package:ext_library/tool/extensions/iterable_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'toast_container.dart';

class ToastLoading extends StatelessWidget {
  const ToastLoading(
    this._text, {
    Key? key,
    this.textListenable,
  }) : super(key: key);

  final String? _text;
  final ValueListenable<String>? textListenable;

  @override
  Widget build(BuildContext context) {
    Widget? textWidget;
    if (textListenable != null) {
      textWidget = ValueListenableBuilder<String>(
        valueListenable: textListenable!,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(
            _text != null ? '$_text\n$value' : value,
            style: const TextStyle(color: Colors.white),
          );
        },
      );
    } else if (_text != null) {
      textWidget = Text(
        _text!,
        style: const TextStyle(color: Colors.white),
      );
    }

    return ToastContainer(
      type: ContainerType.loading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 20,
            height: 20,
          ),
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              // backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3.0,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          if (textWidget != null) Flexible(child: textWidget),
        ].divide(const SizedBox(height: 8)),
      ),
    );
  }
}
