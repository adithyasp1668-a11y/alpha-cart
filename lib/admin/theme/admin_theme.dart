import 'package:flutter/material.dart';

abstract final class AdminColors {
  static const base = Color(0xFF0B0D11);
  static const screen = Color(0xFF121517);
  static const card = Color(0xFF19181C);
  static const raised = Color(0xFF24252A);
  static const line = Color(0xFF34363B);
  static const orange = Color(0xFFFB7019);
  static const orangeLight = Color(0xFFFB8319);
  static const green = Color(0xFF27BC37);
  static const red = Color(0xFFF65152);
  static const blue = Color(0xFF2588BE);
  static const purple = Color(0xFF7D3CB9);
  static const yellow = Color(0xFFECBA16);
  static const muted = Color(0xFFB8B8B8);
}

abstract final class AdminTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AdminColors.base,
    colorScheme: const ColorScheme.dark(
      primary: AdminColors.orange,
      secondary: AdminColors.green,
      surface: AdminColors.card,
      error: AdminColors.red,
    ),
    fontFamily: 'Roboto',
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
      fillColor: AdminColors.raised,
      hintStyle: const TextStyle(color: AdminColors.muted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AdminColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AdminColors.orange),
      ),
    ),
  );
}
