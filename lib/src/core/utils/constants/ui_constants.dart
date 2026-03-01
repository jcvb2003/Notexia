import 'package:flutter/material.dart';

/// Constantes de UI centralizadas do design system.
class AppColors {
  AppColors._();

  // Cores Primárias
  static const Color primary = Color(0xFF9D88EF);
  static const Color primaryLight = Color(0xFFB8A7F5);
  static const Color primaryDark = Color(0xFF7B6BC7);
  static const Color primaryAccent = Color(0xFF6965DB);

  // Tons de Cinza (Gray Palette)
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF3F4F6);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);

  // Cores Funcionais
  static const Color background = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);
  static const Color black = Color(0xFF000000);
  static const Color canvasBackground = Color(0xFFF8FAFC);
  static const Color sidebarBackground = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFF2F3F5);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color info = Color(0xFF3B82F6);
  static const Color success = Color(0xFF0DB47D);
  static const Color successBackground = Color(0xFFE6FCF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Tokens de Seleção Semânticos
  static const Color selectedBackground = primary;
  static const Color selectedForeground = iconActive;

  // Cores de Ícones
  static const Color iconActive = Color(0xFFFFFFFF);
  static const Color iconDefault = Color(0xFF4B5563);
  static const Color iconMuted = Color(0xFF9CA3AF);

  // Paleta para seleção rápida
  static const Color paletteNeutral = Color(0xFF1E1E1E);
  static const Color paletteNeutralLight = Color(0xFF343A40);
  static const Color paletteRed = Color(0xFFE03131);
  static const Color paletteOrange = Color(0xFFF08C00);
  static const Color paletteYellow = Color(0xFFF59F00);
  static const Color paletteGreen = Color(0xFF2F9E44);
  static const Color paletteTeal = Color(0xFF0C8599);
  static const Color paletteBlue = Color(0xFF1971C2);
  static const Color paletteIndigo = Color(0xFF364FC7);
  static const Color palettePurple = Color(0xFF5F3DC4);
  static const Color palettePink = Color(0xFFC2255C);

  static const List<Color> palette = [
    paletteNeutral,
    paletteNeutralLight,
    paletteRed,
    paletteOrange,
    paletteYellow,
    paletteGreen,
    paletteTeal,
    paletteBlue,
    paletteIndigo,
    palettePurple,
    palettePink,
  ];
}

class AppTypography {
  AppTypography._();

  static TextTheme get textTheme {
    return const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      ),
    );
  }

  // Presets customizados fora do padrão TextTheme
  static const TextStyle labelMuted = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle monoInput = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
}

class AppThemeColors {
  const AppThemeColors();

  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textMuted => AppColors.textMuted;
  Color get surface => AppColors.surface;
  Color get background => AppColors.background;
  Color get border => AppColors.border;
  Color get primary => AppColors.primary;
  Color get primaryAccent => AppColors.primaryAccent;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get danger => AppColors.danger;
  Color get selectedBackground => AppColors.selectedBackground;
  Color get selectedForeground => AppColors.selectedForeground;
}

extension AppThemeContext on BuildContext {
  AppThemeColors get colors => const AppThemeColors();
  TextTheme get typography => Theme.of(this).textTheme;

  // Atalhos para presets adicionais
  TextStyle get labelMuted => AppTypography.labelMuted;
  TextStyle get monoInput => AppTypography.monoInput;
  TextStyle get caption => AppTypography.caption;
}

/// Espaçamentos padrão do design system.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

// Tamanhos padrão de elementos.
class AppSizes {
  AppSizes._();

  static const double headerHeight = 60.0;

  // Botões
  static const double buttonSmall = 32;
  static const double buttonMedium = 40;
  static const double buttonLarge = 44;

  // Toolbars
  static const double toolbarHeight = 44.0;
  static const double toolbarGap = 6.0;

  // Sidebar
  static const double sidebarWidth = 320.0;
  static const double sidebarWidthMobile = 305.0;

  // Ícones
  static const double iconSmall = 16;
  static const double iconMedium = 18;
  static const double iconLarge = 20;

  // Raios de borda
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusRound = 24;
}

/// Sombras padrão reutilizáveis.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Tempos e durações padrão do design system.
class AppDurations {
  AppDurations._();

  static const Duration menuTransition = Duration(milliseconds: 150);
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
