import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/color_picker_panel.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/common_controls.dart';

class StrokeToolControls extends StatelessWidget {
  final CanvasElementType tool;
  final bool isCompact;

  const StrokeToolControls(
      {super.key, required this.tool, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final (
      selectedElement,
      currentStyle,
    ) = context.select<CanvasCubit, (CanvasElement?, ElementStyle)>((cubit) {
      final state = cubit.state;
      final selectedIds = state.selectedElementIds;
      CanvasElement? element;
      if (selectedIds.isNotEmpty) {
        final selectedId = selectedIds.first;
        element = state.elements.where((e) => e.id == selectedId).firstOrNull;
      }
      return (element, state.currentStyle);
    });

    final cubit = context.read<CanvasCubit>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Propriedades',
          child: GestureDetector(
            onTap: () => _showStrokePopover(context, cubit),
            child: ColorSwatchChip(
              color: selectedElement?.strokeColor ?? currentStyle.strokeColor,
            ),
          ),
        ),
        const AppDivider.toolbar(horizontalPadding: 10),
        if (tool == CanvasElementType.freeDraw) ...[
          AppIconButton(
            size: 36,
            icon: LucideIcons.pencil,
            tooltip: 'Lápis (Normal)',
            isActive:
                (selectedElement?.roughness ?? currentStyle.roughness) <= 0.5,
            onTap: () => cubit.updateSelectedElementsProperties(roughness: 0.0),
            isCompact: isCompact,
          ),
          const SizedBox(width: 4),
          AppIconButton(
            size: 36,
            icon: LucideIcons.penTool,
            tooltip: 'Caneta (Sketchy)',
            isActive:
                (selectedElement?.roughness ?? currentStyle.roughness) > 0.5,
            onTap: () => cubit.updateSelectedElementsProperties(roughness: 1.0),
            isCompact: isCompact,
          ),
        ],
        const AppDivider.toolbar(horizontalPadding: 10),
        if (selectedElement != null) ...[
          const SizedBox(width: 4),
          AppIconButton(
            size: 36,
            icon: LucideIcons.trash2,
            tooltip: 'Excluir',
            onTap: () => cubit.deleteSelectedElements(),
            activeColor: AppColors.danger,
            isCompact: isCompact,
          ),
        ],
      ],
    );
  }

  void _showStrokePopover(BuildContext context, CanvasCubit cubit) {
    AppBottomSheet.show(
      context,
      title: const Text('Configurações do Traço'),
      child: BlocProvider.value(
        value: cubit,
        child: BlocBuilder<CanvasCubit, CanvasState>(
          builder: (context, state) {
            final selectedIds = state.selectedElementIds;
            CanvasElement? element;
            if (selectedIds.isNotEmpty) {
              final selectedId = selectedIds.first;
              element =
                  state.elements.where((e) => e.id == selectedId).firstOrNull;
            }
            final currentStyle = state.currentStyle;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppSectionBlock(
                  title: 'Estilo da Linha',
                  padding: EdgeInsets.zero,
                  child: AppSegmentedToggle<StrokeStyle>(
                    value: element?.strokeStyle ?? currentStyle.strokeStyle,
                    options: const {
                      StrokeStyle.solid: LineStyleIcon.solid(),
                      StrokeStyle.dashed: LineStyleIcon.dashed(),
                      StrokeStyle.dotted: LineStyleIcon.dotted(),
                    },
                    onChanged: (s) =>
                        cubit.updateSelectedElementsProperties(strokeStyle: s),
                  ),
                ),
                const Divider(height: 24),
                ColorPickerPanel(
                  selectedColor:
                      element?.strokeColor ?? currentStyle.strokeColor,
                  onColorSelected: (c) =>
                      cubit.updateSelectedElementsProperties(strokeColor: c),
                ),
                const Divider(height: 24),
                AppSectionBlock(
                  title: 'Grossura',
                  padding: EdgeInsets.zero,
                  headerTrailing: Text(
                    AppPropertySlider.formatValue(
                        element?.strokeWidth ?? currentStyle.strokeWidth, 1),
                    style: context.typography.labelLarge,
                  ),
                  child: AppPropertySlider(
                    value: element?.strokeWidth ?? currentStyle.strokeWidth,
                    min: 1,
                    max: 10,
                    fractionDigits: 1,
                    onChanged: (v) =>
                        cubit.updateSelectedElementsProperties(strokeWidth: v),
                  ),
                ),
                const Divider(height: 24),
                AppSectionBlock(
                  title: 'Precisão',
                  padding: EdgeInsets.zero,
                  headerTrailing: Text(
                    AppPropertySlider.formatValue(
                        element?.roughness ?? currentStyle.roughness, 1),
                    style: context.typography.labelLarge,
                  ),
                  child: AppPropertySlider(
                    value: element?.roughness ?? currentStyle.roughness,
                    min: 0,
                    max: 5,
                    fractionDigits: 1,
                    onChanged: (v) =>
                        cubit.updateSelectedElementsProperties(roughness: v),
                  ),
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
