import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ctrl/network_check_ctrl.dart';
import '../ctrl/network_check_service.dart';

class ApiResponseMonitor extends StatelessWidget {
  static const Color _okColor = Colors.green;
  static const Color _warnColor = Colors.orange;
  static const Color _errorColor = Colors.red;

  const ApiResponseMonitor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<NetworkCheckCtrl>(builder: (controller) {
      final httpBenchmark = controller.httpBenchmark.value;
      final wsBenchmark = controller.wsBenchmark.value;

      final children = [
        _buildDelayTimeTextSpan(
          context,
          'Average time spent on api',
          NetworkCheckService.to.averageHttpTime,
        ),
        const TextSpan(text: '\n'),
        const TextSpan(text: 'Test Api...\n'),
        _buildDelayTimeTextSpan(
          context,
          'Connection Duration',
          httpBenchmark.connectionDuration,
        ),
        _buildDelayTimeTextSpan(
          context,
          'Network Duration',
          httpBenchmark.networkDuration,
        ),
        TextSpan(
          text: 'Total Bytes:\u0020${httpBenchmark.totalBytes} bytes\n',
        ),
        _buildDelayTimeTextSpan(
          context,
          'Decoding Duration',
          httpBenchmark.decodingDuration,
        ),
        if (httpBenchmark.error != null)
          TextSpan(
            text: '${httpBenchmark.error}\nerr~',
            style: const TextStyle(color: _errorColor),
          ),
        const TextSpan(text: '\n'),
        _buildDelayTimeTextSpan(
          context,
          'Response Time',
          wsBenchmark.networkDuration,
        ),
        if (wsBenchmark.error != null)
          TextSpan(
            text: '${wsBenchmark.error}\nerr~',
            style: const TextStyle(color: _errorColor),
          ),
      ];

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(TextSpan(children: children)),
          _buildRefreshButton(context),
        ],
      );
    });
  }

  TextSpan _buildDelayTimeTextSpan(
    BuildContext context,
    String title,
    Duration? delayTime,
  ) {
    Color? timeColor;
    if (delayTime != null) {
      timeColor =
          delayTime > const Duration(milliseconds: 200) ? _warnColor : _okColor;
    }

    return TextSpan(
      text: '$title:\u0020',
      children: [
        TextSpan(
          text: '${delayTime?.inMilliseconds ?? '-'} ms\n',
          style: TextStyle(color: timeColor),
        ),
      ],
    );
  }

  Widget _buildRefreshButton(BuildContext context) {
    return GetX<NetworkCheckCtrl>(builder: (controller) {
      final isCompleted = controller.httpBenchmark.value.isCompleted &&
          controller.wsBenchmark.value.isCompleted;

      return CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 30,
        onPressed: isCompleted
            ? () {
                controller.testHttp().whenComplete(controller.testHttp);
              }
            : null,
        child: Wrap(
          spacing: 8,
          children: [
            const Text(
              'Refresh',
              style: TextStyle(fontSize: 14),
            ),
            Visibility(
              visible: !isCompleted,
              child: const CupertinoActivityIndicator(),
            ),
          ],
        ),
      );
    });
  }
}
