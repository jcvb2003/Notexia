import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/core/utils/constants/open_color_palette.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker_panel.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/common_controls.dart';

class TextToolControls extends StatelessWidget {
  const TextToolControls({super.key});

  @override
  Widget build(BuildContext context) {
    final (textElement, currentStyle) =
        context.select<CanvasCubit, (TextElement?, ElementStyle)>((cubit) {
      final state = cubit.state;
      final selectedIds = state.selectedElementIds;
      TextElement? element;
      if (selectedIds.isNotEmpty) {
        final selectedId = selectedIds.first;
        final found =
            state.elements.where((e) => e.id == selectedId).firstOrNull;
        if (found is TextElement) element = found;
      }
      return (element, state.currentStyle);
    });
    final cubit = context.read<CanvasCubit>();
    final currentAlign = textElement?.textAlign ?? TextAlign.left;

    return Row(
      children: [
        Tooltip(
          message: 'Cor e Estilo',
          child: GestureDetector(
            onTap: () => _showStylePopover(context, cubit),
            child: ColorSwatchChip(
              color: textElement?.strokeColor ?? currentStyle.strokeColor,
            ),
          ),
        ),
        const ToolbarDivider(horizontalPadding: 4),
        AppIconButton(
          size: 36,
          icon: LucideIcons.bold,
          tooltip: 'Negrito',
          isActive: textElement?.isBold ?? false,
          onTap: () => cubit.updateSelectedElementsProperties(
            isBold: !(textElement?.isBold ?? false),
          ),
        ),
        AppIconButton(
          size: 36,
          icon: LucideIcons.italic,
          tooltip: 'Itálico',
          isActive: textElement?.isItalic ?? false,
          onTap: () => cubit.updateSelectedElementsProperties(
            isItalic: !(textElement?.isItalic ?? false),
          ),
        ),
        AppIconButton(
          size: 36,
          icon: LucideIcons.underline,
          tooltip: 'Sublinhado',
          isActive: textElement?.isUnderlined ?? false,
          onTap: () => cubit.updateSelectedElementsProperties(
            isUnderlined: !(textElement?.isUnderlined ?? false),
          ),
        ),
        AppIconButton(
          size: 36,
          icon: LucideIcons.strikethrough,
          tooltip: 'Tachado',
          isActive: textElement?.isStrikethrough ?? false,
          onTap: () => cubit.updateSelectedElementsProperties(
            isStrikethrough: !(textElement?.isStrikethrough ?? false),
          ),
        ),
        const ToolbarDivider(horizontalPadding: 4),
        AppIconButton(
          size: 36,
          icon: LucideIcons.languages,
          tooltip: 'Fonte: ${textElement?.fontFamily ?? "Virgil"}',
          onTap: () {},
        ),
        AppIconButton(
          size: 36,
          icon: LucideIcons.scaling,
          tooltip: 'Tamanho: ${textElement?.fontSize.toInt() ?? 20}',
          onTap: () {},
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              size: 36,
              icon: switch (currentAlign) {
                TextAlign.center => LucideIcons.alignCenter,
                TextAlign.right => LucideIcons.alignRight,
                _ => LucideIcons.alignLeft,
              },
              tooltip: switch (currentAlign) {
                TextAlign.center => 'Centralizado',
                TextAlign.right => 'Alinhar à direita',
                _ => 'Alinhar à esquerda',
              },
              onTap: () {
                final nextAlign = switch (currentAlign) {
                  TextAlign.left => TextAlign.center,
                  TextAlign.center => TextAlign.right,
                  _ => TextAlign.left,
                };
                cubit.updateSelectedElementsProperties(textAlign: nextAlign);
              },
            ),
            const SizedBox(height: 1),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AlignIndicator(isActive: currentAlign == TextAlign.left),
                const SizedBox(width: 2),
                _AlignIndicator(isActive: currentAlign == TextAlign.center),
                const SizedBox(width: 2),
                _AlignIndicator(isActive: currentAlign == TextAlign.right),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showStylePopover(BuildContext context, CanvasCubit cubit) {
    showModularSheet(
      context,
      title: 'Cor e Estilo',
      child: BlocProvider.value(
        value: cubit,
        child: TabbedStyleEditor(
          tabs: {
            'Texto': BlocBuilder<CanvasCubit, CanvasState>(
              builder: (context, state) {
                final selectedIds = state.selectedElementIds;
                TextElement? element;
                if (selectedIds.isNotEmpty) {
                  final selectedId = selectedIds.first;
                  final found = state.elements
                      .where((e) => e.id == selectedId)
                      .firstOrNull;
                  if (found is TextElement) element = found;
                }
                final currentStyle = state.currentStyle;

                return Column(
                  children: [
                    ColorPickerPanel(
                      selectedColor:
                          element?.strokeColor ?? currentStyle.strokeColor,
                      onColorSelected: (c) => cubit
                          .updateSelectedElementsProperties(strokeColor: c),
                    ),
                  ],
                );
              },
            ),
            'Fundo': BlocBuilder<CanvasCubit, CanvasState>(
              builder: (context, state) {
                final selectedIds = state.selectedElementIds;
                TextElement? element;
                if (selectedIds.isNotEmpty) {
                  final selectedId = selectedIds.first;
                  final found = state.elements
                      .where((e) => e.id == selectedId)
                      .firstOrNull;
                  if (found is TextElement) element = found;
                }

                return Column(
                  children: [
                    ColorPickerPanel(
                      selectedColor: element?.backgroundColor ??
                          OpenColorPalette.transparent,
                      allowTransparent: true,
                      onColorSelected: (c) {
                        if (c == OpenColorPalette.transparent) {
                          cubit.updateSelectedElementsProperties(
                            backgroundColor: null,
                          );
                          return;
                        }
                        cubit.updateSelectedElementsProperties(
                          backgroundColor: c,
                        );
                      },
                    ),
                    const Divider(height: 32),
                    PropertySlider(
                      label: 'Raio do canto',
                      value: element?.backgroundRadius ?? 4.0,
                      min: 0,
                      max: 32,
                      onChanged: (v) => cubit.updateSelectedElementsProperties(
                        backgroundRadius: v,
                      ),
                    ),
                  ],
                );
              },
            ),
          },
        ),
      ),
    );
  }
}

class _AlignIndicator extends StatelessWidget {
  final bool isActive;

  const _AlignIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.primary : AppColors.border,
      ),
    );
  }
}
