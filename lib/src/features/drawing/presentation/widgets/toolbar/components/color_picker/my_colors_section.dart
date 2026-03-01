import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

/// Seção de cores salvas pelo usuário + cores em uso nos elementos selecionados.
class MyColorsSection extends StatelessWidget {
  final List<Color> userColors;
  final List<Color> colorsInUse;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<Color> onColorRemoved;

  const MyColorsSection({
    super.key,
    required this.userColors,
    required this.colorsInUse,
    required this.selectedColor,
    required this.onColorSelected,
    required this.onColorRemoved,
  });

  @override
  Widget build(BuildContext context) {
    // Combina cores em uso + cores salvas, removendo duplicatas
    final allColors = <Color>{...colorsInUse, ...userColors}.toList();

    if (allColors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Text(
            'Nenhuma cor salva ainda.\nUse a seção "Personalizado" para adicionar.',
            textAlign: TextAlign.center,
            style: context.caption,
          ),
        ),
      );
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: allColors.map((color) {
        final isSelected = color == selectedColor;
        final isSaved = userColors.contains(color);

        return _MyColorSwatch(
          color: color,
          isSelected: isSelected,
          canRemove: isSaved,
          onTap: () => onColorSelected(color),
          onRemove: () => onColorRemoved(color),
        );
      }).toList(),
    );
  }
}

class _MyColorSwatch extends StatefulWidget {
  final Color color;
  final bool isSelected;
  final bool canRemove;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _MyColorSwatch({
    required this.color,
    required this.isSelected,
    required this.canRemove,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<_MyColorSwatch> createState() => _MyColorSwatchState();
}

class _MyColorSwatchState extends State<_MyColorSwatch> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.canRemove ? widget.onRemove : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.isSelected ? AppColors.primary : Colors.transparent,
              width: widget.isSelected ? 2 : 0,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: _isHovered && widget.canRemove
              ? GestureDetector(
                  onTap: widget.onRemove,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Icon(LucideIcons.x, size: 14, color: Colors.white),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
