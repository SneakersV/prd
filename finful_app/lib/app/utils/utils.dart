import 'package:flutter/services.dart';

Future<void> forceDelay({
  Duration? duration,
}) async {
  await Future<void>.delayed(duration ?? const Duration(milliseconds: 300));
}

class CommaToDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(',', '.');
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

List<TextInputFormatter> get sectionNumberInputFormatters {
  return [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
    CommaToDotFormatter(),
  ];
}