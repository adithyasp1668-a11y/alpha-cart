import 'package:flutter/material.dart';

abstract final class SellerColors {
  static const base = Color(0xFF0B0D11);
  static const screen = Color(0xFF121517);
  static const card = Color(0xFF19191D);
  static const raised = Color(0xFF24252A);
  static const line = Color(0xFF36383D);
  static const orange = Color(0xFFFB7019);
  static const orangeLight = Color(0xFFFF982E);
  static const green = Color(0xFF22C55E);
  static const red = Color(0xFFF05252);
  static const muted = Color(0xFFB8B8B8);
  static const purple = Color(0xFFB57AE7);
  static const lavender = Color(0xFFE6CFE4);
}

abstract final class SellerTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SellerColors.base,
    colorScheme: const ColorScheme.dark(
      primary: SellerColors.orange,
      secondary: SellerColors.green,
      surface: SellerColors.card,
      error: SellerColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SellerColors.raised,
      hintStyle: const TextStyle(color: SellerColors.muted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SellerColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: SellerColors.orange),
      ),
    ),
  );
}
