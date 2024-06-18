// ignore_for_file: constant_identifier_names

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int _KValue = 1000;
const int _MValue = 1000 * 1000;
const int _GValue = 1000 * 1000 * 1000;

const String _KSymbol = 'K';
const String _MSymbol = 'M';
const String _GSymbol = 'B';

/// 计量单位
enum Metering { K, M, B }

const Map<Metering, int> MeteringValueMap = <Metering, int>{
  Metering.K: _KValue,
  Metering.M: _MValue,
  Metering.B: _GValue,
};

const Map<Metering, String> MeteringSymbolMap = <Metering, String>{
  Metering.K: _KSymbol,
  Metering.M: _MSymbol,
  Metering.B: _GSymbol,
};

extension LibNumExtNull on num? {
  /// num 转 int  (空安全)
  int get safety {
    if (this == null) {
      return 0;
    }
    try {
      return int.parse('$this');
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  ///  num 是否为空 或者 0  或者 0.0
  bool get isnull {
    if (this == null || this == 0 || this == 0.0) {
      return true;
    } else {
      return false;
    }
  }

  /// num 转 string
  String get ts => this == null ? '' : '$this';

  /// 限制最大展示 [max = 9999]
  String limitMax([int max = 9999]) {
    if (isnull) {
      return '0';
    }
    if (safety <= max) {
      return '$this';
    } else {
      return '$max+';
    }
  }
}

/// 数字  扩展函数
extension LibNumExt on num {
  /// num 转 string
  String get ts => this == null ? '' : '$this';

  Decimal get decimal {
    if (this == null) {
      return Decimal.zero;
    }
    if (this is int) {
      return Decimal.fromInt(this as int);
    }
    return Decimal.parse(toString());
  }

  /// 分/100  转为价格
  String get toPrice {
    if (this == null || isNaN) {
      return '0.00';
    }
    try {
      return (this / 100).toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  ///  this/100  转为百分百
  String get toPercent {
    if (this == null || isNaN) {
      return '0.00';
    }
    try {
      return (this / 100).toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
  }

  ///  num 是否为空
  bool get isnull {
    if (this == null || this == 0 || this == 0.0) {
      return true;
    } else {
      return false;
    }
  }

  ///  num 是否为0
  bool get iszero {
    if (this == 0.0 || this == 0 || this == null) {
      return true;
    } else {
      return false;
    }
  }

  /// num 是否为 int类型
  bool get isint {
    if (this is int) {
      return true;
    } else {
      return false;
    }
  }

  /// num 是否为 double类型
  bool get isdouble {
    if (this is double) {
      return true;
    } else {
      return false;
    }
  }

  /// num 转 int  (空安全)
  int get safety {
    if (this == null) {
      return 0;
    }
    try {
      return toInt();
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  ///  int 千分位 格式化
  String get thousands {
    final sFormat = NumberFormat('#,###', 'en_US');
    if (this == null) {
      return '0';
    }

    final number = Decimal.parse('$this');
    if (number == Decimal.zero) {
      return '0';
    }
    return sFormat.format(double.parse('$this'));
  }

  /// 限制最大展示 [max = 9999]
  String limitMax([int max = 9999]) {
    if (isnull) {
      return '0';
    }
    if (safety <= max) {
      return '$this';
    } else {
      return '$max+';
    }
  }

  ///取小数点后几位
  ///num 数据
  ///location 几位
  String numLimit({int limit = 2}) {
    if (isnull) {
      return '';
    }
    if ((toString().length - toString().lastIndexOf('.') - 1) < limit) {
      //小数点后有几位小数
      return toStringAsFixed(limit)
          .substring(0, toString().lastIndexOf('.') + limit + 1);
    } else {
      return toString().substring(0, toString().lastIndexOf('.') + limit + 1);
    }
  }

  ///  MillisecondsSinceEpoch
  ///
  ///  毫秒时间戳转为 DateTime
  DateTime get dateTime {
    if (isint) {
      /// 部分接口 时间戳返回 秒/毫秒  时间异常兼容
      ///        1659522500000
      if (this < 9999999999) {
        return DateTime.fromMillisecondsSinceEpoch(
          (this as int) * 1000,
          // isUtc: true,
        );
      }
      return DateTime.fromMillisecondsSinceEpoch(
        this as int,
        // isUtc: true,
      );
    } else {
      final reg = RegExp(r'^\d+$');
      if (!reg.hasMatch(toString())) {
        try {
          return DateTime.parse('$this');
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.fromMillisecondsSinceEpoch(
        this == null ? 0 : toInt(),
        isUtc: true,
      );
    }
  }
}
