import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

/// PingFang 字体库
const String _fontFamilyPingFang = 'PingFang';

/// DIN  字体库
const String _fontFamilyDINCond = 'DIN';

/// app 字体扩展
extension TextStyleExt on TextStyle {
  /// textstyle  使用苹果平方字体
  TextStyle get copyFontF => copyWith(fontFamily: _fontFamilyPingFang);

  /// textstyle  使用DIN字体
  TextStyle get copyFontD => copyWith(fontFamily: _fontFamilyDINCond);
}

extension AppText on Text {
  Widget addStyle({
    TextStyle? style,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return copyWith(
      style: style ??
          TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
    );
  }
}

extension StyledText<T extends Text> on T {
  T copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
  }) =>
      Text(
        data ?? this.data ?? '',
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        locale: locale ?? this.locale,
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        softWrap: softWrap ?? this.softWrap,
        textDirection: textDirection ?? this.textDirection,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      ) as T;

  T textStyle(TextStyle style) => this.copyWith(
        style: (this.style ?? const TextStyle()).copyWith(
          background: style.background,
          backgroundColor: style.backgroundColor,
          color: style.color,
          debugLabel: style.debugLabel,
          decoration: style.decoration,
          decorationColor: style.decorationColor,
          decorationStyle: style.decorationStyle,
          decorationThickness: style.decorationThickness,
          fontFamily: style.fontFamily,
          fontFamilyFallback: style.fontFamilyFallback,
          fontFeatures: style.fontFeatures,
          fontSize: style.fontSize,
          fontStyle: style.fontStyle,
          fontWeight: style.fontWeight,
          foreground: style.foreground,
          height: style.height,
          inherit: style.inherit,
          letterSpacing: style.letterSpacing,
          locale: style.locale,
          shadows: style.shadows,
          textBaseline: style.textBaseline,
          wordSpacing: style.wordSpacing,
        ),
      );

  T fontWeight(FontWeight? fontWeight) => this.copyWith(
      style: (style ?? const TextStyle()).copyWith(fontWeight: fontWeight));

  T fontSize(double? size) => this
      .copyWith(style: (style ?? const TextStyle()).copyWith(fontSize: size));

  T textColor(Color? color) =>
      this.copyWith(style: (style ?? const TextStyle()).copyWith(color: color));
}

extension EdgeInsetsDoubleExt on num {
  /// 增加边距
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// 增加顶部边距
  EdgeInsets get top => EdgeInsets.only(top: toDouble());

  /// 增加底部边距
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());

  /// 增加左边距
  EdgeInsets get left => EdgeInsets.only(left: toDouble());

  /// 增加右边距
  EdgeInsets get right => EdgeInsets.only(right: toDouble());

  /// 增加水平边距 =>EdgeInsets.only(left:num, right: num)
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// 增加垂直边距
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  /// copyWith
  // EdgeInsets get copyLeft => EdgeInsets.zero.copyWith(left: toDouble());

  ///* size width */
  SizedBox get sizeWidth => SizedBox(width: toDouble());

  ///* height height */
  SizedBox get sizeHeight => SizedBox(height: toDouble());
}

extension EdgeInsetsExt on EdgeInsets {
  /// 增加水平/垂直边距 覆盖之前的属性
  EdgeInsets symmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }
}

extension RadiusExt on num {
  /// 圆角
  Radius get radius => Radius.circular(toDouble());
}

extension WidgetOnNumExt on num {
  /// 水平差距
  Widget get wGap => SizedBox(width: toDouble());

  /// 垂直差距
  Widget get hGap => SizedBox(height: toDouble());
}

extension BorderRadiusExt on num {
  /// 增加圆角
  BorderRadius get borderAll => BorderRadius.all(radius);

  /// 增加左边圆角
  BorderRadius get borderLeft => BorderRadius.horizontal(left: radius);

  /// 增加右边圆角
  BorderRadius get borderRight => BorderRadius.horizontal(right: radius);

  /// 增加上圆角
  BorderRadius get borderTop => BorderRadius.vertical(top: radius);

  /// 增加下圆角
  BorderRadius get borderBottom => BorderRadius.vertical(bottom: radius);

  /// 增加左上圆角
  BorderRadius get borderTopLeft => BorderRadius.only(topLeft: radius);

  /// 增加右上圆角
  BorderRadius get borderTopRight => BorderRadius.only(topRight: radius);

  /// 增加左下圆角
  BorderRadius get borderBottomLeft => BorderRadius.only(bottomLeft: radius);

  /// 增加右下圆角
  BorderRadius get borderBottomRight => BorderRadius.only(bottomRight: radius);
}

extension WidgetPaddingExt on Widget {
  ///Padding all
  Widget pAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  ///Padding symmetric
  Widget pSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  ///Padding only
  Widget pOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  ///Padding zero
  Widget get pZero => Padding(padding: EdgeInsets.zero, child: this);

  /// Margin all
  Widget mAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  /// Margin symmetric
  Widget mSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
        margin:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  /// Margin only
  Widget mOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
        margin: EdgeInsets.only(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  /// Margin zero
  Widget get mZero => Container(margin: EdgeInsets.zero, child: this);

  /// 添加点击事件
  ///
  /// vibr 是否带反馈
  Widget onClick({void Function()? onTap, bool vibr = false}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
        if (vibr) {
          vibration();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: this,
    );
  }

  // expand
  // Widget expand({int flex = 1}) {
  //   return Expanded(flex: flex, child: this);
  // }

  /// 是否可见
  Widget visible({bool visible = true}) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  /// 组件放大 or 缩小
  Widget scale({
    double? scale,
    double? scaleX,
    double? scaleY,
  }) {
    return Transform.scale(
      scale: scale,
      scaleX: scaleX,
      scaleY: scaleY,
      child: this,
    );
  }
}
