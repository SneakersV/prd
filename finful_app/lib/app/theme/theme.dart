import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/constants/dimensions.dart';
import 'colors.dart';
import 'dimens.dart';

export 'colors.dart';
export 'dimens.dart';

const _kFontFamily = 'Inter';

class FinfulTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_16,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: Dimens.p_18,
      fontWeight: FontWeight.w500,
      height: Dimens.p_24 / Dimens.p_18,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    displayLarge: TextStyle(
      fontSize: Dimens.p_30,
      height: Dimens.p_38 / Dimens.p_30,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: Dimens.p_24,
      height: Dimens.p_32 / Dimens.p_24,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: Dimens.p_20,
      height: Dimens.p_28 / Dimens.p_20,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_16,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: Dimens.p_14,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_14,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: Dimens.p_12,
      fontWeight: FontWeight.w500,
      height: Dimens.p_16 / Dimens.p_12,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textBOpacity80,
      fontFamily: _kFontFamily,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_16,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w600,
      height: Dimens.p_20 / Dimens.p_16,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    displayLarge: TextStyle(
      fontSize: Dimens.p_32,
      height: Dimens.p_25 / Dimens.p_32,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    displayMedium: TextStyle(
      fontSize: Dimens.p_22,
      height: Dimens.p_28 / Dimens.p_22,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    displaySmall: TextStyle(
      fontSize: Dimens.p_18,
      height: Dimens.p_25 / Dimens.p_18,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_16,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    headlineSmall: TextStyle(
      fontSize: Dimens.p_14,
      fontWeight: FontWeight.w500,
      height: Dimens.p_20 / Dimens.p_14,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    titleLarge: TextStyle(
      fontSize: Dimens.p_12,
      fontWeight: FontWeight.w500,
      height: Dimens.p_16 / Dimens.p_12,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: Dimens.p_16,
      fontWeight: FontWeight.w600,
      color: FinfulColor.textW,
      fontFamily: _kFontFamily,
    ),
  );

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.brandPrimary,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.danger,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.danger,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.brandPrimary,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.danger,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.danger,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: Dimens.p_1,
        style: BorderStyle.solid,
        color: FinfulColor.inputBorderDefault,
      ),
      borderRadius: BorderRadius.all(Radius.circular(FinfulDimens.radiusMd)),
    ),
  );

  static ThemeData light() {
    return ThemeData(
      fontFamily: _kFontFamily,
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          return Colors.black;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      scaffoldBackgroundColor: FinfulColor.white,
      textTheme: lightTextTheme,
      primaryColor: FinfulColor.brandPrimary,
      inputDecorationTheme: lightInputDecorationTheme,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      fontFamily: _kFontFamily,
      brightness: Brightness.dark,
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          return Colors.white;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // For Android (light icons)
          statusBarBrightness: Brightness.dark, // For iOS (light icons)
        ),
      ),
      scaffoldBackgroundColor: FinfulColor.black12,
      textTheme: darkTextTheme,
      primaryColor: FinfulColor.brandPrimary,
      inputDecorationTheme: darkInputDecorationTheme,
    );
  }
}
