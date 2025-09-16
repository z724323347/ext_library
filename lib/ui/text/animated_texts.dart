import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ext_library/tool/tool_lib.dart';
import 'package:flutter/material.dart';

enum AnimatedTextsType { fade, slide, typer, writer }

class AnimatedTexts extends StatelessWidget {
  final List<String> texts;
  final AnimatedTextsType animType;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Duration duration;

  const AnimatedTexts({
    super.key,
    this.animType = AnimatedTextsType.fade,
    this.texts = const [],
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      repeatForever: true,
      animatedTexts: _buildAnimatedTexts(),
      pause: 1500.ms,
    );
  }

  List<AnimatedText> _buildAnimatedTexts() => texts.map(
        (text) {
          if (animType == AnimatedTextsType.typer) {
            return TyperAnimatedText(
              text,
              speed: Duration(
                  milliseconds: duration.inMilliseconds ~/ text.length),
              textAlign: textAlign,
              textStyle: textStyle,
            );
          } else if (animType == AnimatedTextsType.slide) {
            return RotateAnimatedText(
              text,
              duration: duration,
              alignment: Alignment.centerLeft,
              textAlign: textAlign,
              textStyle: textStyle,
            );
          } else if (animType == AnimatedTextsType.writer) {
            return TypewriterAnimatedText(
              text,
              speed: duration,
              textAlign: textAlign,
              textStyle: textStyle,
              cursor: ' |',
            );
          } else {
            return FadeAnimatedText(
              text,
              duration: duration,
              textAlign: textAlign,
              textStyle: textStyle,
            );
          }
        },
      ).toList();
}
