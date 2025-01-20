// import 'package:flutter/material.dart';

// class HyphenatedText extends StatelessWidget {
//   final String text;
//   final TextStyle? style;

//   HyphenatedText(this.text, {super.key, this.style});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _HyphenatedTextPainter(text: text, style: style),
//       size: Size.infinite,
//     );
//   }
// }

// class _HyphenatedTextPainter extends CustomPainter {
//   final String text;
//   TextStyle? style = TextStyle();

//   _HyphenatedTextPainter({required this.text, this.style});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final TextPainter textPainter = TextPainter(
//       text: TextSpan(text: text, style: style),
//       maxLines: null,
//       textDirection: TextDirection.ltr,
//     );

//     textPainter.layout(maxWidth: size.width);

//     final List<String> lines = [];
//     String currentLine = '';
//     for (String word in text.split(' ')) {
//       if (currentLine.isNotEmpty) {
//         textPainter.text = TextSpan(text: '$currentLine $word', style: style);
//         textPainter.layout(maxWidth: size.width);
//         if (textPainter.didExceedMaxLines || textPainter.width > size.width) {
//           // Check if the last character of the current line is English
//           if (_isEnglish(currentLine[currentLine.length - 1])) {
//             lines.add('$currentLine-');
//             currentLine = word;
//           } else {
//             lines.add(currentLine);
//             currentLine = word;
//           }
//         } else {
//           currentLine += ' $word';
//         }
//       } else {
//         currentLine = word;
//       }
//     }
//     if (currentLine.isNotEmpty) {
//       lines.add(currentLine);
//     }

//     double y = 0.0;
//     for (String line in lines) {
//       textPainter.text = TextSpan(text: line, style: style);
//       textPainter.layout();
//       textPainter.paint(canvas, Offset(0, y));
//       y += textPainter.height;
//     }
//   }

//   bool _isEnglish(String char) {
//     return char.codeUnitAt(0) < 128;
//   }

//   @override
//   bool shouldRepaint(_HyphenatedTextPainter oldDelegate) {
//     return text != oldDelegate.text || style != oldDelegate.style;
//   }
// }
