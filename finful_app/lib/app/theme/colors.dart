import 'package:flutter/material.dart';

class FinfulColor {
  FinfulColor._();

  static const int _bluePrimaryValue = 0xFF00ACB8;
  static const Color blue50  = Color(0xFFE7F5F7);
  static const Color blue100 = Color(0xFFC4E7EB);
  static const Color blue200 = Color(0xFF9FD7DD);
  static const Color blue300 = Color(0xFF73C5CD);
  static const Color blue400 = Color(0xFF4EB3BC);
  static const Color blue500 = Color(0xFF3DA1AF);
  static const Color blue600 = Color(0xFF2E7E8A);
  static const Color blue700 = Color(0xFF225C66);
  static const Color blue800 = Color(0xFF153D45);
  static const Color blue900 = Color(0xFF0B2227);

  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      50: blue50,
      100: blue100,
      200: blue200,
      300: blue300,
      400: blue400,
      500: blue500,
      600: blue600,
      700: blue700,
      800: blue800,
      900: blue900,
    },
  );

  static const int _yellowPrimaryValue = 0xFFF5C451;
  static const Color yellow50  = Color(0xFFFFF9E5);
  static const Color yellow100 = Color(0xFFFFF1BF);
  static const Color yellow200 = Color(0xFFFFE394);
  static const Color yellow300 = Color(0xFFFDD667);
  static const Color yellow400 = Color(0xFFFAC947);
  static const Color yellow500 = Color(0xFFF5C451);
  static const Color yellow600 = Color(0xFFDBA523);
  static const Color yellow700 = Color(0xFFB17F10);
  static const Color yellow800 = Color(0xFF7E5A05);
  static const Color yellow900 = Color(0xFF4D3600);

  static const MaterialColor yellow = MaterialColor(
    _yellowPrimaryValue,
    <int, Color>{
      50: yellow50,
      100: yellow100,
      200: yellow200,
      300: yellow300,
      400: yellow400,
      500: yellow500,
      600: yellow600,
      700: yellow700,
      800: yellow800,
      900: yellow900,
    },
  );

  static const Color btnAuth = Color(0xFF2BBDC7);
  static const Color grey = Color(0xFF6C7278);
  static const Color stroke = Color(0xFFEDF1F3);
  static const Color grey2 = Color(0xFF8B8B84);
  static final Color grey3 = Color(0xFFC7C6C8);
  static const Color information500 = Color(0xFF4D81E7);
  static const Color btnBorderSocial = Color(0xFF3E3E3E);
  static const Color cardBorder = Color(0xFF3E3E3E);
  static const Color btnBgSocial = Color(0xFF1D1E21);
  static const Color cardBg = Color(0xFF1D1E21);

  static const Color black12 = Color(0xFF121212);
  static const Color white = Colors.white;
  static const Color bgDisabled = Color(0xFF1D1E21);
  static const Color btnTextInBlack = Color(0xFF55504F);
  static final Color textOpacity50 = Colors.white.withValues(alpha: 0.5);
  static final Color bgOpacity25 = Colors.white.withValues(alpha: 0.25);
  static final Color inputBorderDefault = Colors.white.withValues(alpha: 0.25);

  static final Color textBOpacity80 = black12.withValues(alpha: 0.8);
  static final Color textWOpacity80 = white.withValues(alpha: 0.8);
  static final Color textWOpacity70 = white.withValues(alpha: 0.7);
  static final Color textWOpacity60 = white.withValues(alpha: 0.6);
  static final Color textW = Colors.white;

  static const Color brandPrimary = Color(_bluePrimaryValue);
  static const Color brandSecondary = Color(_yellowPrimaryValue);
  static const Color success = Color(0xFF429E71);
  static const Color danger = Color(0xFFE47C71);
  static const Color error = Color(0xFFE63B13);
  static const Color disabled = Color(0xFF5C5B56);
  static const Color progressBarBackground = Color(0xFF5C5B56);
  static const Color progressBarForeground = Color(_bluePrimaryValue);
  static const Color btnPrimary = Color(_bluePrimaryValue);

  // slider
  static const Color sliderActiveTrack = brandPrimary;
  static const Color sliderInactiveTrack = Color(0xFF333333);
  static const Color sliderThumbColor = white;
  static const Color sliderOverlayColor = brandPrimary;

  static const Color backgroundLight = Color(0xFFF5F6FD);

  static const Color textFieldBgColor = Color(0xFF1D1E21);

  // skeleton
  static const Color blackBaseSkeletonColor = Color(0xFF1E1E1E);
  static const Color blackHighLightSkeletonColor = Color(0xFF333333);

  // chart
  static final Color dotGlowLayer1 = brandPrimary.withValues(alpha: 0.25);
  static final Color lineChartText = white.withValues(alpha: 0.8);
  static final Color barChartDot = white.withValues(alpha: 0.3);
  static const Color barChartContentBorrow = Color(0xFFFFC344);
  static final Color barChartText = white.withValues(alpha: 0.8);
}
