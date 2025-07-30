import 'package:flutter/material.dart';
import 'typography.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    canvasColor: AppColors.darkBackground,
    cardColor: AppColors.surface,    
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTypography.smallText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: const Color.fromARGB(255, 77, 77, 77),
          width: 1,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineSmall: AppTypography.headline, // 18px semibold
      bodyMedium: AppTypography.subtitle, // 13px regular
      bodySmall: AppTypography.smallText, // 12px regular
      labelMedium: AppTypography.tabLabel, // 15px medium
      labelSmall: AppTypography.underlinedText, // 13px underlined
    ),
  );
}
