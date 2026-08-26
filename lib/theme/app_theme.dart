import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary =
      Color(0xFF6366F1);

  static const Color secondary =
      Color(0xFF06B6D4);

  static const Color accent =
      Color(0xFFF59E0B);

  static const Color success =
      Color(0xFF22C55E);

  static const Color danger =
      Color(0xFFEF4444);

  static const Color background =
      Color(0xFFF7F7FC);

  static const Color textPrimary =
      Color(0xFF20233A);

  static const Color textSecondary =
      Color(0xFF777C92);

  static const Color border =
      Color(0xFFEDEEF5);

  static ThemeData lightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      scaffoldBackgroundColor:
          background,

      fontFamily: 'Roboto',

      appBarTheme: const AppBarTheme(
        backgroundColor:
            background,
        foregroundColor:
            textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight:
              FontWeight.w800,
        ),
      ),

      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(22),
          side: const BorderSide(
            color: border,
          ),
        ),
      ),

      elevatedButtonTheme:
          ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor:
              Colors.white,
          elevation: 0,
          minimumSize:
              const Size.fromHeight(54),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
          textStyle:
              const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ),

      outlinedButtonTheme:
          OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize:
              const Size.fromHeight(54),
          side: const BorderSide(
            color: primary,
            width: 1.5,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(17),
          ),
          textStyle:
              const TextStyle(
            fontSize: 16,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      textButtonTheme:
          TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle:
              const TextStyle(
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor:
            Color(0xFFE8E8F2),
      ),

      dividerTheme:
          const DividerThemeData(
        color: border,
        thickness: 1,
      ),

      snackBarTheme:
          SnackBarThemeData(
        behavior:
            SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),
      ),
    );
  }
}