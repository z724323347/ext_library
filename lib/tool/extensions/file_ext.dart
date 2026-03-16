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

  /// 获取文件大小
  /// - return bytes
  int get size {
    if (this == null) {
      return 0;
    }
    if (this!.existsSync()) {
      final fileStat = this!.statSync();
      return fileStat.size;
    }
    return 0;
  }

  /// 获取文件长度 (同fileSize)
  /// - return bytes
  int get length {
    if (this == null) {
      return 0;
    }
    if (this!.existsSync()) {
      return this!.lengthSync();
    }
    return 0;
  }
}
