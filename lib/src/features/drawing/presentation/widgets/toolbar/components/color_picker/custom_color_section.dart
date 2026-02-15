import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Seção de cor personalizada com picker HSL e entrada HEX.
class CustomColorSection extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<Color> onColorSaved;

  const CustomColorSection({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
    required this.onColorSaved,
  });

  @override
  State<CustomColorSection> createState() => _CustomColorSectionState();
}

class _CustomColorSectionState extends State<CustomColorSection> {
  late HSLColor _hslColor;
  late TextEditingController _hexController;
  bool _showSliders = false;

  @override
  void initState() {
    super.initState();
    _hslColor = HSLColor.fromColor(widget.initialColor);
    _hexController = TextEditingController(
      text: _colorToHex(widget.initialColor),
    );
  }

  @override
  void didUpdateWidget(covariant CustomColorSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _hslColor = HSLColor.fromColor(widget.initialColor);
      _hexController.text = _colorToHex(widget.initialColor);
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  Color? _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length != 6) return null;
    try {
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  void _updateColor(HSLColor hsl) {
    setState(() {
      _hslColor = hsl;
      _hexController.text = _colorToHex(hsl.toColor());
    });
    widget.onColorSelected(hsl.toColor());
  }

  void _setColorFromHex(String value) {
    final color = _hexToColor(value);
    if (color != null) {
      setState(() {
        _hslColor = HSLColor.fromColor(color);
      });
      widget.onColorSelected(color);
    }
  }

  void _onHexSubmitted(String value) {
    final color = _hexToColor(value);
    if (color != null) {
      _updateColor(HSLColor.fromColor(color));
    } else {
      // Restaura o valor anterior
      _hexController.text = _colorToHex(_hslColor.toColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _hslColor.toColor();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.subtle,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (!_showSliders) {
                    setState(() => _showSliders = true);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: currentColor.withValues(alpha: 0.35),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _hexController,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      fillColor: AppColors.background,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[#0-9A-Fa-f]'),
                      ),
                      LengthLimitingTextInputFormatter(7),
                    ],
                    onChanged: (value) {
                      if (value.length == 6 || value.length == 7) {
                        _setColorFromHex(value);
                      }
                    },
                    onSubmitted: _onHexSubmitted,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: () => widget.onColorSaved(currentColor),
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Salvar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showSliders) ...[
          const SizedBox(height: 16),
          _buildLabel('Matiz'),
          const SizedBox(height: 4),
          _HueSlider(
            hue: _hslColor.hue,
            onChanged: (hue) => _updateColor(_hslColor.withHue(hue)),
          ),
          const SizedBox(height: 12),
          _buildLabel('Saturação'),
          const SizedBox(height: 4),
          _GradientSlider(
            value: _hslColor.saturation,
            startColor: _hslColor.withSaturation(0).toColor(),
            endColor: _hslColor.withSaturation(1).toColor(),
            onChanged: (s) => _updateColor(_hslColor.withSaturation(s)),
          ),
          const SizedBox(height: 12),
          _buildLabel('Luminosidade'),
          const SizedBox(height: 4),
          _GradientSlider(
            value: _hslColor.lightness,
            startColor: Colors.black,
            endColor: Colors.white,
            middleColor: _hslColor.withLightness(0.5).toColor(),
            onChanged: (l) => _updateColor(_hslColor.withLightness(l)),
          ),
        ],
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slider de Matiz (arco-íris)
// ─────────────────────────────────────────────────────────────────────────────
class _HueSlider extends StatelessWidget {
  final double hue;
  final ValueChanged<double> onChanged;

  const _HueSlider({required this.hue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newHue =
                (details.localPosition.dx / constraints.maxWidth * 360).clamp(
                  0.0,
                  360.0,
                );
            onChanged(newHue);
          },
          onTapDown: (details) {
            final newHue =
                (details.localPosition.dx / constraints.maxWidth * 360).clamp(
                  0.0,
                  360.0,
                );
            onChanged(newHue);
          },
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF0000),
                  Color(0xFFFFFF00),
                  Color(0xFF00FF00),
                  Color(0xFF00FFFF),
                  Color(0xFF0000FF),
                  Color(0xFFFF00FF),
                  Color(0xFFFF0000),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: (hue / 360 * constraints.maxWidth) - 8,
                  top: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: HSLColor.fromAHSL(1, hue, 1, 0.5).toColor(),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slider com Gradiente
// ─────────────────────────────────────────────────────────────────────────────
class _GradientSlider extends StatelessWidget {
  final double value;
  final Color startColor;
  final Color endColor;
  final Color? middleColor;
  final ValueChanged<double> onChanged;

  const _GradientSlider({
    required this.value,
    required this.startColor,
    required this.endColor,
    this.middleColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = middleColor != null
        ? [startColor, middleColor!, endColor]
        : [startColor, endColor];

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newValue = (details.localPosition.dx / constraints.maxWidth)
                .clamp(0.0, 1.0);
            onChanged(newValue);
          },
          onTapDown: (details) {
            final newValue = (details.localPosition.dx / constraints.maxWidth)
                .clamp(0.0, 1.0);
            onChanged(newValue);
          },
          child: Container(
            height: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: colors),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: (value * constraints.maxWidth) - 8,
                  top: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Color.lerp(startColor, endColor, value),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
