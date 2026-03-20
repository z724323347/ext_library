library app_cache;

import 'dart:convert';

import 'package:ext_library/tool/cache/ext_cache.dart';
import 'package:get_storage/get_storage.dart';

/// app 缓存
///- 实现 [GetStorage]
class AppCache<T extends Object> {
  final String key;

  const AppCache(this.key);
  static const String _container = 'app_cache_container';
  GetStorage get storage => GetStorage(_container);

  ///getStorage 初始化
  static Future<bool> init() {
    return GetStorage.init(_container);
  }

  /// 清除缓存
  void clearAll() => storage.erase();

  /// 移除某一个key
  Future<void> remove() {
    return storage.remove(key);
  }

  /// 保存  vaule 、、、、
  ///
  ///   expire => 限时保存 days (默认无限期)
  Future<void> set(
    T value, {
    int expire = 0,
    Duration duration = Duration.zero,
  }) {
    return storage.set(key, value, expire: expire, duration: duration);
  }

  /// Cache key 获取缓存 Valu e
  T? get keyVal {
    if (!exist) {
      return null;
    }
    return storage.get(key);
  }

  T? get value {
    if (!exist) {
      return null;
    }
    return storage.get(key);
  }

  /// Cache key 是否存在
  bool get exist => storage.keys.contains(key);
}

extension AppCacheExt on AppCache {
  dynamic extVal(key) {
    if (key == null || !storage.keys.contains(key)) {
      return null;
    }
    final data = json.decode(storage.read(key));
    if (data is Map) {
      return data[key];
    }
    return data;
  }

  /// 设置值
  Future<void> extSet(String key, value) async {
    final data = {key: json.encode(value)};
    await storage.write(key, json.encode(data));
  }

  /// 移除 key
  Future<void> extRemove(String key) {
    return storage.remove(key);
  }
}
