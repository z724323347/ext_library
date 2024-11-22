import 'package:ext_library/tool/tool_lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ctrl/network_check_ctrl.dart';

class WebLoadMonitor extends StatelessWidget {
  const WebLoadMonitor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NetworkCheckCtrl>(builder: (controller) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SelectableText.rich(
              TextSpan(
                children: controller.webBenchmark.entries.map((entry) {
                  return _buildSpan(context, entry.key, entry.value);
                }).divide(const TextSpan(text: '\n')),
              ),
            ),
            const Icon(Icons.refresh, color: Colors.grey)
                .onInkWell(onTap: () => controller.testHttp())
                .positioned(right: 10),
          ],
        ),
      );
    });
  }

  TextSpan _buildSpan(BuildContext context, String url, Duration? time) {
    return TextSpan(
      text: url,
      children: [
        () {
          final String text;
          if (time == null) {
            text = '-';
          } else if (time == Duration.zero) {
            text = 'Timeout';
          } else {
            text = '${time.inMilliseconds} ms';
          }

          final TextStyle textStyle;
          if (time == null) {
            textStyle = const TextStyle(color: Colors.grey);
          } else if (time == Duration.zero) {
            textStyle = const TextStyle(color: Colors.red);
          } else if (time < const Duration(milliseconds: 400)) {
            textStyle = const TextStyle(color: Colors.green);
          } else {
            textStyle = const TextStyle(color: Colors.orange);
          }

          return TextSpan(
            text: '\u0020[$text]',
            style: textStyle.copyWith(fontSize: 13),
          );
        }(),
      ],
    );
  }
}
