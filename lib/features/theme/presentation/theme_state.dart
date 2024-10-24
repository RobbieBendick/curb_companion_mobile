import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode stateThemeMode;

  ThemeState(this.stateThemeMode);
}

class ThemeStateLoading extends ThemeState {
  ThemeStateLoading() : super(ThemeMode.system);
}

class ThemeStateLoaded extends ThemeState {
  ThemeStateLoaded(ThemeMode themeMode) : super(themeMode);
}
