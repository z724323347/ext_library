// ignore_for_file: sort_constructors_first

import 'dart:collection';

import 'fps_info.dart';

int kFpsInfoMaxSize = 100;

/// Fps 信息存储
class FpsStorage {
  static FpsStorage? _instance;

  static FpsStorage? get instance {
    _instance ??= FpsStorage._();
    return _instance;
  }

  FpsStorage._();

  int maxCount = kFpsInfoMaxSize;
  Queue<FpsInfo> items = Queue();
  double? max = 0;
  double totalNum = 0;

  List<FpsInfo> getAll() {
    return items.toList();
  }

  void clear() {
    items.clear();
    max = 0;
    totalNum = 0;
  }

  bool save(FpsInfo info) {
    if (items.length >= maxCount) {
      totalNum -= items.removeFirst().totalSpan!;
    }
    items.add(info);
    totalNum += info.totalSpan!;
    max = info.totalSpan! > max! ? info.totalSpan : max;
    return true;
  }

  num getAvg() {
    return totalNum / items.length;
  }

  bool contains(FpsInfo info) {
    return items.contains(info);
  }
}
