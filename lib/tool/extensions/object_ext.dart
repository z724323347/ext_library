import 'dart:convert';

///
extension LibDynamic on dynamic {
  ///  return   String 格式
  ///
  ///  Map<String, dynamic>
  Map<String, dynamic> get withMap {
    if (this is! Map || this == null) {
      return {};
    }
    final rawData = this as Map<String, dynamic>;
    final resultData = rawData.map((key, value) {
      return MapEntry(key, value);
    });
    return resultData;
  }

  ///  return   dynamic 格式
  ///
  ///  Map<dynamic, dynamic>
  Map<dynamic, dynamic> get dyncMap {
    if (this is! Map || this == null) {
      return {};
    }
    // return this as Map;
    final rawData = this as Map<dynamic, dynamic>;
    final resultData = rawData.map((key, value) {
      return MapEntry(key, value);
    });
    return resultData;
  }

  /// string 转 jsonEncode
  String? get jsEncode {
    if (this == null) {
      return null;
    }
    return json.encode(this);
  }

  /// string 转 jsonDecode
  dynamic get jsDecode {
    if (this == null) {
      return null;
    }
    return json.decode('$this');
  }

  /// 将map 转为 path 路径
  ///
  /// 如：{a:1,b:2} => a=1&b=2
  String? get toRoutePath {
    if (this == null) {
      return null;
    }
    String _path = '';
    (this as Map).forEach((key, value) {
      _path += '$key=$value&';
    });
    String result = _path;
    if (result.length > 1) {
      result = _path.substring(0, _path.length - 1);
    }
    return result;
  }
}

extension LibObject on Object {
  /// string 转 jsonEncode
  String? get jsEncode {
    if (this == null) {
      return null;
    }
    return json.encode(this);
  }

  /// string 转 jsonDecode
  dynamic get jsDecode {
    if (this == null) {
      return null;
    }
    return json.decode('$this');
  }

  /// object 转 map , 主要使用在路由传参
  Map<String, dynamic> get toMap {
    Map<String, dynamic> data = {};
    if (this == null) {
      return {};
    }
    if (this is Map) {
      // object 为空map
      if (toString() == '{}') {
        return {};
      }
      data = this as Map<String, dynamic>;
    }
    return data;
  }
}

extension LibNullObject on Object? {
  /// string 转 jsonEncode
  String? get jsEncode {
    if (this == null) {
      return null;
    }
    return json.encode(this);
  }

  /// object 转 map , 主要使用在路由传参
  Map<String, dynamic> get toMap {
    Map<String, dynamic> data = {};
    if (this == null) {
      return {};
    }
    if (this is Map) {
      // object 为空map
      if (toString() == '{}') {
        return {};
      }
      data = this as Map<String, dynamic>;
    }
    return data;
  }
}

extension LibMap<K, V> on Map<K, V>? {
  Map<K, V> get removeNull {
    if (this == null) {
      return {};
    }
    return this!..removeWhere((key, value) => value == null || value == '');
  }

  Map<K, V> removeKey(key) {
    if (this == null) {
      return {};
    }
    return this!..remove(key);
  }

  Map<K, V> addKeyV(Map<K, V>? data) {
    if (this == null) {
      if (data == null) {
        return {};
      }
      return {}..addAll(data);
    }
    return this!..addAll(data!);
  }
}

// extension LIbMapExt on Map? {
//   Map get removeNull {
//     if (this == null) {
//       return {};
//     }
//     return this!..removeWhere((key, value) => value == null);
//   }

//   Map add({String? k, dynamic v}) {
//     if (this == null) {
//       return {};
//     }
//     if (k != null || k!.isNotEmpty) {
//       this![k] = v;
//     }
//     return this!;
//   }

//   /// 移除多少项
//   Map rmLength({int count = 10}) {
//     if (this == null) {
//       return {};
//     }
//     if (this!.length > count) {
//       for (var i = 0; i < count; i++) {
//         this!.remove(this!.keys.last);
//       }
//     }
//     return this!;
//   }
// }
