import 'package:flutter/services.dart';

abstract class InputFormatter {
  static final TextInputFormatter currency = FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'));
  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
}
