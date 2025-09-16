
// ignore_for_file: unnecessary_null_comparison

/// 时间 datetime 扩展函数
extension LibDurationExt on Duration {
  /// 是否已经过期
  ///
  /// 已过期：true
  ///
  /// 未过期：false
  ///
  /// Duration > 0 未过期， Duration < 0 已过期
  bool get overdue {
    if (this == null) {
      return true;
    }
    if (this > Duration.zero) {
      return false;
    } else {
      return true;
    }
  }

  // String get hms {
  //   final int all = inSeconds;
  //   if (all < 0) {
  //     return '';
  //   }
  //   final int d = all ~/ (60 * 60 * 24);
  //   final int h = (all ~/ (60 * 60)) % 24;
  //   final int m = (all ~/ 60) % 60;
  //   final int s = all % 60;

  //   return '${(h < 10 && h > 0) ? '0$h' : '$h'}:${m < 10 ? '0$m' : '$m'}:${s < 10 ? '0$s' : '$s'}';
  // }

  /// 转换为（中文）  xx分xx秒
  String get msToZh {
    final int all = inSeconds;
    if (all < 0 || all == 0) {
      return '0 秒';
    }
    // final int d = all ~/ (24 * 60 * 60);
    // final int h = inHours ~/ 24;
    final int m = all ~/ 60;
    final int s = all % 60;
    // if (d > 0) {
    //   return '$d 天 ${h < 10 ? '0$m 小时' : '$m 小时'} ${m < 10 ? '0$m 分' : '$m 分'} ${s < 10 ? '0$s 秒' : '$s 秒'}';
    // }

    return '${m < 10 ? '0$m 分' : '$m 分'} ${s < 10 ? '0$s 秒' : '$s 秒'}';
  }

  /// Duration 转 毫秒
  String get msec {
    if (this == null) {
      return '0 ms';
    }
    String _str = '';
    final int all = inMilliseconds;
    final int s = all ~/ (60 * 1000);
    final int ms = all % (60 * 1000);

    try {
      _str = '${s * 1000 + ms} ms';
    } catch (e) {
      // logs(e);
    }
    return _str;
  }

  /// 分:秒.毫秒 00:00.000
  String get msMill {
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    String milliseconds = (inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$minutes:$seconds.$milliseconds';
  }

  /// 分:秒 00:00
  String get ms {
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// 时:分:秒 00:00:00
  String get hms {
    // devLogs('inHours $inHours');
    String hours = (inHours).toString().padLeft(2, '0');
    String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

///
/// ```
/// 200.ms // equivalent to Duration(milliseconds: 200)
/// 3.seconds // equivalent to Duration(milliseconds: 3000)
/// 1.5.days // equivalent to Duration(hours: 36)
/// ```
/// NumDurationExtensions
extension NumToDurationExt on num {
  /// num to Duration ->> 转微秒
  Duration get microseconds => Duration(microseconds: round());

  /// num to Duration ->> 转毫秒
  Duration get ms => (this * 1000).microseconds;

  /// num to Duration ->> 转毫秒
  Duration get milliseconds => (this * 1000).microseconds;

  ///  num to Duration ->> 转秒
  Duration get seconds => (this * 1000 * 1000).microseconds;

  /// num to Duration ->> 转分钟
  Duration get minutes => (this * 1000 * 1000 * 60).microseconds;

  /// num to Duration ->> 转小时
  Duration get hours => (this * 1000 * 1000 * 60 * 60).microseconds;

  /// num to Duration ->> 转天
  Duration get days => (this * 1000 * 1000 * 60 * 60 * 24).microseconds;
}
