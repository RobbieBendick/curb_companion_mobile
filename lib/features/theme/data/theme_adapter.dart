import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeAdapter extends TypeAdapter<ThemeMode> {
  @override
  int get typeId => 5;

  @override
  ThemeMode read(BinaryReader reader) {
    final themeModeString = reader.readString();
    return themeModeFromString(themeModeString);
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    final themeModeString = themeModeToString(obj);
    writer.writeString(themeModeString);
  }

  ThemeMode themeModeFromString(String themeModeString) {
    if (themeModeString == 'ThemeMode.system') {
      return ThemeMode.system;
    } else if (themeModeString == 'ThemeMode.light') {
      return ThemeMode.light;
    } else if (themeModeString == 'ThemeMode.dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }

  String themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'ThemeMode.light';
      case ThemeMode.dark:
        return 'ThemeMode.dark';
      case ThemeMode.system:
      default:
        return 'ThemeMode.system';
    }
  }
}
