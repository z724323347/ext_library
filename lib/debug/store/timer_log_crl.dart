import 'dart:async';

import 'package:ext_library/lib_ext.dart';
import 'package:get/get.dart' hide GetNumUtils;

/// TimerDevLogCtrl service控制器
class TimerDevLogCtrl extends GetxService {
  /// GetxService instance
  static TimerDevLogCtrl get to => Get.find<TimerDevLogCtrl>();

  /// loading
  final RxBool loading = false.obs;

  final timerList = RxList<TimerEntity>([]);

  void add(TimerEntity entity) {
    // timerList.add(entity);
    timerList.insert(0, entity);
  }

  void clear() {
    timerList.clear();
  }

  String getTime(DateTime dateTime) {
    Timer.periodic(100.milliseconds, (timer) {
      dateTime.add(100.milliseconds);
    });
    return dateTime.hmsDotSS;
  }
}

class TimerEntity {
  String id;
  DateTime time;
  TimerType? type;
  String? node;

  TimerEntity({
    required this.id,
    required this.time,
    this.type,
    this.node,
  });
}

enum TimerType {
  /// 开始
  start,

  /// 结束
  end,

  /// 销毁
  dispose,
}
