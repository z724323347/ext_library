import 'dart:async';

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide GetNumUtils;

class TimerLogFloat extends StatefulWidget {
  const TimerLogFloat({Key? key}) : super(key: key);

  @override
  _TimerLogFloatState createState() => _TimerLogFloatState();
}

class _TimerLogFloatState extends State<TimerLogFloat> {
  double left = 20;
  double top = 100;
  double startX = 0;
  double startY = 0;

  DebugLogSer get store => DebugLogSer.to;

  final ctrl = TimerDevLogCtrl.to;

  @override
  void dispose() {
    ctrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Material(
        type: MaterialType.transparency,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (DragDownDetails details) {
            startX = details.localPosition.dx;
            startY = details.localPosition.dy;
          },
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
            width: 300,
            height: 280,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            // child: buildBody(),
            child: Column(
              children: [
                _buildTitleBar(),
                Expanded(child: buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    // return Obx(
    //   () => ListView(
    //     padding: 5.horizontal,
    //     children: ctrl.timerList.map((item) {
    //       return TimerItemView(
    //         entity: item,
    //         key: Key(item.time.hmsDotSS),
    //       );
    //     }).toList(),
    //   ),
    // );

    return Obx(
      () => ListView.builder(
        padding: 5.all,
        itemCount: ctrl.timerList.length,
        itemBuilder: (_, index) {
          final item = ctrl.timerList[index];
          Duration duration = Duration.zero;
          if (index > 0) {
            duration = ctrl.timerList[index - 1].time
                .difference(ctrl.timerList[index].time);
          }

          if (item.node.isnull) {
            ctrl.timerList[index].time;
          }
          return TimerItemView(
            entity: item,
            duration: duration,
            key: Key(item.time.hmsDotSS),
          );
        },
      ),
    );
  }

  ///工具栏
  Widget _buildTitleBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (DragDownDetails details) {
                startX = details.localPosition.dx;
                startY = details.localPosition.dy;
              },
              onPanUpdate: (DragUpdateDetails details) {
                setState(() {
                  final double dx = details.globalPosition.dx;
                  final double dy = details.globalPosition.dy;
                  left = dx - startX;
                  top = dy - startY;
                });
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  'Timer  Logs',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => ctrl.clear(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              store.toTimer(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimerItemView extends StatefulWidget {
  final TimerEntity entity;
  final Duration? duration;
  const TimerItemView({super.key, required this.entity, this.duration});

  @override
  State<TimerItemView> createState() => _TimerItemViewState();
}

class _TimerItemViewState extends State<TimerItemView> {
  Timer? _timer;

  Duration currTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer ??= Timer.periodic(100.milliseconds, (timer) {
      currTime = DateTime.now().difference(widget.entity.time);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            currTime.hmsMill,
            style: const TextStyle(
              color: Colors.green,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          widget.entity.time.msDotSS,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
          maxLines: 1,
        ).pOnly(right: 10).visible(!widget.entity.node.isnull),
        Text(
          widget.entity.id.safety,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          maxLines: 1,
        ),
        Container(
          width: 60,
          alignment: Alignment.centerRight,
          child: Text(
            ' ${widget.duration?.msec} ',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
