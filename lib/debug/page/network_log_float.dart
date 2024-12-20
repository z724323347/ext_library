import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../store/debug_log_ctrl.dart';
import 'network_log_main.dart';

class NetWorkLogFloat extends StatefulWidget {
  const NetWorkLogFloat({Key? key}) : super(key: key);

  @override
  _NetWorkLogFloatState createState() => _NetWorkLogFloatState();
}

class _NetWorkLogFloatState extends State<NetWorkLogFloat> {
  double left = 20;
  double top = 100;
  double startX = 0;
  double startY = 0;

  DebugLogSer get store => DebugLogSer.to;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          width: 300,
          height: 220,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(5, 5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTitleBar(),
              const Expanded(child: NetworkLogMainPage()),
            ],
          ),
        ),
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
              child: Obx(
                () => Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '请求日志   ( ${store.listLog.length} )',
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          const InkWell(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_drop_down_sharp,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              store.clearLog();
            },
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
              store.toggle(context);
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
