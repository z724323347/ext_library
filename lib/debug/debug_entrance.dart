import 'package:flutter/material.dart';

import 'page/debug_log_entrance_page.dart';
import 'store/debug_log_ctrl.dart';

class DebugEntrance extends StatefulWidget {
  const DebugEntrance({Key? key}) : super(key: key);

  @override
  _DebugEntranceState createState() => _DebugEntranceState();
}

class _DebugEntranceState extends State<DebugEntrance> {
  late final DebugLogSer _debugLogEntranceStore;
  @override
  void initState() {
    super.initState();
    // logs('————初始化————App————：加载debug入口');
    _debugLogEntranceStore = DebugLogSer.to;
    _debugLogEntranceStore.loadStream(context);
  }

  @override
  void dispose() {
    super.dispose();
    _debugLogEntranceStore.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [OverlayEntry(builder: (_) => DebugLogEntrancePage())],
    );
  }
}
