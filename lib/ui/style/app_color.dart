import 'package:flutter/material.dart';

// Custom Color Palettes
class AppColors {

  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryPurple = Color(0xFF9C27B0);
  static const Color primaryGreen = Color(0xFF4CAF50);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryRed = Color(0xFFE91E63);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightPrimary = primaryBlue;
  static const Color lightSecondary = Color(0xFF03DAC6);
  static const Color lightOnPrimary = Colors.white;
  static const Color lightOnSecondary = Colors.black;
  static const Color lightOnSurface = Color(0xFF1C1C1C);
  static const Color lightOnBackground = Color(0xFF1C1C1C);
  static const Color lightError = Color(0xFFB00020);
  static const Color lightOnError = Colors.white;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkPrimary = Color(0xFF64B5F6);
  static const Color darkSecondary = Color(0xFF03DAC6);
  static const Color darkOnPrimary = Colors.black;
  static const Color darkOnSecondary = Colors.black;
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnBackground = Color(0xFFE0E0E0);
  static const Color darkError = Color(0xFFCF6679);
  static const Color darkOnError = Colors.black;

  // Custom Color Schemes
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: lightPrimary,
    onPrimary: lightOnPrimary,
    secondary: lightSecondary,
    onSecondary: lightOnSecondary,
    error: lightError,
    onError: lightOnError,
    background: lightBackground,
    onBackground: lightOnBackground,
    surface: lightSurface,
    onSurface: lightOnSurface,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    error: darkError,
    onError: darkOnError,
    background: darkBackground,
    onBackground: darkOnBackground,
    surface: darkSurface,
    onSurface: darkOnSurface,
  );

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF21CBF3),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1E1E1E),
    Color(0xFF3C3C3C),
  ];

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color danger = Color(0xFFF44336);

  // Text Colors
  static const Color lightTextPrimary = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);
  static const Color lightTextDisabled = Color(0xFFBDBDBD);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextDisabled = Color(0xFF666666);
}

// Custom extension to add more colors to ThemeData
extension CustomColors on ThemeData {
  Color get success => brightness == Brightness.light
      ? AppColors.success
      : AppColors.success.withOpacity(0.8);

  Color get warning => brightness == Brightness.light
      ? AppColors.warning
      : AppColors.warning.withOpacity(0.8);

  Color get info => brightness == Brightness.light
      ? AppColors.info
      : AppColors.info.withOpacity(0.8);

  Color get danger => brightness == Brightness.light
      ? AppColors.danger
      : AppColors.danger.withOpacity(0.8);

  Color get cardBackground => brightness == Brightness.light
      ? AppColors.lightCard
      : AppColors.darkCard;

  List<Color> get primaryGradient => brightness == Brightness.light
      ? AppColors.primaryGradient
      : AppColors.darkGradient;
}