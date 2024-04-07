import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import './num_ext.dart';

extension StringExtNull on String? {
  /// 字符是否为空
  bool get isnull {
    if (this == null || this!.isEmpty || this?.toLowerCase() == 'null') {
      return true;
    }
    return false;
  }

  /// 字符空安全
  String get safety {
    if (isnull) {
      return '';
    }
    return '$this';
  }

  /// 去除空格
  String get trim => toString().trim();
}

/// String 扩展函数
extension StringExt on String {
  static final RegExp pascalPattern = RegExp(r'[^0-9a-zA-Z]');
  static final RegExp snakePattern = RegExp(r'[^0-9a-z]');

  /// 字符是否为空
  bool get isnull {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return true;
    }
    return false;
  }

  /// 字符空安全
  String get safety {
    if (isnull) {
      return '';
    }
    return this;
  }

  // /// 换行符与空字符
  // String get trimBreak {
  //   if (isnull) {
  //     return '';
  //   }
  //   return this.trim().replaceAll(RegExp(r'\s'), '');
  // }

  /// 去除空格
  String get trim => toString().trim();

  /// string 转 double
  double get toDouble {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return 0.0;
    }
    try {
      return double.parse(this);
    } catch (e) {
      debugPrint(e.toString());
      return 0.0;
    }
  }

  /// string 转 int
  int get toInt {
    if (this == null || length == 0 || isEmpty || toLowerCase() == 'null') {
      return 0;
    }
    try {
      return decimal.toDouble().toInt();
      // return int.parse(this);
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  // /// string 转 jsonDecode
  // dynamic get jsDecode {
  //   if (this == null) {
  //     return null;
  //   }
  //   return json.decode(this);
  // }

  /// 防止文字自动换行
  String get fixLines {
    if (isnull) {
      return '';
    }
    return Characters(this).join('\u{200B}');
  }

  /// 文本最大长度 / 截取文本长度
  ///
  /// length 最大长度
  ///
  /// withDot 是否带有省略符...
  String fixLength([int length = 10, bool withDot = true]) {
    if (isnull) {
      return '';
    }
    if (this.length < length) {
      return this;
    }
    if (withDot) {
      return '${substring(0, length)}...';
    } else {
      return substring(0, length);
    }
  }

  /// 首字母大写
  String get capitalToFirst {
    if (isEmpty || length < 2) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  ///转大写
  String get toUpper {
    if (isnull) {
      return safety;
    }
    return toUpperCase();
  }

  /// 转小写
  String get toLower {
    if (isnull) {
      return safety;
    }
    return toLowerCase();
  }

  /// 驼峰
  String get toPascalName {
    final List<String> parts = split(pascalPattern);
    for (int i = 0; i < parts.length; i++) {
      if (i == 0) {
        continue;
      }
      parts[i] = parts[i].capitalToFirst;
    }

    return parts.join();
  }

  /// 蛇形
  String get toSnakeName {
    return splitMapJoin(snakePattern, onMatch: (Match match) {
      final String? matchText = match.group(0);
      if (match.start > 0) {
        return '_$matchText';
      }
      return matchText ?? '';
    }).toLowerCase();
  }

  // /// 抹除开头的0
  // String get stripLeadingZeros {
  //   final RegExp pattern = RegExp(r'^0+');
  //   return replaceAll(pattern, '');
  // }

  /// 抹除末尾的0
  // String get stripTrailingZeros {
  //   if (!contains('.')) {
  //     return this;
  //   }
  //   final String trimmed = replaceAll(RegExp(r'0*$'), '');
  //   if (trimmed.endsWith('.')) {
  //     return trimmed.substring(0, trimmed.length - 1);
  //   }

  //   return trimmed;
  // }

  DateTime get dateTime {
    if (isnull) {
      return DateTime.now();
    }
    final reg = RegExp(r'^\d+$');
    if (reg.hasMatch(toString())) {
      try {
        return toInt.dateTime;
      } catch (e) {
        return DateTime.now();
      }
    }
    try {
      return DateTime.parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// string 类型转 Decimal
  Decimal get decimal {
    if (isnull) {
      return Decimal.zero;
    }
    if (this is int) {
      return Decimal.fromInt(this as int);
    }
    if (contains(',')) {
      return Decimal.parse(replaceAll(',', ''));
    } else {
      return Decimal.parse(this);
    }
  }

  // /// 去掉小数部分
  // String get removeDecimal {
  //   String _str = this;
  //   if (contains('.')) {
  //     _str = split('.')[0];
  //   }
  //   return _str;
  // }

  /// 格式化 自定义整数千分位
  String thousandsCustom({String format = '#,###'}) {
    final _format = NumberFormat(format, 'en_US');
    if (this == null) {
      return '0';
    }

    final number = decimal;
    if (number == Decimal.zero) {
      return _format.format(number.toDouble());
    }
    return _format.format(number.toDouble());
  }

  /// 格式化 千分位
  String get _thousands {
    final format = NumberFormat('#,##0.00####', 'en_US');
    if (this == null) {
      return '0.00';
    }

    final number = Decimal.parse(this);
    if (number == Decimal.zero) {
      return '0.00';
    }
    return format.format(double.parse(this));
  }

  /// 千分位 格式化 (digits 位数)
  String thousandsDigits({int digits = 2}) {
    if (digits.isnull || digits < 0) {
      return thousandsCustom();
    }
    String _append0 = '';
    for (var i = 0; i < digits; i++) {
      _append0 = _append0.add('0');
    }
    String _format = '#,##0.'.add(_append0);
    return thousandsCustom(format: _format);
  }

  /// 获取小数位数
  int get digits {
    if (isnull || !contains('.')) {
      return 0;
    }
    List<String> result = split('.');
    return result.last.length;
  }

  /// string 追加字段
  String add(String text) {
    if (isnull) {
      return text;
    }
    return this + text;
  }

  // /// string 添加指定后缀 (default ： @lifpay.me)
  // String suffix([String? text]) {
  //   String? result = text;
  //   if (isnull) {
  //     return result.safety;
  //   }
  //   return add(result.safety);
  // }

  /// string 移除对应的字段
  String remove(String text) {
    if (this == null) {
      return '';
    }
    if (contains(text)) {
      return replaceAll(text, '');
    }
    return '';
  }

  /// 中间脱敏 -(信息脱敏等)
  String desensyMiddle([int digit = 12]) {
    if (isnull) {
      return '';
    }
    if (length < digit) {
      return this;
    } else {
      return '${substring(0, digit)}....${substring(length - digit, length)}';
    }
  }

  /// 尾部脱敏 -(信息脱敏等)
  String desensyEnd([int digit = 12]) {
    if (isnull) {
      return '';
    }
    if (length <= digit) {
      return this;
    } else {
      return '${substring(0, digit)}..';
    }
  }

  // substring截取多少位 【默认 7
  String subStr([int digit = 7]) {
    if (this == null || isEmpty) {
      return '';
    }
    if (length < digit) {
      return this;
    } else {
      return substring(0, digit);
    }
  }

  /// 通过 (uri/url) 获取uri参数
  Map<String, dynamic> get uriParam {
    return Uri.parse(safety).queryParameters;
  }

  /// 通过 (uri/url) 获取host uri
  String get uriPath {
    String nUrl = '';
    final int paramsIndex = indexOf('?');
    nUrl = paramsIndex > -1 ? (substring(0, paramsIndex)) : this;
    return nUrl;
  }

  /// 获取文件名 和 文件后缀
  ///
  /// withExt = true  (/path/xxx.jpg) reture xxx.jpg
  ///
  /// withExt = false (/path/xxx.jpg) reture xxx
  String fileName([bool withExt = false]) {
    String _result = '';
    if (isnull) {
      return _result;
    }
    final pathSegments = split(Platform.pathSeparator);
    final fileNameWithExtension = pathSegments.last;
    final parts = fileNameWithExtension.split('.');
    final fileNameWithoutExtension = parts.take(parts.length - 1).join('.');
    final fileExtension = parts.last;
    if (withExt) {
      _result = '$fileNameWithoutExtension.$fileExtension';
    } else {
      _result = fileNameWithoutExtension;
    }
    return _result;
  }
}
