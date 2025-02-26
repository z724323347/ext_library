import 'package:flutter/material.dart';

import 'anim_text.dart';

class TextLoading extends StatelessWidget {
  String? text;
  TextStyle? style;

  bool withDot = true;

  TextLoading({super.key, this.text, this.style, this.withDot = true});

  TextLoading.custom({super.key, this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        children: [
          WidgetSpan(
            child: TextAnim.jump(
              withDot ? ' ...' : '',
              style: style?.copyWith(fontSize: 20),
            ),
          )
        ],
        style: style,
      ),
    );
  }
}
