import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class NotexiaTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.canvasBackground,
      ),
      scaffoldBackgroundColor: AppColors.canvasBackground,
      textTheme: AppTypography.textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.textTheme.titleLarge,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.border,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTypography.textTheme.bodyMedium,
        labelStyle: AppTypography.textTheme.bodyMedium,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
