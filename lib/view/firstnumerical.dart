import 'package:flutter/services.dart';

class FirstNonNumericalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty && _isNumeric(newValue.text[0])) {
      return oldValue;
    } else {
      return newValue;
    }
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
