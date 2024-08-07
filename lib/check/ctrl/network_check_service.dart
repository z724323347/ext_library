import 'dart:async';

import 'package:get/get.dart';

class NetworkCheckService extends GetxService {
  // 最多保存10条记录
  static const _keepRecordLimit = 10;

  static NetworkCheckService get to =>
      GetInstance().putOrFind(() => NetworkCheckService());

  final httpTimeList = RxList<Duration>();
  final cdnTimeList = RxMap<String, Duration?>();
  late final StreamSubscription<List<Duration>> httpTimeSubscription;

  Duration? get averageHttpTime {
    if (httpTimeList.isEmpty) {
      return null;
    }
    return httpTimeList.reduce((previousValue, element) {
      return (previousValue + element) ~/ 2;
    });
  }

  @override
  void onInit() {
    super.onInit();

    httpTimeSubscription = httpTimeList.listen((event) {
      final removeCount = event.length - _keepRecordLimit;
      if (removeCount > 0) {
        event.removeRange(0, removeCount);
      }
      // TODO: 若平均用时过长，可认为是网络不稳定，做一些处理...
    });
  }

  @override
  void onClose() {
    httpTimeSubscription.cancel();

    super.onClose();
  }
}
