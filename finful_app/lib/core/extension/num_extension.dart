import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import './iterable_extension.dart';
import 'string_extension.dart';

extension NumExtension on num {
  /// Chuyển từ "tỷ" về đơn vị triệu
  /// 1 tỷ → 1000 (triệu)
  /// 4.5 tỷ → 4500 (triệu)
  /// 500 triệu → 500 (triệu) (giữ nguyên)
  double get fromBillionsToMillions {
    final value = toDouble();
    // Nếu giá trị >= 100 triệu → coi như đang ở đơn vị tỷ
    return value >= 100 ? value * 1000 : value;
  }

  /// Ngược lại: từ triệu về tỷ
  double get fromMillionsToBillions => this / 1000;

  num toPrecision(int precision) {
    return num.parse(toStringAsFixed(precision));
  }

  String toLocalizedString({String locale = 'vi'}) {
    final formatter = NumberFormat.compactLong(locale: locale);
    return formatter.format(this);
  }

  String toVietnameseWords() {
    const zeroLeftPadding = ['', '00', '0'];
    const digits = [
      'không',
      'một',
      'hai',
      'ba',
      'bốn',
      'năm',
      'sáu',
      'bảy',
      'tám',
      'chín'
    ];
    const multipleThousand = [
      '',
      'nghìn',
      'triệu',
      'tỷ',
      'nghìn tỷ',
      'triệu tỷ',
      'tỷ tỷ'
    ];

    if (this == 0) {
      return 'Không';
    }
    if (this < 0) {
      return 'Âm ${(-this).toVietnameseWords()}';
    }

    String readPair(int b, int c) {
      return b == 0
          ? c == 0
              ? ''
              : ' lẻ ${digits[c]}'
          : b == 1
              ? 'mười ${c == 0 ? '' : c == 5 ? 'lăm' : digits[c]}'
              : '${digits[b]} mươi ${c == 0 ? '' : c == 1 ? 'một' : c == 4 ? 'tư' : c == 5 ? 'lăm' : digits[c]}';
    }

    String readTriple(List<String> triple, bool showZeroHundred) {
      final a = int.parse(triple[0]);
      final b = int.parse(triple[1]);
      final c = int.parse(triple[2]);
      if (a == 0 && b == 0 && c == 0) {
        return '';
      }
      if (a == 0 && showZeroHundred) {
        return 'không trăm ${readPair(b, c)}';
      }
      if (a == 0 && b == 0) {
        return digits[c];
      }
      if (a == 0 && b != 0) {
        return readPair(b, c);
      }
      return '${digits[a]} trăm ${readPair(b, c)}';
    }

    bool shouldShowZeroHundred(List<List<String>> groups) {
      return groups.reversed.takeWhile((item) => item.join() == '000').length <
          groups.length - 1;
    }

    final stringValue = toString();
    final groups = (zeroLeftPadding[stringValue.length % 3] + stringValue)
        .split('')
        .chunked(3)
        .toList();
    final showZeroHundred = shouldShowZeroHundred(groups);
    return groups
        .foldIndexed('', (index, previous, element) {
          final triple = readTriple(element, showZeroHundred && index > 0);
          final thousand = triple.isNotEmpty
              ? multipleThousand[groups.length - 1 - index]
              : '';
          return '$previous $triple $thousand';
        })
        .replaceAll(RegExp('\\s+'), ' ')
        .trim()
        .toLowerCase()
        .toCapitalized();
  }
}

extension IntExtension on int? {
  String toCountCharactersRemaining({
    required int? maxLength,
  }) =>
      '${this ?? 0}/${maxLength ?? 0}';

  bool get isNotNullAndPositive => this != null && this! > 0;

  bool get isNotNullAndNegative => this != null && this! < 0;
}

extension DoubleExtension on double {
  String get formatBillion {
    // Làm tròn đến 2 chữ số thập phân, nhưng bỏ .00 nếu là số nguyên
    if (this % 1 == 0) {
      return toStringAsFixed(0); // 3 → "3"
    } else {
      return toStringAsFixed(2)
          .replaceFirst(RegExp(r'\.?0+$'), ''); // 3.30 → "3.3", 3.25 → "3.25"
    }
  }
}

extension MoneyFormat on double? {
  String get vnd {
    return (this ?? 0.0)._formatVND(includeTilde: false);
  }

  /// Thêm dấu ~ ở đầu (rất hay dùng khi nhắn tin)
  String get tildeVnd {
    return (this ?? 0.0)._formatVND(includeTilde: true);
  }

  String _formatVND({required bool includeTilde}) {
    double value = this ?? 0.0;
    if (value == 0) return includeTilde ? "~0" : "0";

    // Làm tròn đến 3 chữ số thập phân
    double rounded = (value * 1000).round() / 1000;
    bool isNegative = rounded < 0;
    double abs = rounded.abs();

    String sign = isNegative ? "-" : "";
    String tilde = includeTilde ? "~" : "";

    if (abs >= 1e9) {
      // Từ 1 tỷ trở lên
      double ty = (abs / 1e9 * 1000).round() / 1000;
      double remainingMillion = ((abs % 1e9) / 1e6 * 1000).round() / 1000;

      String tyPart = _cleanNumber(ty); // 5.124, 10, 1.005,...

      if (remainingMillion < 1) {
        // Dưới 1 triệu → không hiện phần triệu
        return "$sign$tilde$tyPart tỷ";
      } else {
        // Có phần triệu → hiện "X tỷ YY triệu"
        String millionPart = remainingMillion.toStringAsFixed(0).padLeft(2, '0');
        return "$sign$tilde$tyPart tỷ $millionPart triệu";
      }
    } else {
      // Dưới 1 tỷ → hiển thị triệu
      double trieu = (abs / 1e6 * 1000).round() / 1000;
      String trieuPart = _cleanNumber(trieu);
      return "$sign$tilde$trieuPart triệu";
    }
  }

  /// Biến 5.120 → "5.12", 5.000 → "5", 5.500 → "5.5"
  String _cleanNumber(double num) {
    String str = num.toStringAsFixed(3);
    str = str.replaceAll(RegExp(r'0+$'), ''); // xóa 0 thừa cuối
    if (str.endsWith('.')) str = str.substring(0, str.length - 1); // xóa dấu . cuối
    return str;
  }
}