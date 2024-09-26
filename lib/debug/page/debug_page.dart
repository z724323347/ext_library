import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    '输出日志': const LogDebugPage(),
    'Http日志': const NetworkLogMainPage(),
  };
  @override
  void initState() {
    super.initState();
    if (widget.debugView != null && widget.debugView!.isNotEmpty) {
      tabBarInfos = widget.debugView!;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarInfos.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          title: const Text(
            'Debug',
            style: TextStyle(color: Colors.red, fontSize: 15),
          ),
          actions: [
            InkWell(
              onTap: () => DevLogsEventSer.to.clearLog(),
              child: Container(
                margin: 10.all,
                padding: 5.horizontal,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: 10.borderAll,
                ),
                alignment: Alignment.center,
                // child: const Icon(
                //   Icons.delete_forever_sharp,
                //   color: Colors.black,
                //   size: 24,
                // ),
                child: const Text(
                  '清除Logs',
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
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.red,
                indicatorColor: Colors.red,
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
