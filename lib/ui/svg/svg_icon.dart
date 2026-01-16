// ignore_for_file: provide_deprecation_message, use_super_parameters

import 'dart:io';

import 'package:ext_library/lib_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget _errSvgIcon({double? width, double? height, BoxFit? fit}) {
  return const SizedBox.shrink();
}

class SvgIcon extends SvgPicture {
  ///asset  SvgPicture  重写
  SvgIcon.asset(
    assetName, {
    super.key,
    super.width,
    super.height,
    super.colorFilter,
    BoxFit? fit,
    String? package,
    @deprecated super.color,
  }) : super.asset(
          assetName,
          fit: fit ?? BoxFit.contain,
          package: package,
          errorBuilder: (_, err, st) =>
              _errSvgIcon(width: width, height: height, fit: fit),
        );

  /// 网络图片
  SvgIcon.network(
    url, {
    super.key,
    super.width,
    super.height,
    super.colorFilter,
    BoxFit? fit,
    @deprecated super.color,
  }) : super.network(
          url,
          fit: fit ?? BoxFit.contain,
          errorBuilder: (_, err, st) =>
              _errSvgIcon(width: width, height: height, fit: fit),
        );

  /// return svg/image icon
  static Widget icon(
    String svgPath, {
    Key? key,
    double? width,
    double? height,
    ColorFilter? colorFilter,
    BoxFit? fit,
    Color? color,
    String? package,
  }) {
    Widget view = Container();
    switch (svgPath.fileSuffix.toLower) {
      case 'svg':
        view = _svgView(
          svgPath,
          width: width,
          height: height,
          color: color,
          colorFilter: colorFilter,
          fit: fit,
          package: package,
        );
        break;
      default:
        view = _imageView(
          svgPath,
          width: width,
          height: height,
          color: color,
          fit: fit,
          package: package,
        );
        break;
    }
    return view;
  }

  static Widget _svgView(
    String svgPath, {
    Key? key,
    double? width,
    double? height,
    ColorFilter? colorFilter,
    BoxFit? fit,
    Color? color,
    String? package,
  }) {
    if (svgPath.isHttp) {
      return SvgIcon.network(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        colorFilter: colorFilter,
      );
    }
    if (svgPath.isAssetR) {
      return SvgIcon.asset(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        colorFilter: colorFilter,
        fit: fit,
        package: package,
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

  static Widget _imageView(
    String svgPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    String? package,
  }) {
    if (svgPath.isHttp) {
      return Image.network(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        fit: fit,
        errorBuilder: (_, err, st) =>
            _errSvgIcon(width: width, height: height, fit: fit),
      );
    }
    if (svgPath.isAssetR) {
      return Image.asset(
        svgPath,
        key: key,
        width: width,
        height: height,
        color: color,
        fit: fit,
        package: package,
        errorBuilder: (_, err, st) =>
            _errSvgIcon(width: width, height: height, fit: fit),
      );
    }
    if (svgPath.isFilePath) {
      return Image.file(
        File(svgPath),
        key: key,
        width: width,
        height: height,
        color: color,
        fit: fit,
        errorBuilder: (_, err, st) =>
            _errSvgIcon(width: width, height: height, fit: fit),
      );
    }
    return Container();
  }
}
