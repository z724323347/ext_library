import 'dart:math' as math;

import 'package:decimal/decimal.dart';

final k2D = Decimal.fromInt(2);
final k5D = Decimal.fromInt(5);
final k10D = Decimal.fromInt(10);
final k100D = Decimal.fromInt(100);

/// 10 的8次方
final pow8 = math.pow(10, 8);

extension NullDecimalExt on Decimal? {
  Decimal get safety {
    if (this == null) {
      return Decimal.zero;
    }
    return this!;
  }
}

extension DecimalExt on Decimal {
  Decimal get safety {
    if (this == null) {
      return Decimal.zero;
    }
    return this;
  }

  /// 输出String
  String stringAs({int? digits, bool doRemove = false}) {
    if (digits == null) {
      return toString();
    }
    return setScale(digits: digits, doRemove: doRemove).toString();
  }

  /// 设置小数位数
  /// [digits] 保留的小数位
  /// [doRemove] true 截取，false 四舍五入
  Decimal setScale({int digits = 2, bool doRemove = false}) {
    if (scale <= digits) {
      return this;
    }
    if (doRemove) {
      return floor(scale: digits);
    } else {
      return round(scale: digits);
    }
  }

  /// 除以 pow(10,8) return Decimal
  Decimal toPow([int exponent = 8]) {
    Decimal result =
        (safety / Decimal.fromJson(math.pow(10, exponent).toString()))
            .toDecimal();
    return result;
  }
}
