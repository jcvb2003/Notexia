import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/utils/constants/open_color_palette.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
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
          message: 'Propriedades',
          child: GestureDetector(
            onTap: () => _showStylePopover(context, cubit),
            child: ColorSwatchChip(
              color: textElement?.strokeColor ?? currentStyle.strokeColor,
            ),
          ),
        ),
        const AppDivider.toolbar(horizontalPadding: 4),
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
        const AppDivider.toolbar(horizontalPadding: 4),
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
                AppIndicator(isActive: currentAlign == TextAlign.left),
                const SizedBox(width: 2),
                AppIndicator(isActive: currentAlign == TextAlign.center),
                const SizedBox(width: 2),
                AppIndicator(isActive: currentAlign == TextAlign.right),
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
      title: 'Propriedades',
      child: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<CanvasCubit, CanvasState>(
          builder: (context, state) {
            final selectedIds = state.selectedElementIds;
            TextElement? element;
            if (selectedIds.isNotEmpty) {
              final selectedId = selectedIds.first;
              final found =
                  state.elements.where((e) => e.id == selectedId).firstOrNull;
              if (found is TextElement) element = found;
            }
            final currentStyle = state.currentStyle;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabbedStyleEditor(
                  tabs: {
                    'Texto': Column(
                      children: [
                        ColorPickerPanel(
                          selectedColor:
                              element?.strokeColor ?? currentStyle.strokeColor,
                          onColorSelected: (c) => cubit
                              .updateSelectedElementsProperties(strokeColor: c),
                        ),
                        const Divider(height: 24),
                        AppSectionBlock(
                          title: 'Tamanho',
                          padding: EdgeInsets.zero,
                          headerTrailing: Text(
                            AppPropertySlider.formatValue(
                                element?.fontSize ?? 20.0),
                            style: context.typography.labelLarge,
                          ),
                          child: AppPropertySlider(
                            value: element?.fontSize ?? 20.0,
                            min: 12,
                            max: 80,
                            onChanged: (v) => cubit
                                .updateSelectedElementsProperties(fontSize: v),
                          ),
                        ),
                      ],
                    ),
                    'Fundo': Column(
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
                        AppSectionBlock(
                          title: 'Raio do Canto',
                          padding: EdgeInsets.zero,
                          headerTrailing: Text(
                            AppPropertySlider.formatValue(
                                element?.backgroundRadius ?? 4.0),
                            style: context.typography.labelLarge,
                          ),
                          child: AppPropertySlider(
                            value: element?.backgroundRadius ?? 4.0,
                            min: 0,
                            max: 32,
                            onChanged: (v) =>
                                cubit.updateSelectedElementsProperties(
                              backgroundRadius: v,
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                ),
                const Divider(height: 24),
                AppSectionBlock(
                  title: 'Opacidade',
                  padding: EdgeInsets.zero,
                  headerTrailing: Text(
                    '${((element?.opacity ?? currentStyle.opacity) * 100).toInt()}%',
                    style: context.typography.labelLarge,
                  ),
                  child: AppPropertySlider(
                    value: element?.opacity ?? currentStyle.opacity,
                    min: 0,
                    max: 1,
                    onChanged: (v) =>
                        cubit.updateSelectedElementsProperties(opacity: v),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
