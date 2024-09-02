import 'package:flutter/material.dart';

const Size dotSize = Size(65.0, 65.0);

const double margin = 10.0;

const double bottomDistance = margin * 4;

const int kMaxTooltipLines = 10;

const double kScreenEdgeMargin = 10.0;

const double kTooltipPadding = 5.0;

const Color kTooltipBackgroundColor = Color.fromARGB(230, 60, 60, 60);

const Color kHighlightedRenderObjectFillColor =
    Color.fromARGB(128, 128, 128, 255);

const Color kHighlightedRenderObjectBorderColor =
    Color.fromARGB(128, 64, 64, 128);

const Color kTipTextColor = Color(0xFFFFFFFF);

final double ratio =
    bindingAmbiguate(WidgetsBinding.instance)!.window.devicePixelRatio;

final Size windowSize =
    bindingAmbiguate(WidgetsBinding.instance)!.window.physicalSize / ratio;

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
// refer to https://github.com/flutter/website/blob/main/src/development/tools/sdk/release-notes/release-notes-3.0.0.md#your-code
// TODO remove this when we no longer support before Flutter 3.0.0 and replace with following:
// SomeBinding.instance.someFunction(...);
T? bindingAmbiguate<T>(T? value) => value;
