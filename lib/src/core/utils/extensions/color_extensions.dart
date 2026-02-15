import 'package:flutter/material.dart';

/// Extensions para manipulação de cores.
extension ColorExtensions on Color {
  /// Retorna a cor com alpha ajustado (0.0 a 1.0).
  Color withAlphaValue(double alpha) {
    return withValues(alpha: alpha);
  }

  /// Converte para string hexadecimal (sem #).
  String toHex({bool includeAlpha = false}) {
    if (includeAlpha) {
      return '${(a * 255).round().toRadixString(16).padLeft(2, '0')}'
          '${(r * 255).round().toRadixString(16).padLeft(2, '0')}'
          '${(g * 255).round().toRadixString(16).padLeft(2, '0')}'
          '${(b * 255).round().toRadixString(16).padLeft(2, '0')}';
    }
    return '${(r * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(g * 255).round().toRadixString(16).padLeft(2, '0')}'
        '${(b * 255).round().toRadixString(16).padLeft(2, '0')}';
  }

  /// Clareia a cor por uma porcentagem (0.0 a 1.0).
  Color lighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Escurece a cor por uma porcentagem (0.0 a 1.0).
  Color darken(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

/// Cria uma cor a partir de string hexadecimal.
Color hexToColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  return Color(int.parse(hex, radix: 16));
}
