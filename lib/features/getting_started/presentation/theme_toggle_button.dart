import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({super.key});

  @override
  State<ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  @override
  Widget build(BuildContext context) {
    return provider.Consumer(
      builder: (context, ThemeService themeNotifier, child) => IconButton(
        icon: Icon(
          themeNotifier.isDarkMode() ? Icons.sunny : Icons.nightlight_round,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
        onPressed: () async {
          themeNotifier.isDarkMode()
              ? themeNotifier.setTheme(ThemeMode.light)
              : themeNotifier.setTheme(ThemeMode.dark);
        },
      ),
    );
  }
}
