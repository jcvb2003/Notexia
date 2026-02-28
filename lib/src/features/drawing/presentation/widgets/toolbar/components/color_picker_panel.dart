import 'package:flutter/material.dart';
import 'package:notexia/src/features/settings/domain/services/user_colors_storage.dart';
import 'package:notexia/src/app/di/service_locator/service_locator.dart';
import 'package:notexia/src/core/utils/constants/open_color_palette.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker/color_section.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker/custom_color_section.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker/my_colors_section.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker/tones_section.dart';

/// Painel de seleção de cores com 4 seções:
/// - Cor: cores base da paleta
/// - Tons: 5 tons da cor selecionada
/// - Personalizado: color picker HSL + HEX
/// - Minhas Cores: cores salvas pelo usuário
class ColorPickerPanel extends StatefulWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final bool allowTransparent;
  final List<Color>? colorsInUse;

  const ColorPickerPanel({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.allowTransparent = false,
    this.colorsInUse,
  });

  @override
  State<ColorPickerPanel> createState() => _ColorPickerPanelState();
}

class _ColorPickerPanelState extends State<ColorPickerPanel> {
  late Color _activeColor;
  List<Color> _userColors = [];
  bool _isLoadingUserColors = true;

  @override
  void initState() {
    super.initState();
    _activeColor = widget.selectedColor;
    _loadUserColors();
  }

  @override
  void didUpdateWidget(covariant ColorPickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      setState(() {
        _activeColor = widget.selectedColor;
      });
    }
  }

  Future<void> _loadUserColors() async {
    final colors = await sl<UserColorsStorage>().loadUserColors();
    if (mounted) {
      setState(() {
        _userColors = colors;
        _isLoadingUserColors = false;
      });
    }
  }

  Future<void> _saveUserColor(Color color) async {
    await sl<UserColorsStorage>().saveUserColor(color);
    await _loadUserColors();
  }

  Future<void> _removeUserColor(Color color) async {
    await sl<UserColorsStorage>().removeUserColor(color);
    await _loadUserColors();
  }

  void _selectColor(Color color) {
    setState(() {
      _activeColor = color;
    });
    widget.onColorSelected(color);
  }

  @override
  Widget build(BuildContext context) {
    final tones = OpenColorPalette.getTonesForColor(_activeColor);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─────────────────────────────────────────────────────────────────
          // Seção: Cor
          // ─────────────────────────────────────────────────────────────────
          _SectionHeader(title: 'Cor'),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ColorSection(
              selectedColor: _activeColor,
              onColorSelected: _selectColor,
              allowTransparent: widget.allowTransparent,
            ),
          ),

          // ─────────────────────────────────────────────────────────────────
          // Seção: Tons
          // ─────────────────────────────────────────────────────────────────
          if (tones != null) ...[
            _SectionHeader(title: 'Tons'),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TonesSection(
                tones: tones,
                selectedColor: _activeColor,
                onColorSelected: _selectColor,
              ),
            ),
          ],

          // ─────────────────────────────────────────────────────────────────
          // Seção: Personalizado
          // ─────────────────────────────────────────────────────────────────
          _SectionHeader(title: 'Personalizado'),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CustomColorSection(
              initialColor: _activeColor,
              onColorSelected: _selectColor,
              onColorSaved: _saveUserColor,
            ),
          ),

          // ─────────────────────────────────────────────────────────────────
          // Seção: Minhas Cores
          // ─────────────────────────────────────────────────────────────────
          _SectionHeader(title: 'Minhas Cores'),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _isLoadingUserColors
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : MyColorsSection(
                    userColors: _userColors,
                    colorsInUse: widget.colorsInUse ?? [],
                    selectedColor: _activeColor,
                    onColorSelected: _selectColor,
                    onColorRemoved: _removeUserColor,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header de Seção Expansível
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: context.typography.labelMedium?.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
