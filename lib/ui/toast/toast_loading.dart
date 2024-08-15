import 'package:ext_library/lib_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'toast_container.dart';

class ToastLoading extends StatelessWidget {
  ToastLoading(
    this._text, {
    Key? key,
    this.textListenable,
    this.color,
    this.icon,
    this.textAnim = false,
  }) : super(key: key);

  final String? _text;
  final Color? color;
  final ValueListenable<String>? textListenable;

  final Widget? icon;
  final bool? textAnim;

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
      if (textAnim ?? true) {
        textWidget = JumpingText(
          _text.safety,
          style: const TextStyle(color: Colors.white),
        );
      }
    }

    return ToastContainer(
      type: ContainerType.loading,
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(width: 20, height: 20),
          icon ??
              SizedBox(
                width: 32,
                height: 32,
                // child: CircularProgressIndicator(
                //   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                //   strokeWidth: 3.0,
                // ),
                child: buildStaggeredDots(),
              ),
          const SizedBox(height: 2),
          if (textWidget != null) Flexible(child: textWidget),
        ].divide(const SizedBox(height: 8)),
      ),
    );
  }

  Widget buildStaggeredDots() {
    return Container(
      height: 32,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SpinKitCircle(color: Colors.white, size: 32)],
      ),
    );
  }
}
