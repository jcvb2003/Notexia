import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/components/modular_sheet_helper.dart';

class MainToolbar extends StatelessWidget {
  final bool isCompact;

  const MainToolbar({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (context, state) {
        final selectedTool = state.selectedTool;
        final uiState = context.watch<CanvasCubit>().state;
        final size = isCompact ? AppSizes.buttonSmall : 36.0;

        return BaseToolbar(
          actions: [
            if (isCompact)
              _CompactSelectionNavButton(
                selectedTool: selectedTool,
                size: size,
              )
            else ...[
              AppIconButton(
                icon: LucideIcons.mousePointer2,
                tooltip: 'Seleção (V, 1)',
                isActive: selectedTool == CanvasElementType.selection,
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.selection,
                    ),
                size: size,
                isCompact: isCompact,
              ),
              AppIconButton(
                icon: LucideIcons.compass,
                tooltip: 'Navegação (H, 2)',
                isActive: selectedTool == CanvasElementType.navigation,
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.navigation,
                    ),
                size: size,
                isCompact: isCompact,
              ),
            ],
            const AppDivider.toolbar(),

            // Shapes: collapsed to 1 button in compact mode
            if (isCompact)
              _CompactShapeButton(
                selectedTool: selectedTool,
                size: size,
              )
            else ...[
              AppIconButton(
                icon: LucideIcons.shapes,
                tooltip: 'Formas (R, 3)',
                isActive: _isShapeTool(selectedTool),
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.rectangle,
                    ),
                size: size,
                isCompact: isCompact,
              ),
            ],

            // Lines: collapsed to 1 button in compact mode
            if (isCompact)
              _CompactLineButton(
                selectedTool: selectedTool,
                size: size,
              )
            else ...[
              AppIconButton(
                icon: LucideIcons.arrowUpRight,
                tooltip: 'Seta (A, 5)',
                isActive: selectedTool == CanvasElementType.arrow,
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.arrow,
                    ),
                size: size,
                isCompact: isCompact,
              ),
              AppIconButton(
                icon: LucideIcons.minus,
                tooltip: 'Linha (L, 6)',
                isActive: selectedTool == CanvasElementType.line,
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.line,
                    ),
                size: size,
                isCompact: isCompact,
              ),
            ],

