import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/common_controls.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/shape_controls.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/stroke_controls.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/text_controls.dart';

class ContextToolbar extends StatelessWidget {
  const ContextToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final (selectedTool, effectiveType) = context
        .select<CanvasCubit, (CanvasElementType, CanvasElementType?)>((cubit) {
          final state = cubit.state;
          CanvasElementType? type;

          if (state.selectedTool == CanvasElementType.selection &&
              state.selectedElementIds.isNotEmpty) {
            final firstId = state.selectedElementIds.first;
            final element = state.elements
                .where((e) => e.id == firstId)
                .firstOrNull;
            if (element != null) {
              type = element.type;
            }
          }

          return (state.selectedTool, type);
        });

    final displayTool = effectiveType ?? selectedTool;

    if (!_hasControls(displayTool)) {
      return const SizedBox.shrink();
    }

    return BaseToolbar(
      backgroundColor: AppColors.background,
      center: ToolSpecificControls(tool: displayTool),
    );
  }

  bool _hasControls(CanvasElementType tool) => switch (tool) {
    CanvasElementType.rectangle ||
    CanvasElementType.ellipse ||
    CanvasElementType.diamond ||
    CanvasElementType.triangle ||
    CanvasElementType.line ||
    CanvasElementType.arrow ||
    CanvasElementType.freeDraw ||
    CanvasElementType.text ||
    CanvasElementType.eraser => true,
    _ => false,
  };
}

class ToolSpecificControls extends StatelessWidget {
  final CanvasElementType tool;

  const ToolSpecificControls({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return switch (tool) {
      CanvasElementType.rectangle ||
      CanvasElementType.ellipse ||
      CanvasElementType.diamond ||
      CanvasElementType.triangle => ShapeToolControls(tool: tool),
      CanvasElementType.line ||
      CanvasElementType.arrow ||
      CanvasElementType.freeDraw => StrokeToolControls(tool: tool),
      CanvasElementType.text => const TextToolControls(),
      CanvasElementType.eraser => const EraserToolControls(),
      _ => const SizedBox.shrink(),
    };
  }
}

class EraserToolControls extends StatelessWidget {
  const EraserToolControls({super.key});

  @override
  Widget build(BuildContext context) {
    final uiState = context.select<CanvasCubit, CanvasState>(
      (cubit) => cubit.state,
    );
    final uiCubit = context.read<CanvasCubit>();

    return Row(
      children: [
        SegmentedToggle<EraserMode>(
          value: uiState.eraserMode,
          options: const {
            EraserMode.stroke: 'TraÃ§o',
            EraserMode.all: 'Tudo',
            EraserMode.area: 'Ãrea',
          },
          onChanged: uiCubit.setEraserMode,
        ),
      ],
    );
  }
}

