import 'package:curb_companion/utils/helpers/string_helper.dart';
import 'package:curb_companion/features/theme/app/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

class ThemeDropDownButton extends ConsumerStatefulWidget {
  const ThemeDropDownButton({super.key});

  @override
  ConsumerState<ThemeDropDownButton> createState() =>
      DropdownButtonExampleState();
}

class DropdownButtonExampleState extends ConsumerState<ThemeDropDownButton> {
  final List<String> list = ThemeMode.values
      .map((e) => StringHelper.themeModeToHumanReadableString(e))
      .toList();
  @override
  Widget build(BuildContext context) {
    String dropdownValue = StringHelper.themeModeToHumanReadableString(
        provider.Provider.of<ThemeService>(context, listen: false).themeMode);

    return DropdownButton<String>(
      value: dropdownValue,
      icon: provider.Provider.of<ThemeService>(context, listen: false)
              .isDarkMode()
          ? const Icon(Icons.dark_mode)
          : const Icon(Icons.sunny),
      elevation: 16,
      borderRadius: BorderRadius.circular(8),
      onChanged: (String? value) async {
        // This is called when the user selects an item.
        await provider.Provider.of<ThemeService>(context, listen: false)
            .setTheme(ThemeMode.values[list.indexOf(value!)]);
        setState(() {
          dropdownValue = StringHelper.themeModeToHumanReadableString(
              provider.Provider.of<ThemeService>(context, listen: false)
                  .themeMode);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