            const AppDivider.toolbar(),
            AppIconButton(
              icon: LucideIcons.pencil,
              tooltip: 'Desenhar (P, 7)',
              isActive: selectedTool == CanvasElementType.freeDraw,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.freeDraw,
                  ),
              size: size,
              isCompact: isCompact,
            ),
            AppIconButton(
              icon: LucideIcons.type,
              tooltip: 'Texto (T, 8)',
              isActive: selectedTool == CanvasElementType.text,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.text,
                  ),
              size: size,
              isCompact: isCompact,
            ),
            if (!isCompact)
              AppIconButton(
                icon: LucideIcons.image,
                tooltip: 'Imagem (9)',
                isActive: selectedTool == CanvasElementType.image,
                onTap: () => context.read<CanvasCubit>().selectTool(
                      CanvasElementType.image,
                    ),
                size: size,
                isCompact: isCompact,
              ),
            AppIconButton(
              icon: LucideIcons.eraser,
              tooltip: 'Borracha (E, 0)',
              isActive: selectedTool == CanvasElementType.eraser,
              onTap: () => context.read<CanvasCubit>().selectTool(
                    CanvasElementType.eraser,
                  ),
              size: size,
              isCompact: isCompact,
            ),
            const AppDivider.toolbar(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      child: AppSegmentedToggle<double>(
                        label: 'Ângulo',
                        value: currentValue,
                        options: {
                          0.0: 'Off',
                          pi / 24: '7.5°',
                          pi / 12: '15°',
                          pi / 8: '22.5°',
                          pi / 6: '30°',
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
                  size: size,
                  isCompact: isCompact,
                ),
                const SizedBox(height: 1),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIndicator(
                      isActive: uiState.snapMode.isAngleSnapEnabled,
                    ),
                    const SizedBox(width: 2),
                    AppIndicator(
                      isActive: uiState.snapMode.isObjectSnapEnabled,
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static bool _isShapeTool(CanvasElementType tool) =>
      tool == CanvasElementType.rectangle ||
      tool == CanvasElementType.ellipse ||
      tool == CanvasElementType.diamond ||
      tool == CanvasElementType.triangle;

  static bool _isLineTool(CanvasElementType tool) =>
      tool == CanvasElementType.arrow || tool == CanvasElementType.line;
}

/// Compact shape button — shows one icon, cycles through shapes on tap.
class _CompactShapeButton extends StatelessWidget {
  final CanvasElementType selectedTool;
  final double size;

  const _CompactShapeButton({
    required this.selectedTool,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = MainToolbar._isShapeTool(selectedTool);
    return AppIconButton(
      icon: LucideIcons.shapes,
      tooltip: 'Formas (R)',
      isActive: isActive,
      onTap: () {
        if (isActive) {
          final next = switch (selectedTool) {
            CanvasElementType.rectangle => CanvasElementType.ellipse,
            CanvasElementType.ellipse => CanvasElementType.diamond,
            CanvasElementType.diamond => CanvasElementType.triangle,
            CanvasElementType.triangle => CanvasElementType.rectangle,
            _ => CanvasElementType.rectangle,
          };
          context.read<CanvasCubit>().selectTool(next);
        } else {
          // Select default shape if none selected
          context.read<CanvasCubit>().selectTool(CanvasElementType.rectangle);
        }
      },
      size: size,
      isCompact: true,
    );
  }
}

/// Compact line button — shows arrow icon, active for line or arrow.
class _CompactLineButton extends StatelessWidget {
  final CanvasElementType selectedTool;
  final double size;

  const _CompactLineButton({
    required this.selectedTool,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = MainToolbar._isLineTool(selectedTool);
    return AppIconButton(
      icon: isActive && selectedTool == CanvasElementType.line
          ? LucideIcons.minus
          : LucideIcons.arrowUpRight,
      tooltip: 'Linhas (L/A)',
      isActive: isActive,
      onTap: () {
        // Toggle between arrow and line when already active
        if (isActive) {
          final next = selectedTool == CanvasElementType.arrow
              ? CanvasElementType.line
              : CanvasElementType.arrow;
          context.read<CanvasCubit>().selectTool(next);
        } else {
          context.read<CanvasCubit>().selectTool(CanvasElementType.arrow);
        }
      },
      size: size,
      isCompact: true,
    );
  }
}

/// Compact selection/navigation button — shows one icon, active for either.
class _CompactSelectionNavButton extends StatelessWidget {
  final CanvasElementType selectedTool;
  final double size;

  const _CompactSelectionNavButton({
    required this.selectedTool,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final isSelection = selectedTool == CanvasElementType.selection;
    final isNavigation = selectedTool == CanvasElementType.navigation;
    final isActive = isSelection || isNavigation;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: isNavigation ? LucideIcons.compass : LucideIcons.mousePointer2,
          tooltip: 'Seleção/Navegação',
          isActive: isActive,
          onTap: () {
            if (isActive) {
              final next = isSelection
                  ? CanvasElementType.navigation
                  : CanvasElementType.selection;
              context.read<CanvasCubit>().selectTool(next);
            } else {
              context
                  .read<CanvasCubit>()
                  .selectTool(CanvasElementType.selection);
            }
          },
          size: size,
          isCompact: true,
        ),
        const SizedBox(height: 1),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIndicator(
              isActive: isSelection,
            ),
            const SizedBox(width: 2),
            AppIndicator(
              isActive: isNavigation,
            ),
          ],
        ),
      ],
    );
  }
}
