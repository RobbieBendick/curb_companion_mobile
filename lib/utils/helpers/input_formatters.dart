import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;

    // If the user is deleting text, do nothing
    if (oldValue.text.length >= newTextLength) {
      return newValue;
    }

    // If the length is between 2 and 5, add the separator
    if (newTextLength == 2 || newTextLength == 5) {
      final String text = '${newValue.text}-';
      return newValue.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    return newValue;
  }
}
