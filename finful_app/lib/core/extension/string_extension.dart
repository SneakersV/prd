import '../regex/regex.dart';
import 'package:tiengviet/tiengviet.dart';

extension StringExtension on String {
  // Chuẩn hóa cả dấu chấm và dấu phẩy thành định dạng parse được
  String get _normalized => replaceAll(',', '.'); // "4,5" → "4.5"

  /// Từ "tỷ" (vd: "4.5", "10") → số nguyên triệu
  /// "4.5"   → 4500
  /// "10"    → 10000
  /// "1.99"  → 1990
  /// "80"    → 80 (dưới 100 → hiểu là triệu, giữ nguyên)
  int get fromBillionsToMillionsInt {
    final cleaned = _normalized;
    final value = double.tryParse(cleaned) ?? 0.0;
    final result = value >= 100 ? value * 1000 : value;
    return result.floor();
  }

  /// Từ triệu → tỷ
  int get fromMillionsToBillionsInt {
    final value = double.tryParse(_normalized) ?? 0.0;
    return (value / 1000).floor();
  }

  bool get isBillion {
    return toLowerCase().contains("tỷ");
  }

  int toMillionByUnit(String? unit) {
    final normalizedText = _normalized;
    final value = double.tryParse(normalizedText);
    if (value == null) return -1;

    final fUnit = unit ?? "";
    if (fUnit.isBillion) {
      return (value * 1000).floor(); // luôn nhân 1000 nếu là tỷ
    } else {
      return value.floor(); // là triệu → giữ nguyên
    }
  }

  String uriPath() {
    final uri = Uri.tryParse(this);
    return uri!.path;
  }

  String toAddPrefixPhoneNumber({String prefix = '0'}) {
    if (isEmpty) {
      return '';
    }

    final isSame =
        RegExp(RegexConstants.phoneNumberCountryCodeRegex).hasMatch(trim());

    return isSame
        ? replaceAll(RegExp(RegexConstants.phoneNumberCountryCodeRegex), prefix)
        : '0$this';
  }

  String getNormalImageUrlFromHost(String mediaHost) {
    return '$mediaHost=$this';
  }

  String get setTwoCharacterNumber {
    final temp = int.tryParse(this);
    if (temp == null) {
      return '00';
    }

    if (temp < 10) {
      return '0$temp';
    }

    return temp.toString();
  }

  String formatPhoneNumber({
    String countryCode = '84',
  }) {
    if (this[0] == '0') {
      return '+$countryCode${substring(1)}';
    }
    if (substring(0, 2) == countryCode) {
      return '+$this';
    }
    return this;
  }

  String toInsertDoubleSpaceToPhoneNumber({
    required int firstIndex,
    required int secondIndex,
  }) {
    final newLength = length;
    final stringBuffer = StringBuffer();
    var usedSubstringIndex = 0;

    if (newLength >= firstIndex) {
      usedSubstringIndex = firstIndex - 1;
      stringBuffer.write('${substring(0, usedSubstringIndex)} ');
    }

    if (newLength >= secondIndex) {
      usedSubstringIndex = secondIndex - 1;
      final startIndex = firstIndex - 1;
      stringBuffer.write('${substring(startIndex, usedSubstringIndex)} ');
    }

    /// add the rest to new string
    if (newLength >= usedSubstringIndex) {
      stringBuffer.write(substring(usedSubstringIndex));
    }

    return stringBuffer.toString();
  }

  String get toFormatterPhoneInput {
    return toAddPrefixPhoneNumber().toInsertDoubleSpaceToPhoneNumber(
      firstIndex: 5,
      secondIndex: 8,
    );
  }

  String toMapQueryToTextTag({
    required String textQuery,
    required String startTag,
    required String endTag,
  }) {
    try {
      for (var i = 0; i < length; i++) {
        if (this[i].toLowerCase() == textQuery[0].toLowerCase()) {
          if (i + textQuery.length <= length) {
            final temp = substring(i, i + textQuery.length);
            if (temp.toLowerCase() == textQuery.toLowerCase()) {
              return replaceAll(temp, '$startTag$temp$endTag');
            }
          }
        }
      }
      return this;
    } catch (e) {
      return this;
    }
  }

  bool get isNumber => int.tryParse(this) != null;

  bool get isPasswordValid => length >= 8;

  bool get isEmailValid =>
      RegExp(RegexConstants.validEmailRegex, caseSensitive: false)
          .hasMatch(this);

  bool get isAddressValid => length > 1 && length < 201;

  String get toFormattedCurrency {
    return replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
  }

  String get toVietnameseWithoutAccentMark {
    return TiengViet.parse(this);
  }

  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

extension StringValidatorExtension on String? {
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;

  bool get isNullOrEmpty => (this != null ? this!.trim() : '').isEmpty;

  bool isURL() => RegExp(RegexConstants.validUrlRegex, caseSensitive: false)
      .hasMatch(this!);

  bool get isValidPhoneNumber {
    if (isNullOrEmpty) {
      return false;
    }

    return RegExp(RegexConstants.validPhoneNumberRegex).hasMatch(
        this!.trim().replaceAll(RegexConstants.hasSpaceCharacter, ''));
  }

  bool get isValidPasswordLength => this!.trim().length >= 8;

  bool get isValidCharacterPassword =>
      RegExp(RegexConstants.hasOnlyAlphabetsAndNumbersRegex)
          .hasMatch(this!.trim());
}
