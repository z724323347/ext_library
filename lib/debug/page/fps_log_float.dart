import 'dart:async';
import 'dart:math';

import 'package:ext_library/fps/fps_info.dart';
import 'package:ext_library/fps/fps_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../store/debug_log_ctrl.dart';

class FpsLogFloat extends StatefulWidget {
  const FpsLogFloat({Key? key}) : super(key: key);

  @override
  State<FpsLogFloat> createState() => _FpsLogFloatState();
}

class _FpsLogFloatState extends State<FpsLogFloat> {
  double left = 50;
  double top = 50;
  double startX = 0;
  double startY = 0;

  late Function(List<FrameTiming>) monitor;
  late Timer _timer;
  List<FpsInfo> fpsList = [];

  DebugLogSer get store => DebugLogSer.to;

  @override
  void initState() {
    super.initState();
    monitor = (timings) {
      double duration = 0;
      for (final element in timings) {
        final FrameTiming frameTiming = element;
        duration = frameTiming.totalSpan.inMilliseconds.toDouble();
        final FpsInfo fpsInfo = FpsInfo();
        fpsInfo.totalSpan = max(16.7, duration);
        if (fpsInfo.getValue() != null && fpsInfo.getValue() != 0) {
          fpsInfo.fps = 1000 / fpsInfo.totalSpan!;
        }
        FpsStorage.instance!.save(fpsInfo);
      }
    };

    start();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      fpsList = FpsStorage.instance!.getAll();
      setState(() {});
    });
  }

  void start() {
    WidgetsBinding.instance.addTimingsCallback(monitor);
  }

  void stop() {
    WidgetsBinding.instance.removeTimingsCallback(monitor);
    FpsStorage.instance!.clear();
  }

  @override
  void dispose() {
    _timer.cancel();
    stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          width: 80,
          height: 30,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            // color: Colors.blue.withOpacity(0.6),
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: _buildFps(),
        ),
      ),
    );
  }

  Widget _buildFps() {
    String fps = '--';
    String avgFps = '--';
    Color color = Colors.white;
    if (fpsList.isNotEmpty) {
      final FpsInfo info = fpsList.last;
      fps = info.fps!.toStringAsFixed(2);
      final int value = info.getValue()!.toInt();
      color = value <= 18
          ? Colors.green
          : value <= 33
              ? const Color(0xfffad337)
              : value <= 66
                  ? const Color(0xFFF48FB1)
                  : const Color(0xFFD32F2F);
      double sum = 0.0;
      for (final item in fpsList) {
        if (item.fps is num) {
          sum += item.fps!;
        }
      }
      avgFps = (sum / fpsList.length).toStringAsFixed(2);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (DragDownDetails details) {
        startX = details.localPosition.dx;
        startY = details.localPosition.dy;
      },
      // onTap: () => AppRoutes.to(const FpsObserverWidget()),
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          final double dx = details.globalPosition.dx;
          final double dy = details.globalPosition.dy;
          left = dx - startX;
          top = dy - startY;
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200.withOpacity(.2),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FPS：   $fps',
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
            Text(
              'Avg：   $avgFps',
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
