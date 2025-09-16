// ignore_for_file: unnecessary_null_comparison

import 'dart:ui';
import 'duration_ext.dart';
import 'package:intl/intl.dart';

/// APP  DateTime 转换
class LibDateFormat {
  static final DateFormat full = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  static final DateFormat regular = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat regularDot = DateFormat('yyyy.MM.dd HH:mm:ss');
  static final DateFormat yrMonDayHrMin = DateFormat('yyyy-MM-dd HH:mm');
  static final DateFormat yrMonDay = DateFormat('yyyy-MM-dd');
  static final DateFormat yrMon = DateFormat('yyyy-MM');
  static final DateFormat monDayHrMin = DateFormat('MM-dd HH:mm');
  static final DateFormat monDayHrMinSec = DateFormat('MM-dd HH:mm:ss');
  static final DateFormat monDay = DateFormat('MM-dd');
  static final DateFormat hrMinSec = DateFormat('HH:mm:ss');
  static final DateFormat hrMin = DateFormat('HH:mm');
  static final DateFormat hh = DateFormat('HH');
  static final DateFormat hmsDotSS = DateFormat('HH:mm:ss.SSS');

  static final DateFormat msDotSS = DateFormat('mm:ss.SSS');
  static final DateFormat eMDY = DateFormat('E, MM/dd/yyyy');

  static final DateFormat anglicism = DateFormat('MMM dd, yyyy');

  static final DateFormat eYear = DateFormat('yyyy');
  static final DateFormat eMonth = DateFormat('MMM');
  static final DateFormat eDay = DateFormat('dd');
}

extension LibNullDate on DateTime? {
  /// 'yyyy-MM-dd'
  String get ymd {
    if (this == null || this?.microsecondsSinceEpoch == 0) {
      return '';
    }

    return LibDateFormat.yrMonDay.format(this!);
  }
}

/// 时间 datetime 扩展函数
extension LibDate on DateTime {
  /// ms millisecondsSinceEpoch (毫秒时间戳)
  int get msSinceEpoch => millisecondsSinceEpoch;

  /// mic microsecondsSinceEpoch (微秒时间戳)
  int get micSinceEpoch => microsecondsSinceEpoch;

  /// 是否已经过期(对比系统时间)
  ///
  /// dateTime > sysTime, 已过期 return  true
  ///
  ///
  /// dateTime < sysTime, 未过期 return  false
  ///
  ///
  /// Duration > 0 未过期， Duration < 0 已过期
  ///
  bool get overdue {
    if (this == null || microsecondsSinceEpoch == 0) {
      return true;
    }
    return difference(nowTime).overdue;
  }

  /// 当前时间
  DateTime get nowTime => DateTime.now();

  /// 自定义格式化  eg format: yyyy-MM-dd HH:mm:ss
  String custom(String? format) {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    if (format == null) {
      return regular;
    }
    try {
      return DateFormat('$format').format(this);
    } catch (e) {
      return '';
    }
  }

  /// 'HH'
  String get hh {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.hh.format(this);
  }

  /// 'HH:mm:ss'
  String get hms {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.hrMinSec.format(this);
  }

  /// 'mm:ss.SSS'
  String get msDotSS {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.msDotSS.format(this);
  }

  /// 'HH:mm:ss.SSS'
  String get hmsDotSS {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.hmsDotSS.format(this);
  }

  /// 'MM-dd'
  String get md {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.monDay.format(this);
  }

  /// 'MM-dd HH:mm'
  String get mdhm {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.monDayHrMin.format(this);
  }

  /// 'MM-dd HH:mm:ss'
  String get mdhms {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.monDayHrMinSec.format(this);
  }

  /// 'yyyy-MM-dd'
  String get ymd {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }

    return LibDateFormat.yrMonDay.format(this);
  }

  /// 'yyyy-MM-dd HH:mm'
  String get ymdhm {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.yrMonDayHrMin.format(this);
  }

  /// 'yyyy-MM-dd HH:mm:ss'
  String get regular {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.regular.format(this);
  }

  /// 'yyyy-MM-dd HH:mm:ss.SSS'
  String get full {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.full.format(this);
  }

  /// 'E, MM/dd/yyyy'  eg: Thu,12/14/2023
  String get printDate {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.eMDY.format(this);
  }

  /// 'MMM dd, yyyy'  eg: Thu 21,2023
  String get anglicism {
    if (this == null || microsecondsSinceEpoch == 0) {
      return '';
    }
    return LibDateFormat.anglicism.format(this);
  }

  bool get isAfterNow {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return dateTime.isAfter(nowTime);
  }
}

class LibDateUtil {
  static String formatTimestamp(
    int milliseconds, {
    DateFormat? format,
    bool isUtc = false,
  }) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    format ??= LibDateFormat.regular;

    return formatDateTime(dateTime, format: format);
  }

  static String? formatDateStr(
    String dateStr, {
    DateFormat? format,
  }) {
    final DateTime? dateTime = DateTime.tryParse(dateStr);
    if (dateTime == null) {
      return null;
    }

    return formatDateTime(dateTime, format: format);
  }

  static String formatDateTime(
    DateTime dateTime, {
    DateFormat? format,
  }) {
    format ??= LibDateFormat.regular;
    return format.format(dateTime);
  }

  /// Return whether it is leap year.
  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }

  static bool? isChildBirth(String birthday) {
    // 当前时间
    final DateTime now = DateTime.now();
    // 18年前的今天
    final DateTime yearsAgo18 = DateTime(now.year - 18, now.month, now.day);
    // 出生年月 转 date
    final DateTime? birthDate = DateTime.tryParse(birthday);

    return birthDate?.isAfter(yearsAgo18);
  }

  static bool isAfterNow(int millisecondsSinceEpoch) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final DateTime now = DateTime.now();
    return dateTime.isAfter(now);
  }

  /// 支持多语言的日期格式
  ///
  /// Example:
  ///
  /// in zh - 2021年10月27日 17:23:01 星期三
  /// in en - October 27, 2021 17:23:01 Wednesday
  static String formatIntl(
    DateTime dateTime, {
    Locale? locale,
  }) {
    final String formatYmd =
        DateFormat.yMMMMd(locale?.languageCode).format(dateTime);
    final String formatHms =
        DateFormat.Hm(locale?.languageCode).format(dateTime);
    final String formatWd =
        DateFormat('EEEE', locale?.languageCode).format(dateTime);

    return '$formatYmd $formatHms $formatWd';
  }
}
