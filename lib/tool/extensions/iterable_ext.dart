import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Iterable/List 等 扩展函数
///
extension LibIterableExt<T> on Iterable<T> {
  List<T> divide(
    T divider, {
    bool addBefore = false,
    bool addAfter = false,
  }) {
    final list = <T>[];
    forEachIndexed((index, child) {
      if (addBefore || index > 0) {
        list.add(divider);
      }
      list.add(child);
    });
    if (addAfter) {
      list.add(divider);
    }

    return list;
  }
}

// 给 数组类型添加扩展方法
extension LibListExt<T> on List<T> {
  Function get forEachIndex {
    return asMap().keys.toList().forEach;
  }

  Function get valueKeyMap {
    return asMap().entries.map;
  }

  Function get mapIndex {
    return asMap().keys.map;
  }

  List<T> forParse(Function(T) parse) {
    List<T> result = [];
    forEach((e) {
      var data = parse(e);
      result.add(data);
    });
    return result;
  }

  List<T> removeNull() {
    removeWhere((element) => element == null);
    return this;
  }

  /// 截取列表 最大长度
  List<T> max([int max = 3]) {
    if (length <= max) {
      return this;
    } else {
      return sublist(0, max);
    }
  }
}

extension LibListViewExt<E> on List<Widget> {
  // /// listview  追加尾部
  Iterable<Widget> addFoot({required Widget child}) {
    return this..add(child);
  }

  /// listview  插入头部
  Iterable<Widget> addHead({required Widget child}) {
    // return [child, ...this];
    return this..insert(0, child);
  }

  /// 转为 column
  Widget toColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
  }) =>
      Column(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: separator != null && isNotEmpty
            ? (expand((child) => [child, separator]).toList()..removeLast())
            : this,
      );

  /// 转为 row
  Widget toRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    Widget? separator,
  }) =>
      Row(
        key: key,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        textBaseline: textBaseline,
        children: separator != null && isNotEmpty
            ? (expand((child) => [child, separator]).toList()..removeLast())
            : this,
      );

  /// 转为 stack
  Widget toStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    List<Widget> children = const <Widget>[],
  }) =>
      Stack(
        key: key,
        alignment: alignment,
        textDirection: textDirection,
        fit: fit,
        clipBehavior: clipBehavior,
        children: this,
      );

  /// 转为 wrap
  Widget toWrap({
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 0.0,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 0.0,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
    List<Widget> children = const <Widget>[],
  }) =>
      Wrap(
        key: key,
        direction: direction,
        alignment: alignment,
        spacing: spacing,
        runAlignment: runAlignment,
        runSpacing: runSpacing,
        crossAxisAlignment: crossAxisAlignment,
        textDirection: textDirection,
        verticalDirection: verticalDirection,
        clipBehavior: clipBehavior,
        children: this,
      );
}

extension MapExt on Map<String, dynamic> {
  Map<String, dynamic> add({String? k, dynamic v}) {
    if (k != null || k!.isNotEmpty) {
      this[k] = v;
    }
    return this;
  }

  /// 移除多少项
  Map<String, dynamic> rmLength({int count = 10}) {
    if (length > count) {
      for (var i = 0; i < count; i++) {
        remove(keys.last);
      }
    }
    return this;
  }
}
