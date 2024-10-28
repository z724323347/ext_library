import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:ext_library/lib_ext.dart';
import 'package:get_storage/get_storage.dart';

final ImageStorage imageStorage = ImageStorage._internal();

class ImageStorage {
  static const String _container = 'app_image_container';
  final _cacheKey = 'image_cache';

  final GetStorage _storage = GetStorage(_container);

  List<ImageData> imageList = [];

  ImageStorage._internal() {
    GetStorage.init(_container).then((v) {
      // 获取缓存中的数据
      imageList = _getAllCache();
    });
  }

  ///getStorage 初始化
  Future<bool> init() {
    return GetStorage.init(_container);
  }

  /// 缓存image data
  Future<void> cache(ImageData data) async {
    imageList.add(data);
    List<dynamic> list = _cacheList;
    devLogs('cacheList image : ${list.length}');
    await _storage.write(_cacheKey, list);
  }

  /// 通过URL 获取缓存图片的 base64
  Future<String?> getUrl(String url) async {
    final data =
        imageList.firstWhereIndexedOrNull((index, item) => item.url == url);
    if (data != null) {
      return data.base;
    }
    return null;
  }

  /// 移除某一个URL
  Future<void> removeUrl(String url) async {
    imageList.removeWhere((i) => i.url == url);
    List<dynamic> list = _cacheList;
    devLogs('remove image : ($url)');
    await _storage.write(_cacheKey, list);
  }

  /// 缓存列表
  List<dynamic> get _cacheList {
    List<dynamic> list = [];
    for (final i in imageList) {
      if (i.expired.safety.dateTime.isAfterNow) {
        list.add(json.encode(i.toJson()));
      }
    }
    return list;
  }

  /// 获取所有缓存
  List<ImageData> _getAllCache() {
    try {
      final data = _storage.read<List<dynamic>>(_cacheKey) ?? [];
      List<ImageData> list = [];
      if (data.isNotEmpty) {
        for (final i in data) {
          final item = ImageData.fromJson(i);
          if (item.expired.safety.dateTime.isAfterNow) {
            list.add(ImageData.fromJson(item));
          }
        }
      }
      devLogs('_getAllCache image : ${list.length}');
      return list;
    } catch (error, stackTrace) {
      devlLogU.e('读取[$_cacheKey]时出错', error, stackTrace);
      return [];
    }
  }
}

///
/// final imageData = {
///   'url': 'http://',
///   'image': 'data:image/png;base64,',
///   'expired': '2024-01-01',
/// };
class ImageData {
  final String url;
  final String? base;
  final String? expired;

  const ImageData({required this.url, this.base, this.expired});

  /// fromJson
  factory ImageData.fromJson(dynamic json) => ImageData(
        url: json['url'],
        base: json['base'],
        expired: json['expired'],
      );

  /// toJson
  Map<String, dynamic> toJson() => {
        'url': url,
        'base': base,
        'expired': expired,
      };
}
