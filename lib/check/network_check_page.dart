import 'dart:ui';

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'ctrl/network_check_ctrl.dart';
import 'widget/api_monitor.dart';
import 'widget/api_response_monitor.dart';
import 'widget/check_list_tile.dart';
import 'widget/web_load_monitor.dart';

class DevNetworkCheckPage extends StatefulWidget {
  const DevNetworkCheckPage({Key? key}) : super(key: key);

  @override
  _DevNetworkCheckPageState createState() => _DevNetworkCheckPageState();
}

class _DevNetworkCheckPageState extends State<DevNetworkCheckPage> {
  final _bodyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Get.put(NetworkCheckCtrl());
  }

  @override
  void dispose() {
    Get.delete<NetworkCheckCtrl>();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CommonAppBar(
      //   backgroundColor: Colors.black12.withOpacity(0.3),
      //   iconColor: Colors.black54,
      //   title: const Text(
      //     'App Check',
      //     style: TextStyle(
      //       color: Colors.black54,
      //       fontSize: 17,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   action: InkWell(
      //     onTap: () => _shareByPicture(context),
      //     child: const Icon(CupertinoIcons.share, color: Colors.black54),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: MediaQuery.of(context).viewPadding.copyWith(top: 0),
        child: RepaintBoundary(
          key: _bodyKey,
          child: DecoratedBox(
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // const CheckListTile(
                //   title: 'Device Info',
                //   child: DeviceMonitor(),
                // ),
                // const CheckListTile(
                //   title: 'Network Info',
                //   child: NetworkMonitor(),
                // ),
                // const CheckListTile(
                //   title: 'App info',
                //   child: AppMonitor(),
                // ),
                // const CheckListTile(
                //   title: 'User info',
                //   child: UserInfoMonitor(),
                // ),

                // const CheckListTile(
                //   title: 'Storage & Memory',
                //   child: MemoryMonitor(),
                // ),
                // const CheckListTile(
                //   title: 'User agent',
                //   child: UserAgentMonitor(),
                // ),
                const CheckListTile(
                  title: 'Web load speed',
                  child: WebLoadMonitor(),
                ),
                const CheckListTile(
                  title: 'Api info',
                  child: ApiMonitor(),
                ),
                const CheckListTile(
                  title: 'Api response speed',
                  child: ApiResponseMonitor(),
                ),
              ].divide(Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor,
              )),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _shareByPicture(BuildContext context) async {
    final boundary =
        _bodyKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }

    try {
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        return;
      }
      final pngBytes = byteData.buffer.asUint8List();
      // await ShareUtils.file(
      //     'Network Check', 'app_check.png', pngBytes, 'image/png');
    } catch (error, stackTrace) {
      devlLogU.i('share net information err', error, stackTrace);
    }
  }
}
