import 'package:flutter/material.dart';

/// Paleta oficial do Saúde360.
class Cores {
  static const primary = Color(0xFF002B4B);
  static const secondary = Color(0xFF087DCE);
  static const teal = Color(0xFF00A6B2);
  static const success = Color(0xFF19C65A);
  static const background = Color(0xFFE8F5FA);
  static const white = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: Cores.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: Cores.primary,
      onPrimary: Cores.white,
      secondary: Cores.secondary,
      onSecondary: Cores.white,
      tertiary: Cores.teal,
      onTertiary: Cores.white,
      surface: Cores.white,
      onSurface: Cores.primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: Cores.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Cores.primary,
        foregroundColor: Cores.white,
        centerTitle: true,
      ),
      cardTheme: const CardTheme(
        color: Cores.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Cores.secondary,
        foregroundColor: Cores.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Cores.secondary,
          foregroundColor: Cores.white,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Cores.success : null,
        ),
        checkColor: const WidgetStatePropertyAll(Cores.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Cores.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Cores.teal : null,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Cores.success,
        linearTrackColor: Cores.background,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Cores.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Cores.secondary, width: 2),
        ),
      ),
    );
  }
}
