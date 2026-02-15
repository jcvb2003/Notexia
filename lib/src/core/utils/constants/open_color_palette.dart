import 'package:flutter/material.dart';

/// Representa uma família de cores na paleta Open Colors.
class ColorFamily {
  final String name;
  final List<Color> shades;

  const ColorFamily(this.name, this.shades);

  /// Retorna a cor base (tom médio, índice 2) da família.
  Color get baseColor => shades[2];

  /// Verifica se uma cor pertence a esta família.
  bool contains(Color color) => shades.contains(color);
}

/// Paleta Open Colors com 5 tons por família.
/// Baseado em https://yeun.github.io/open-color/
/// Cada família contém tons nos índices [1, 3, 5, 7, 9] da paleta original.
class OpenColorPalette {
  OpenColorPalette._();

  // ─────────────────────────────────────────────────────────────────────────
  // Cores Neutras Especiais
  // ─────────────────────────────────────────────────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  // ─────────────────────────────────────────────────────────────────────────
  // Definição das Famílias
  // ─────────────────────────────────────────────────────────────────────────

  static const _gray = [
    Color(0xFFF1F3F5), // 1
    Color(0xFFDEE2E6), // 3
    Color(0xFFADB5BD), // 5
    Color(0xFF495057), // 7
    Color(0xFF212529), // 9
  ];

  static const _red = [
    Color(0xFFFFE3E3), // 1
    Color(0xFFFFA8A8), // 3
    Color(0xFFFF6B6B), // 5
    Color(0xFFF03E3E), // 7
    Color(0xFFC92A2A), // 9
  ];

  static const _pink = [
    Color(0xFFFFDEEB), // 1
    Color(0xFFFAA2C1), // 3
    Color(0xFFF06595), // 5
    Color(0xFFD6336C), // 7
    Color(0xFFA61E4D), // 9
  ];

  static const _grape = [
    Color(0xFFF3D9FA), // 1
    Color(0xFFE599F7), // 3
    Color(0xFFCC5DE8), // 5
    Color(0xFFAE3EC9), // 7
    Color(0xFF862E9C), // 9
  ];

  static const _violet = [
    Color(0xFFE5DBFF), // 1
    Color(0xFFB197FC), // 3
    Color(0xFF845EF7), // 5
    Color(0xFF7048E8), // 7
    Color(0xFF5F3DC4), // 9
  ];

  static const _indigo = [
    Color(0xFFDBE4FF), // 1
    Color(0xFF91A7FF), // 3
    Color(0xFF5C7CFA), // 5
    Color(0xFF4263EB), // 7
    Color(0xFF364FC7), // 9
  ];

  static const _blue = [
    Color(0xFFD0EBFF), // 1
    Color(0xFF74C0FC), // 3
    Color(0xFF339AF0), // 5
    Color(0xFF1C7ED6), // 7
    Color(0xFF1864AB), // 9
  ];

  static const _cyan = [
    Color(0xFFC5F6FA), // 1
    Color(0xFF66D9E8), // 3
    Color(0xFF22B8CF), // 5
    Color(0xFF1098AD), // 7
    Color(0xFF0B7285), // 9
  ];

  static const _teal = [
    Color(0xFFC3FAE8), // 1
    Color(0xFF63E6BE), // 3
    Color(0xFF20C997), // 5
    Color(0xFF0CA678), // 7
    Color(0xFF087F5B), // 9
  ];

  static const _green = [
    Color(0xFFD3F9D8), // 1
    Color(0xFF8CE99A), // 3
    Color(0xFF51CF66), // 5
    Color(0xFF37B24D), // 7
    Color(0xFF2B8A3E), // 9
  ];

  static const _lime = [
    Color(0xFFE9FAC8), // 1
    Color(0xFFC0EB75), // 3
    Color(0xFF94D82D), // 5
    Color(0xFF74B816), // 7
    Color(0xFF5C940D), // 9
  ];

  static const _yellow = [
    Color(0xFFFFF3BF), // 1
    Color(0xFFFFE066), // 3
    Color(0xFFFCC419), // 5
    Color(0xFFF59F00), // 7
    Color(0xFFE67700), // 9
  ];

  static const _orange = [
    Color(0xFFFFE8CC), // 1
    Color(0xFFFFC078), // 3
    Color(0xFFFF922B), // 5
    Color(0xFFF76707), // 7
    Color(0xFFD9480F), // 9
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Exposição Pública
  // ─────────────────────────────────────────────────────────────────────────

  // Mantendo compatibilidade com código existente que acessa diretamente
  static const List<Color> gray = _gray;
  static const List<Color> red = _red;
  static const List<Color> pink = _pink;
  static const List<Color> grape = _grape;
  static const List<Color> violet = _violet;
  static const List<Color> indigo = _indigo;
  static const List<Color> blue = _blue;
  static const List<Color> cyan = _cyan;
  static const List<Color> teal = _teal;
  static const List<Color> green = _green;
  static const List<Color> lime = _lime;
  static const List<Color> yellow = _yellow;
  static const List<Color> orange = _orange;

  /// Lista unificada de famílias de cores.
  static const List<ColorFamily> families = [
    ColorFamily('Gray', _gray),
    ColorFamily('Red', _red),
    ColorFamily('Pink', _pink),
    ColorFamily('Grape', _grape),
    ColorFamily('Violet', _violet),
    ColorFamily('Indigo', _indigo),
    ColorFamily('Blue', _blue),
    ColorFamily('Cyan', _cyan),
    ColorFamily('Teal', _teal),
    ColorFamily('Green', _green),
    ColorFamily('Lime', _lime),
    ColorFamily('Yellow', _yellow),
    ColorFamily('Orange', _orange),
  ];

  /// [Deprecated] Use [families] para iterar. Mantido para compatibilidade temporária.
  static List<List<Color>> get allFamilies =>
      families.map((f) => f.shades).toList();

  /// [Deprecated] Use [families] para obter nomes. Mantido para compatibilidade temporária.
  static List<String> get familyNames => families.map((f) => f.name).toList();

  /// Retorna a cor base (tom médio) de cada família.
  static List<Color> get baseColors =>
      families.map((f) => f.baseColor).toList();

  /// Retorna os tons de uma cor específica.
  static List<Color>? getTonesForColor(Color color) {
    for (final family in families) {
      if (family.contains(color)) {
        return family.shades;
      }
    }
    return null;
  }

  /// Encontra o índice da família de uma cor.
  static int getFamilyIndex(Color color) {
    for (int i = 0; i < families.length; i++) {
      if (families[i].contains(color)) {
        return i;
      }
    }
    return -1;
  }
}
