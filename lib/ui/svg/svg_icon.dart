// ignore_for_file: provide_deprecation_message

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends SvgPicture {
  ///asset  SvgPicture  重写
  SvgIcon.asset(
    assetName, {
    super.key,
    super.width,
    super.height,
    super.colorFilter,
    BoxFit? fit,
    @deprecated super.color,
  }) : super.asset(assetName, fit: fit ?? BoxFit.contain);

  /// 网络图片
  SvgIcon.network(
    url, {
    super.key,
    super.width,
    super.height,
    super.colorFilter,
    BoxFit? fit,
    @deprecated super.color,
  }) : super.network(url, fit: fit ?? BoxFit.contain);

  /// return svg icon
  static Widget icon(
    String svgPath, {
    Key? key,
    double? width,
    double? height,
    ColorFilter? colorFilter,
    BoxFit? fit,
    Color? color,
  }) {
    if (svgPath.isnull) {
      return SvgIcon.network(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        colorFilter: colorFilter,
      );
    }
    if (svgPath.startsWith('assets/')) {
      return SvgIcon.asset(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        colorFilter: colorFilter,
      );
    }
    return SvgPicture.string(
      svgPath,
      key: key,
      width: width,
      height: height,
      color: color,
      colorFilter: colorFilter,
    );
  }
}
