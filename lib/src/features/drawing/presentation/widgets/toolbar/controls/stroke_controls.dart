import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/common_controls.dart';

class StrokeToolControls extends StatelessWidget {
  final CanvasElementType tool;

  const StrokeToolControls({super.key, required this.tool});

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
          message: 'Cor do traÃ§o',
          child: GestureDetector(
            onTap: () => _showStrokePopover(context, cubit),
            child: ColorSwatchChip(
              color: selectedElement?.strokeColor ?? currentStyle.strokeColor,
            ),
          ),
        ),
        const ToolbarDivider(horizontalPadding: 10),
        if (tool == CanvasElementType.freeDraw) ...[
          AppIconButton(
            size: 36,
            icon: LucideIcons.pencil,
            tooltip: 'Lápis (Normal)',
            isActive:
                (selectedElement?.roughness ?? currentStyle.roughness) <= 0.5,
            onTap: () => cubit.manipulation
                .updateSelectedElementsProperties(roughness: 0.0),
          ),
          const SizedBox(width: 4),
          AppIconButton(
            size: 36,
            icon: LucideIcons.penTool,
            tooltip: 'Caneta (Sketchy)',
            isActive:
                (selectedElement?.roughness ?? currentStyle.roughness) > 0.5,
            onTap: () => cubit.manipulation
                .updateSelectedElementsProperties(roughness: 1.0),
          ),
        ],
        if (tool == CanvasElementType.line ||
            tool == CanvasElementType.arrow) ...[
          SegmentedToggle<StrokeStyle>(
            value: selectedElement?.strokeStyle ?? currentStyle.strokeStyle,
            options: const {
              StrokeStyle.solid: LucideIcons.minus,
              StrokeStyle.dashed: LucideIcons.moreHorizontal,
            },
            onChanged: (s) => cubit.manipulation
                .updateSelectedElementsProperties(strokeStyle: s),
          ),
        ],
        const ToolbarDivider(horizontalPadding: 10),
        AppIconButton(
          size: 36,
          icon: LucideIcons.layers,
          tooltip:
              'Opacidade: ${((selectedElement?.opacity ?? currentStyle.opacity) * 100).toInt()}%',
          onTap: () => _showOpacityPopover(context, cubit),
        ),
        if (selectedElement != null) ...[
          const SizedBox(width: 4),
          AppIconButton(
            size: 36,
            icon: LucideIcons.trash2,
            tooltip: 'Excluir',
            onTap: () => cubit.manipulation.deleteSelectedElements(),
            activeColor: AppColors.danger,
          ),
        ],
      ],
    );
  }

  void _showStrokePopover(BuildContext context, CanvasCubit cubit) {
    showModularSheet(
      context,
      title: 'Configurações de Traço',
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
              children: [
                ColorGrid(
                  selectedColor:
                      element?.strokeColor ?? currentStyle.strokeColor,
                  onSelected: (c) => cubit.manipulation
                      .updateSelectedElementsProperties(strokeColor: c),
                ),
                const Divider(height: 32),
                PropertySlider(
                  label: 'Grossura',
                  value: element?.strokeWidth ?? currentStyle.strokeWidth,
                  min: 1,
                  max: 10,
                  onChanged: (v) => cubit.manipulation
                      .updateSelectedElementsProperties(strokeWidth: v),
                ),
                const SizedBox(height: 12),
                PropertySlider(
                  label: 'Precisão',
                  value: element?.roughness ?? currentStyle.roughness,
                  min: 0,
                  max: 5,
                  onChanged: (v) => cubit.manipulation
                      .updateSelectedElementsProperties(roughness: v),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showOpacityPopover(BuildContext context, CanvasCubit cubit) {
    showModularSheet(
      context,
      title: 'Opacidade',
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

            return PropertySlider(
              label: 'Nível de Transparência',
              value: element?.opacity ?? currentStyle.opacity,
              min: 0,
              max: 1,
              onChanged: (v) => cubit.manipulation
                  .updateSelectedElementsProperties(opacity: v),
            );
          },
        ),
      ),
    );
  }
}
