import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

class ThemeHelper with ChangeNotifier {
  static Future<ThemeData> getLightTheme() async {
    final themeStr =
        await rootBundle.loadString('assets/themes/appainter_theme_light.json');
    final themeJson = json.decode(themeStr);
    try {
      final theme = ThemeDecoder.decodeThemeData(
            themeJson,
            validate: false,
          ) ??
          ThemeData();

      return theme;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return ThemeData();
  }

  static Future<ThemeData> getDarkTheme() async {
    try {
      final themeStr = await rootBundle
          .loadString('assets/themes/appainter_theme_dark.json');
      final themeJson = json.decode(themeStr);

      final theme = ThemeDecoder.decodeThemeData(
            themeJson,
            validate: false,
          ) ??
          ThemeData();

      return theme;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    return ThemeData();
  }
}
