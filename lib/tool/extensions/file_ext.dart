import 'dart:io';

import 'package:flutter/foundation.dart';

extension LibFileToolExt on File? {
  /// 获取文件的 Uint8List 数据
  Future<Uint8List?> uint8List() async {
    if (this == null) {
      return Future.value();
    }
    try {
      // byteData.buffer.asUint8List()
      return await compute((_) => _.readAsBytesSync(), this!);
    } catch (e) {
      return Future.value();
    }
  }
}
