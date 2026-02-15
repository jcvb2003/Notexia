import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserColorsStorage {
  static const String _key = 'user_custom_colors';
  static const int _maxColors = 12;

  static final UserColorsStorage _instance = UserColorsStorage._internal();
  factory UserColorsStorage() => _instance;
  UserColorsStorage._internal();

  SharedPreferences? _prefs;
  List<Color> _inMemoryColors = [];

  Future<void> _ensureInitialized() async {
    if (_prefs != null) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      final stored = _prefs!.getStringList(_key) ?? [];
      _inMemoryColors = stored.map((hex) => _hexToColor(hex)).toList();
    } on MissingPluginException {
      _prefs = null;
    }
  }

  Future<List<Color>> loadUserColors() async {
    await _ensureInitialized();
    if (_prefs == null) {
      return List<Color>.from(_inMemoryColors);
    }
    final stored = _prefs!.getStringList(_key) ?? [];
    _inMemoryColors = stored.map((hex) => _hexToColor(hex)).toList();
    return List<Color>.from(_inMemoryColors);
  }

  Future<void> saveUserColor(Color color) async {
    await _ensureInitialized();
    final colors = await loadUserColors();
    final hex = _colorToHex(color);

    colors.removeWhere((c) => _colorToHex(c) == hex);
    colors.insert(0, color);

    if (colors.length > _maxColors) {
      colors.removeLast();
    }

    final hexList = colors.map((c) => _colorToHex(c)).toList();
    _inMemoryColors = List<Color>.from(colors);
    if (_prefs != null) {
      await _prefs!.setStringList(_key, hexList);
    }
  }

  Future<void> removeUserColor(Color color) async {
    await _ensureInitialized();
    final colors = await loadUserColors();
    final hex = _colorToHex(color);

    colors.removeWhere((c) => _colorToHex(c) == hex);

    final hexList = colors.map((c) => _colorToHex(c)).toList();
    _inMemoryColors = List<Color>.from(colors);
    if (_prefs != null) {
      await _prefs!.setStringList(_key, hexList);
    }
  }

  Future<void> clearUserColors() async {
    await _ensureInitialized();
    _inMemoryColors = [];
    if (_prefs != null) {
      await _prefs!.remove(_key);
    }
  }

  String _colorToHex(Color color) {
    return color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex, radix: 16));
  }
}
