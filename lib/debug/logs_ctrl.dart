import 'package:get/get.dart';
import '../tool/extensions/date_ext.dart';
import '../tool/extensions/string_ext.dart';

export 'debug_config.dart';

/// log日志 ctrl控制器
class DevLogsEventSer extends GetxService {
  /// Ctrl instance
  static DevLogsEventSer get to =>
      GetInstance().putOrFind(() => DevLogsEventSer());

  /// 是否开启
  final open = false.obs;

  final listLog = RxList<AppLogsEvent>([]);

  @override
  void onInit() {
    clearLog();
    setOpen(true);
    super.onInit();
  }

  void setOpen(bool status) {
    open.value = status;
  }

  void add(AppLogsEvent event) {
    if (!open.value) {
      return;
    }
    listLog.insert(0, event);
  }

  void clearLog() {
    listLog.clear();
  }
}

class AppLogsEvent {
  /// 类型
  int? type;

  /// 时间
  String? time;

  /// 信息
  String? msg;

  /// 文件
  String? file;

  /// 断点信息
  String? breakpoint;

  AppLogsEvent({this.type, this.time, this.msg, this.file, this.breakpoint});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'file': file,
      'breakpoint': breakpoint,
      'time': time!.dateTime.hmsDotSS,
      'msg': msg,
    }..removeWhere((k, v) => v == null);
  }
}
