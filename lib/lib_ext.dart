library lib_ext;

export 'package:dio/dio.dart';
export 'package:get/get.dart'
    hide
        Response,
        GetNumUtils,
        Condition,
        MultipartFile,
        FormData,
        GetDurationUtils,
        NotifyManager;

export 'tool/tool_lib.dart';
export 'ui/lib_ui.dart';
export 'log_util.dart';
export 'debug/lib_debug.dart';
export 'ume/lib_ume.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
