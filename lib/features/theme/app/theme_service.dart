import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class ThemeService extends ChangeNotifier {
  String boxName = "theme";
  ThemeMode themeMode = ThemeMode.system;

  // Load the theme mode from hive
  load() async {
    Box box = await Hive.openBox(boxName);
    themeMode = themeModeFromString(
        await box.get("themeMode", defaultValue: "ThemeMode.system"));
    box.close();
    notifyListeners();
  }

  // Check the current platform's brightness settings.
  // If the theme mode is system, we need to check if the system is in dark mode
  bool isDarkMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    if (themeMode == ThemeMode.dark) {
      return true;
    } else if (themeMode == ThemeMode.system && brightness == Brightness.dark) {
      return true;
    } else {
      return false;
    }
  }

  setTheme(ThemeMode themeMode) async {
    this.themeMode = themeMode;
    Box box = await Hive.openBox(boxName);
    await box.put("themeMode", themeMode.toString());
    box.close();
    notifyListeners();
  }

  // Necessary for saving the theme mode to hive
  themeModeFromString(String themeMode) {
    if (themeMode == "ThemeMode.system") {
      return ThemeMode.system;
    } else if (themeMode == "ThemeMode.light") {
      return ThemeMode.light;
    } else if (themeMode == "ThemeMode.dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
