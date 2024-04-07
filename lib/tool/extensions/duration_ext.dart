/// 时间 datetime 扩展函数
extension AppDuration on Duration {
  String get hms {
    final int all = inSeconds;
    if (all < 0) {
      return '';
    }
    final int d = all ~/ (60 * 60 * 24);
    final int h = (all ~/ (60 * 60)) % 24;
    final int m = (all ~/ 60) % 60;
    final int s = all % 60;

    return '${(h < 10 && h > 0) ? '0$h' : '$h'}:${m < 10 ? '0$m' : '$m'}:${s < 10 ? '0$s' : '$s'}';
  }

  /// 转换为（中文）  xx分xx秒
  String get ms {
    final int all = inSeconds;
    if (all < 0 || all == 0) {
      return '0 秒';
    }
    final int m = all ~/ 60;
    final int s = all % 60;

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
