import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/modular_sheet_helper.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/segmented_toggle.dart';

class MainToolbar extends StatelessWidget {
  const MainToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (context, state) {
        final selectedTool = state.selectedTool;
        final uiState = context.watch<CanvasCubit>().state;

        return BaseToolbar(
          actions: [
            AppIconButton(
              icon: LucideIcons.mousePointer2,
              tooltip: 'Seleção (V, 1)',
              isActive: selectedTool == CanvasElementType.selection,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.selection,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.compass,
              tooltip: 'Navegação (H, 2)',
              isActive: selectedTool == CanvasElementType.navigation,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.navigation,
                  ),
              size: 36,
            ),
            const ToolbarDivider(),
            AppIconButton(
              icon: LucideIcons.shapes,
              tooltip: 'Formas (R, 3)',
              isActive: selectedTool == CanvasElementType.rectangle ||
                  selectedTool == CanvasElementType.ellipse ||
                  selectedTool == CanvasElementType.diamond ||
                  selectedTool == CanvasElementType.triangle,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.rectangle,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.arrowUpRight,
              tooltip: 'Seta (A, 5)',
              isActive: selectedTool == CanvasElementType.arrow,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.arrow,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.minus,
              tooltip: 'Linha (L, 6)',
              isActive: selectedTool == CanvasElementType.line,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.line,
                  ),
              size: 36,
            ),
            const ToolbarDivider(),
            AppIconButton(
              icon: LucideIcons.pencil,
              tooltip: 'Desenhar (P, 7)',
              isActive: selectedTool == CanvasElementType.freeDraw,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.freeDraw,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.type,
              tooltip: 'Texto (T, 8)',
              isActive: selectedTool == CanvasElementType.text,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.text,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.image,
              tooltip: 'Imagem (9)',
              isActive: selectedTool == CanvasElementType.image,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.image,
                  ),
              size: 36,
            ),
            AppIconButton(
              icon: LucideIcons.eraser,
              tooltip: 'Borracha (E, 0)',
              isActive: selectedTool == CanvasElementType.eraser,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.eraser,
                  ),
              size: 36,
            ),
            const ToolbarDivider(),
            AppIconButton(
              icon: switch (uiState.snapMode) {
                SnapMode.none => LucideIcons.magnet,
                SnapMode.angle => LucideIcons.magnet,
                SnapMode.object => LucideIcons.layoutGrid,
                SnapMode.both => LucideIcons.sparkles,
              },
              tooltip:
                  '${uiState.snapMode.tooltip} (Toque duplo para configurar)',
              isActive: uiState.snapMode != SnapMode.none,
              onTap: () => context.read<CanvasCubit>().cycleSnapMode(),
              onDoubleTap: () {
                const pi = 3.141592653589793;
                final currentValue = uiState.snapMode.isAngleSnapEnabled
                    ? uiState.angleSnapStep
                    : 0.0;

                showModularSheet(
                  context,
                  title: 'Passo do Snap de Ângulo',
                  child: SegmentedToggle<double>(
                    label: 'Ângulo',
                    value: currentValue,
                    options: {
                      0.0: 'Off',
                      pi / 24: '7.5Â°',
                      pi / 12: '15Â°',
                      pi / 8: '22.5Â°',
                      pi / 6: '30Â°',
                    },
                    onChanged: (val) {
                      final cubit = context.read<CanvasCubit>();
                      if (val == 0.0) {
                        cubit.setAngleSnapEnabled(false);
                      } else {
                        cubit.setAngleSnapStep(val);
                        cubit.setAngleSnapEnabled(true);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              size: 36,
            ),
          ],
        );
      },
    );
  }
}
