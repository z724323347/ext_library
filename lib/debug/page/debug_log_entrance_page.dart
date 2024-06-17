import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logs_ctrl.dart';
import '../store/debug_log_ctrl.dart';

///
/// 调试入口
///
class DebugLogEntrancePage extends StatefulWidget {
  DebugLogEntrancePage({super.key});

  final DebugLogSer store = DebugLogSer.to;

  @override
  _DebugLogEntrancePageState createState() => _DebugLogEntrancePageState();
}

class _DebugLogEntrancePageState extends State<DebugLogEntrancePage>
    with SingleTickerProviderStateMixin {
  double left = 0;
  double top = 200;
  bool showSource = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: 50,
        height: 50,
        child: Draggable(
          feedback: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {},
            child: const Icon(
              Icons.bug_report_rounded,
              color: Colors.white,
            ),
          ),
          onDragStarted: () {
            showSource = false;
          },
          onDragEnd: (DraggableDetails details) {
            setState(() {
              left = details.offset.dx;
              top = details.offset.dy;
              showSource = true;
            });
          },
          child: Visibility(
            visible: showSource,
            child: Opacity(
              opacity: 0.5,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: _showDialog,
                child: const Icon(
                  Icons.bug_report_rounded,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<T?> _showDialog<T>() {
    // return AppDialog.dialog<T>(_DebugDisplayDialog());
    return Future.value();
  }
}

class _DebugDisplayDialog extends StatelessWidget {
  _DebugDisplayDialog();

  final DebugLogSer store = DebugLogSer.to;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          constraints: const BoxConstraints(
            minWidth: 200,
            minHeight: 80,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DebugEntranceButton(
                text: '功能调试',
                onTap: () {
                  // AppRoutes.offNamed(CommRouter.testPgae);
                },
              ),
              Obx(
                () => _DebugEntranceSwitch(
                  text: '网络请求log',
                  onChanged: (_) => store.toggle(context),
                  select: store.openLog.value,
                ),
              ),
              Obx(
                () => _DebugEntranceSwitch(
                  text: 'FPS 监测',
                  onChanged: (_) => store.toFps(context),
                  select: store.openFps.value,
                ),
              ),
              Obx(
                () => _DebugEntranceSwitch(
                  text: 'Logs print(日志输出)',
                  onChanged: (_) => DevLogsEventSer.to.setOpen(_),
                  select: DevLogsEventSer.to.open.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// FPS 开关入口
class _FpsEntranceSwitch extends StatelessWidget {
  const _FpsEntranceSwitch({
    required this.select,
    this.onChanged,
  });
  final bool select;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 300,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FPS',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Switch(
            value: select,
            onChanged: onChanged,
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

///debug开关入口
class _DebugEntranceSwitch extends StatelessWidget {
  const _DebugEntranceSwitch({
    super.key,
    required this.text,
    required this.select,
    this.onChanged,
  });

  final String text;
  final bool select;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 300,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(color: Colors.green)),
          const Spacer(),
          Switch(
            value: select,
            onChanged: onChanged,
            activeColor: Colors.red,
          ),
        ],
      ),
    );
  }
}

/// debug按钮入口
class _DebugEntranceButton extends StatelessWidget {
  const _DebugEntranceButton({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 300,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.green),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
