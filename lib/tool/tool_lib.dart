library tool_lib;

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/services.dart';

export './extensions/date_ext.dart';
export './extensions/decimal_ext.dart';
export './extensions/duration_ext.dart';
export './extensions/function_ext.dart';
export './extensions/iterable_ext.dart';
export './extensions/num_ext.dart';
export './extensions/style_ext.dart';
export './extensions/string_ext.dart';
export './extensions/string_to_builder.dart';
export './extensions/text_editing_ext.dart';
export './extensions/widget_ext.dart';
export './extensions/object_ext.dart';
export './extensions/color_ext.dart';
export './extensions/event_ext.dart';
export './image/image_thief.dart';
export './internet/internet_checker_plus.dart';

export './mixins/api_mixins.dart';

LibTools libTools = LibTools._internal();

class LibTools {
  LibTools._internal();

  /// APP 文本复制
  void copy(String? text, {String? tipText}) {
    if (text.isnull) {
      return;
    }
    final ClipboardData data = ClipboardData(text: text.safety);
    Clipboard.setData(data);
    AppToast.showSuccess(tipText ?? '复制成功');
    HapticFeedback.mediumImpact();
  }
}
