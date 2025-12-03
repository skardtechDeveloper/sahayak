import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme - Pure Material 3
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0066CC),
      brightness: Brightness.light,
    ),
  );

  // Dark Theme - Pure Material 3
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF4DABF5),
      brightness: Brightness.dark,
    ),
  );

  // Custom colors
  static const Color primaryColor = Color(0xFF0066CC);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xFF1976D2);
  static const Color nepaliRed = Color(0xFFDC143C);
  static const Color nepaliBlue = Color(0xFF003893);

  // Text styles
  static TextStyle nepaliTextStyle = const TextStyle(
    fontFamily: 'NotoSansDevanagari',
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle nepaliBoldTextStyle = const TextStyle(
    fontFamily: 'NotoSansDevanagari',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static TextStyle englishTextStyle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );

  static TextStyle englishBoldTextStyle = const TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  // Padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets mediumPadding = EdgeInsets.all(12);
  static const EdgeInsets largePadding = EdgeInsets.all(24);

  // Border radius
  static BorderRadius defaultBorderRadius = BorderRadius.circular(12);
  static BorderRadius smallBorderRadius = BorderRadius.circular(6);
  static BorderRadius mediumBorderRadius = BorderRadius.circular(8);
  static BorderRadius largeBorderRadius = BorderRadius.circular(16);

  // Animation durations
  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration slowDuration = Duration(milliseconds: 500);
}
