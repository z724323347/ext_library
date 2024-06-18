import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText({
    super.key,
    required this.text,
    this.textStyle,
    this.buttonTextStyle,
    this.initLength = 140,
    this.expanded,
    this.textAlign,
  });

  final String text;
  final TextStyle? textStyle;
  final TextStyle? buttonTextStyle;
  final int initLength;
  Function(bool)? expanded;
  TextAlign? textAlign;

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
          TextSpan(
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
}
