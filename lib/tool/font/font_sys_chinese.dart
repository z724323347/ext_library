import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'font_dynamic.dart';

class SysChineseFont {
  const SysChineseFont._();

  /// Chinese font family fallback, for iOS & macOS
  static const List<String> appleFontFamily = [
    // '.SF UI Text',
    '.AppleSystemUIFont',
    'PingFang SC',
  ];

  /// Chinese font family fallback, for xiaomi & redmi phone
  static const List<String> xiaomiFontFamily = [
    'miui',
    'mipro',
  ];

  /// Chinese font family fallback, for windows
  static const List<String> windowsFontFamily = [
    'Microsoft YaHei',
  ];

  static const systemFont = "system-font";

  static bool systemFontLoaded = false;

  /// Chinese font family fallback, for VIVO Origin OS 1.0
  static final vivoSystemFont = DynamicFonts.file(
    fontFamily: systemFont,
    filepath: '/system/fonts/DroidSansFallbackMonster.ttf',
  );

  /// Chinese font family fallback, for honor Magic UI 4.0
  static final honorSystemFont = DynamicFonts.file(
    fontFamily: systemFont,
    filepath: '/system/fonts/DroidSansChinese.ttf',
  );

  /// Chinese font family fallback, for most platforms
  static List<String> get fontFamilyFallback {
    if (!systemFontLoaded) {
      // honorSystemFont.load();
      () async {
        final vivoFont = File("/system/fonts/VivoFont.ttf");
        if ((await vivoFont.exists()) &&
            (await vivoFont.resolveSymbolicLinks())
                .contains("DroidSansFallbackBBK")) {
          await vivoSystemFont.load();
        }
      }();
      systemFontLoaded = true;
    }

    return [
      systemFont,
      "sans-serif",
      ...appleFontFamily,
      ...xiaomiFontFamily,
      ...windowsFontFamily,
    ];
  }

  /// Text theme with updated fontFamilyFallback & fontVariations
  static TextTheme textTheme(Brightness brightness) {
    print('brightness1 $brightness');
    switch (brightness) {
      case Brightness.dark:
        return Typography.material2021()
            .white
            .apply(fontFamilyFallback: fontFamilyFallback);
      case Brightness.light:
        print('brightness2 $brightness');
        return Typography.material2021()
            .black
            .apply(fontFamilyFallback: fontFamilyFallback);
    }
  }
}

extension LibTextStyleUseSysChineseFont on TextStyle {
  /// Add fontFamilyFallback & fontVariation to original font style
  TextStyle useSystemChineseFont() {
    return copyWith(
      fontFamilyFallback: [
        ...?fontFamilyFallback,
        ...SysChineseFont.fontFamilyFallback,
      ],
      fontVariations: [
        ...?fontVariations,
        if (fontWeight != null)
          ui.FontVariation('wght', (fontWeight!.index + 1) * 100),
      ],
    );
  }
}

extension LibTextThemeUseSysChineseFont on TextTheme {
  /// Add fontFamilyFallback & fontVariation to original text theme
  TextTheme useSystemChineseFont(Brightness brightness) {
    return SysChineseFont.textTheme(brightness).merge(this);
  }
}

extension LibThemeDataUseSysChineseFont on ThemeData {
  /// Add fontFamilyFallback & fontVariation to original theme data
  ThemeData useSystemChineseFont(Brightness brightness) {
    return copyWith(textTheme: textTheme.useSystemChineseFont(brightness));
  }
}
