import 'package:flutter/material.dart';
import 'fps_chart.dart';
import 'fps_info.dart';
import 'fps_storage.dart';

class FpsPage extends StatefulWidget {
  const FpsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return FpsPageState();
  }
}

class FpsPageState extends State<FpsPage> {
  @override
  Widget build(BuildContext context) {
    List<FpsInfo> list = FpsStorage.instance!.getAll();
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
              height: 44,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  info('近${FpsStorage.instance!.items.length}帧'),
                  info('最大耗时:${FpsStorage.instance!.max!.toStringAsFixed(1)}'),
                  info(
                      '平均耗时:${FpsStorage.instance!.getAvg().toStringAsFixed(1)}'),
                  info(
                      '总耗时:${FpsStorage.instance!.totalNum.toStringAsFixed(1)}')
                ],
              )),
          const Divider(
            height: 0.5,
            color: Color(0xffdddddd),
            indent: 16,
            endIndent: 16,
          ),
          FpsBarChart(data: list)
        ],
      ),
    );
  }

  Widget info(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 9),
    );
  }
}
