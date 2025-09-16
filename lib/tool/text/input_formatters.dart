import 'package:flutter/services.dart';

/// 输入地址正则
final regAddress = RegExp(r'^[a-zA-Z0-9!@#$%^&*()-=_+{}[\];:"<>,.?/~|]+$');

class FloatInputFormatter extends TextInputFormatter {
  /// integer 整数精度
  ///
  /// precision 小数精位  默认2位小数, 0表示整数
  factory FloatInputFormatter({int integer = 11, int precision = 2}) {
    final regExp =
        RegExp(DecimalValidator.decimalRegStr(precision, integer: integer));
    return FloatInputFormatter.reg(regExp);
  }

  FloatInputFormatter.reg(this.regExp);

  final RegExp regExp;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text;
    var selectionIndex = newValue.selection.end;

    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (regExp.hasMatch(value)) {
      return newValue;
    }

    if (!regExp.hasMatch(oldValue.text)) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    value = oldValue.text;
    selectionIndex = oldValue.selection.end;

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class AddressInputFormatter extends TextInputFormatter {
  factory AddressInputFormatter({String? soure}) {
    final regExp = regAddress;
    return AddressInputFormatter.reg(regExp);
  }
  AddressInputFormatter.reg(this.regExp);
  final RegExp regExp;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = newValue.text;
    var selectionIndex = newValue.selection.end;

    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (regExp.hasMatch(value)) {
      return newValue;
    }

    if (!regExp.hasMatch(oldValue.text)) {
      return const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    value = oldValue.text;
    selectionIndex = oldValue.selection.end;

    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class DecimalValidator {
  /// 返回可匹配「指定精度」的正则表达式
  static String decimalRegStr(int precision, {int integer = 11}) {
    String decimalRegStr;
    if (precision <= 0) {
      decimalRegStr = r'(^(0|[1-9]\d{0,11})$|^$)';
    } else {
      decimalRegStr =
          r'(^(0|[1-9]\d' '{0,$integer}' r')(\.\d' '{0,$precision}' r')?$|^$)';
    }
    return decimalRegStr;
  }
}
