import 'dart:convert';

import 'package:ext_library/lib_ext.dart';
import 'package:get_storage/get_storage.dart';

/// GetStorage 缓存扩展
extension AppGetStorageExt on GetStorage {
  /// 保存  vaule 、、、、
  ///
  ///   expire => 限时保存 days (默认无限期)
  ///
  ///   duration => 限时保存 duration (默认无限期) 优先级高于 expire
  Future<void> set(
    String key,
    value, {
    int expire = 0,
    Duration duration = Duration.zero,
  }) {
    if (expire > 0) {
      final expDate = DateTime.now().add(Duration(days: expire));
      final data = {
        key: json.encode(value),
        'expire': expDate.millisecondsSinceEpoch
      };
      return write(key, json.encode(data));
    }
    if (duration > Duration.zero) {
      final expDate = DateTime.now().add(duration);
      final data = {
        key: json.encode(value),
        'expire': expDate.millisecondsSinceEpoch
      };
      return write(key, json.encode(data));
    }
    final data = {key: json.encode(value)};
    return write(key, json.encode(data));
  }

  T? get<T>(String key) {
    if (!keys.contains(key)) {
      return null;
    }
    final value = read(key);
    if (value != null) {
      try {
        final data = json.decode(value);
        if (data is Map) {
          bool hasExpire =
              data['expire'] != null && '${data['expire']}'.dateTime.overdue;
          // logs('$key --expire ==>$hasExpire');
          // 是否过期，过期后删除数据
          if (hasExpire) {
            remove(key);
            return null;
          }
          return json.decode(data[key]);
        }
        return data;
      } catch (e) {
        /// 兼容旧数据/异常数据
        final data = json.decode(value);
        if (data is Map) {
          return json.decode(data[key]);
        }

        return json.decode(data);
      }
    }
    return null;
  }

  /// all  keys
  List<String> get keys {
    List<String> data = [];
    try {
      data = getKeys().toList();
    } catch (e) {
      devLogs('error ~: $e');
    }
    return data;
  }
}
