import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'light_text.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText({
    super.key,
    required this.text,
    this.textStyle,
    this.buttonTextStyle,
    this.initLength = 140,
    this.expanded,
    this.textAlign,
    this.lightText = '',
  });

  final String text;
  final TextStyle? textStyle;
  final TextStyle? buttonTextStyle;
  final int initLength;
  final Function(bool)? expanded;
  final TextAlign? textAlign;

  ///
  final String lightText; // 要高亮显示的文字（默认为空字符串，即不高亮显示文本）

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final overflow = widget.text.length > widget.initLength;
    final displayText = overflow && !_isExpanded
        ? '${widget.text.substring(0, widget.initLength)}...'
        : widget.text;

    return Column(
      children: [
        Text.rich(
          widget.lightText.isNotEmpty
              ? TextSpan(children: [
                  WidgetSpan(
                    child: HighlightText.multiple(
                      queries: [widget.lightText],
                      source: displayText,
                      matchedTextStyle: _defaultLightStyle,
                      textStyle: widget.textStyle,
                      caseSensitive: false,
                    ),
                  ),
                  ...[if (overflow) _buildOverflowButton(context)],
                ])
              : TextSpan(
                  text: displayText,
                  children: [
                    if (overflow) _buildOverflowButton(context),
                  ],
                ),
          style: widget.textStyle,
          maxLines: _isExpanded ? null : 3,
          textAlign: widget.textAlign,
        ),
      ],
    );
  }

  TextSpan _buildOverflowButton(BuildContext context) {
    return TextSpan(
      text: _isExpanded ? ' <收起' : ' 展开>',
      style: widget.buttonTextStyle ??
          const TextStyle(color: Colors.green, fontSize: 13),
      recognizer: TapGestureRecognizer()
        ..onTap = () => setState(() {
              _isExpanded = !_isExpanded;
              if (widget.expanded != null) {
                widget.expanded!(_isExpanded);
              }
            }),
    );
  }

  // 默认高亮文本的样式
  TextStyle _defaultLightStyle = TextStyle(color: Colors.yellow);

  /// 需要高亮显示的内容
  TextSpan _lightView(String text, String lightText) {
    List<TextSpan> spans = [];
    int start = 0; // 当前要截取字符串的起始位置
    int end;

    // end 表示要高亮显示的文本出现在当前字符串中的索引
    // 如果有符合的高亮文字
    while ((end = text.toLowerCase().indexOf(lightText.toLowerCase(), start)) !=
        -1) {
      // 第一步：添加正常显示的文本
      spans.add(
          TextSpan(text: text.substring(start, end), style: widget.textStyle));
      // 第二步：添加高亮显示的文本
      spans.add(TextSpan(text: lightText, style: _defaultLightStyle));
      // 设置下一段要截取的开始位置
      start = end + lightText.length;
    }
    // 如果没有要高亮显示的，则 start=0，也就是返回了传进来的 text
    // 如果有要高亮显示的，则 start=最后一个高亮显示文本的索引，然后截取到 text 的末尾
    spans.add(TextSpan(
        text: text.substring(start, text.length), style: widget.textStyle));

    return TextSpan(children: spans);
  }
}
