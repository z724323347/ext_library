import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:washine/app/views/custom_app_bar.dart';

import '../logs_ctrl.dart';
import 'log_debug_page.dart';
import 'network_log_host.dart';
import 'network_log_main.dart';

class DebugPage extends StatefulWidget {
  Map<String, StatefulWidget>? debugView;
  DebugPage({Key? key, this.debugView}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Map<String, StatefulWidget> tabBarInfos = {
    '通用设置': NetworkLogHostPage(),
    '域名设置': NetworkLogHostPage(),
    '输出日志': LogDebugPage(),
    'Http日志': NetworkLogMainPage(),
  };
  @override
  void initState() {
    super.initState();
    if (widget.debugView != null && widget.debugView!.isNotEmpty) {
      tabBarInfos = widget.debugView!;
    }
    setState(() { });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarInfos.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Debug',
          actions: [
            InkWell(
              onTap: () => DevLogsEventSer.to.clearLog(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                color: Colors.red,
                alignment: Alignment.center,
                child: const Text(
                  '清除日志',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 40,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: TabBar(
                isScrollable: true,
                tabs: tabBarInfos.keys.map((e) => Tab(text: e)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: tabBarInfos.values.toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
