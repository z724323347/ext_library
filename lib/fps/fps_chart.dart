import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fps_info.dart';
import 'fps_storage.dart';

class BarChartPainter extends CustomPainter {
  List<FpsInfo> datas;

  BarChartPainter({required this.datas});

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BarChartPainter oldDelegate) => false;

  void _drawAxis(Canvas canvas, Size size) {
    final double sw = size.width;
    final double sh = size.height;

    // 使用 Paint 定义路径的样式
    final Paint paint = Paint()
      ..color = const Color(0xffdddddd)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // 使用 Path 定义绘制的路径，从画布的左上角到左下角在到右下角
    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, sh)
      ..lineTo(sw, sh);

    // 使用 drawPath 方法绘制路径
    canvas.drawPath(path, paint);
  }

  void _drawLabels(Canvas canvas, Size size) {
    double labelFontSize = 10.0;
    final double sh = size.height;
    final List<double> yAxisLabels = [];

    yAxisLabels.add(16);
    yAxisLabels.add(33);
    yAxisLabels.add(66);
    yAxisLabels.add(100);

    yAxisLabels.asMap().forEach(
      (index, label) {
        // 标识的高度为画布高度减去标识的值
        final double top = sh - label * 2.5;
        // final rect = Rect.fromLTWH(0, top, 4, 1);
        final Offset textOffset = Offset(
          0 - (label.toInt().toString().length == 3 ? 24 : 20).toDouble(),
          top - labelFontSize / 2,
        );

        // 绘制文字需要用 `TextPainter`，最后调用 paint 方法绘制文字
        TextPainter(
          text: TextSpan(
            text: label.toStringAsFixed(0),
            style: TextStyle(
                fontSize: labelFontSize, color: const Color(0xff4a4b5b)),
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.ltr,
          textWidthBasis: TextWidthBasis.longestLine,
        )
          ..layout(minWidth: 0, maxWidth: 24)
          ..paint(canvas, textOffset);
      },
    );
  }

  void _drawBars(Canvas canvas, Size size) {
    final sh = size.height;
    final paint = Paint()..style = PaintingStyle.fill;
    const double marginLeft = 7.5;
    final double _barWidth = size.width / FpsStorage.instance!.maxCount;
    const double _barGap = 0;
    int A = 0;
    int B = 0;
    int C = 0;
    int D = 0;

    for (int i = 0; i < datas.length; i++) {
      final int value = datas[i].getValue()!.toInt();

      if (value > 66) {
        D++;
      } else if (value > 33) {
        C++;
      } else if (value > 18) {
        B++;
      } else {
        A++;
      }
      paint.color = value <= 18
          ? const Color(0xff55a8fd)
          : value <= 33
              ? const Color(0xfffad337)
              : value <= 66
                  ? const Color(0xFFF48FB1)
                  : const Color(0xFFD32F2F);
      // 矩形的上边缘为画布高度减去数据值
      final double top = sh - value * 2.5;
      // 矩形的左边缘为当前索引值乘以矩形宽度加上矩形之间的间距
      final double left = marginLeft + i * _barWidth + (i * _barGap) + _barGap;

      // 使用 Rect.fromLTWH 方法创建要绘制的矩形
      final rect = Rect.fromLTWH(left, top, _barWidth, value * 2.5.toDouble());
      // 使用 drawRect 方法绘制矩形
      canvas.drawRect(rect, paint);
    }
    TextPainter(
      text: TextSpan(
        text: '流畅：$A 良好：$B 轻微卡顿：$C 卡顿：$D',
        style: const TextStyle(fontSize: 10, color: Color(0xff4a4b5b)),
      ),
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    )
      ..layout()
      ..paint(canvas, Offset.zero);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawAxis(canvas, size);
    _drawLabels(canvas, size);
    _drawBars(canvas, size);
  }
}

class FpsBarChart extends StatefulWidget {
  final List<FpsInfo> data;

  const FpsBarChart({
    required this.data,
  });

  @override
  _FpsBarChartState createState() => _FpsBarChartState();
}

class _FpsBarChartState extends State<FpsBarChart>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final double width =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width - 56
            : MediaQuery.of(context).size.width - 30;
    final double height =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height - 500
            : MediaQuery.of(context).size.height - 200;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 40, left: 24),
          child: CustomPaint(
            painter: BarChartPainter(datas: widget.data),
            child: SizedBox(
              width: width,
              height: height,
            ),
          ),
        )
      ],
    );
  }
}
