// ignore_for_file: strict_raw_type, cascade_invocations

import 'dart:ui';

import 'package:flutter/material.dart';

import 'fps_page.dart';
import 'fps_storage.dart';

class FpsObserverWidget extends StatefulWidget {
  const FpsObserverWidget({Key? key}) : super(key: key);

  @override
  _FpsObserverWidgetState createState() => _FpsObserverWidgetState();
}

class _FpsObserverWidgetState extends State<FpsObserverWidget> {
  late Function(List<FrameTiming>) monitor;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  void start() {
    WidgetsBinding.instance.addTimingsCallback(monitor);
  }

  void stop() {
    WidgetsBinding.instance.removeTimingsCallback(monitor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
            onTap: () {
              start();
            },
            child: Container(
              color: const Color(0x33999999),
            ),
          )),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                FpsPage(),
                const Divider(),
                Container(
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    child: const Text(
                      '停止监听',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      stop();
                      FpsStorage.instance!.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0x33999999),
    );
  }
}
