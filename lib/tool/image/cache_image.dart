// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui show Codec;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';

/// image provider for CacheNet image
class CacheNetImage extends ImageProvider<CacheNetImage> implements CacheKey {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments must not be null.
  const CacheNetImage(
    this.url, {
    this.scale = 1.0,
    this.headers,
  })  : assert(url != null),
        assert(scale != null);

  static final HttpClient _httpClient = HttpClient();

  /// The URL from which the image will be fetched.
  final String url;

  /// The scale to place in the [ImageInfo] object of the image.
  final double scale;

  /// The HTTP headers that will be used with [HttpClient.get] to fetch image from network.
  final Map<String, String>? headers;

  ///the id of this image
  ///CacheNet image url has a unique id at url last part
  ///
  //缓存主host
  String get _cacheHost => url.split('?')[0];
  String get id => _cacheHost.substring(
      _cacheHost.lastIndexOf('/') == -1 ? 0 : _cacheHost.lastIndexOf('/') + 1,
      _cacheHost.length);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheNetImage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          scale == other.scale;

  @override
  int get hashCode => hashValues(id, scale);

  @override
  ImageStreamCompleter loadBuffer(
      CacheNetImage key, DecoderBufferCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(CacheNetImage key) async {
    assert(key == this);
    final cache = await _imageCache();

    final image = await cache.get(key);
    if (image != null) {
      // return PaintingBinding.instance
      //     .instantiateImageCodec(Uint8List.fromList(image));
      ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(image);
      return PaintingBinding.instance.instantiateImageCodecFromBuffer(buffer);
    }
    //request network source
    final resolved = Uri.base.resolve(key.url);
    final request = await _httpClient.getUrl(resolved);
    headers?.forEach((name, value) {
      request.headers.add(name, value);
    });
    final response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw Exception(
          'HTTP request failed, statusCode: ${response.statusCode}, $resolved');
    }

    final bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0) {
      throw Exception('CacheNetImage is an empty file: $resolved');
    }

    //save image to cache
    await cache.update(key, bytes);

    // return PaintingBinding.instance.instantiateImageCodec(bytes);
    ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(bytes);
    return PaintingBinding.instance.instantiateImageCodecFromBuffer(buffer);
  }

  @override
  Future<CacheNetImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<CacheNetImage>(this);
  }

  @override
  String toString() {
    return 'CacheNetImage{url: $url, scale: $scale}';
  }

  @override
  String getKey() {
    return id;
  }
}

_ImageCache? __imageCache;

Future<_ImageCache> _imageCache() async {
  final Completer<_ImageCache> completer = Completer<_ImageCache>();
  if (__imageCache != null) {
    return __imageCache!;
  }

  // final temp = await getTemporaryDirectory();
  // var dir = Directory('${temp.path}/washine_images/');
  // if (!(await dir.exists())) {
  //   dir = await dir.create();
  // }
  // return __imageCache = _ImageCache(dir);
  // __imageCache = _ImageCache(dir);
  // completer.complete(__imageCache);
  // return
  return completer.future;
}

///cache CacheNet image data
class _ImageCache implements Cache<Uint8List> {
  _ImageCache(Directory dir) : provider = FileCacheProvider(dir);

  final FileCacheProvider provider;

  @override
  Future<Uint8List?> get(CacheKey key) async {
    final file = provider.getFile(key);
    if (await file.exists()) {
      return file.readAsBytes();
      // final Uint8List result = await FlutterImageCompress.compressWithList(
      //     await file.readAsBytes(),
      //     quality: 50);
      // return Uint8List.fromList(result);
    }
    return null;
  }

  @override
  Future<bool> update(CacheKey key, Uint8List t) async {
    var file = provider.getFile(key);
    if (await file.exists()) {
      await file.delete();
    }
    file = await file.create();
    await file.writeAsBytes(t);
    return file.exists();
  }
}

abstract class CacheKey {
  ///unique key to save or get a cache
  String getKey();
}

///base cache interface
///provide method to fetch or update cache object
abstract class Cache<T> {
  ///get cache object by key
  ///null if no cache
  Future<T?> get(CacheKey key);

  ///update cache by key
  ///true if success
  Future<bool> update(CacheKey key, T t);
}

class FileCacheProvider {
  const FileCacheProvider(this.directory) : assert(directory != null);

  final Directory directory;

  Future<bool> isCacheAvailable(CacheKey key) {
    return _cacheFileForKey(key).exists();
  }

  File getFile(CacheKey key) {
    return _cacheFileForKey(key);
  }

  File _cacheFileForKey(CacheKey key) =>
      File('${directory.path}/${key.getKey()}');
}
