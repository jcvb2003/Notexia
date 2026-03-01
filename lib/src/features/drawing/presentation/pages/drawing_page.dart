import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/core/widgets/common/floating_card.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_widget.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/debug/skeleton_view.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/header_widget.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/context_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/draggable_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/utility_controls/slidable_utility_control.dart';

import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';

class DrawingPage extends StatelessWidget {
  final VoidCallback? onOpenMenu;
  final bool isSidebarOpen;

  const DrawingPage({super.key, this.onOpenMenu, this.isSidebarOpen = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (context, uiState) {
        final isSkeleton = uiState.isSkeletonMode;
        final isFullScreen = uiState.isFullScreen;
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 640;
        // Layout compacto apenas para celulares muito estreitos
        final isCompactLayout = screenWidth < 500;
        final uiCubit = context.read<CanvasCubit>();

        final metrics = _LayoutMetrics.calculate(
          state: uiState,
          isMobile: isMobile,
          isCompact: isCompactLayout,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: isSkeleton ? const SkeletonView() : const CanvasWidget(),
            ),
            HeaderWidget(
              onOpenMenu: onOpenMenu,
              isSidebarOpen: isSidebarOpen,
              top: metrics.headerTop,
            ),
            if (!isSkeleton) ...[
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                bottom: metrics.contextBottom,
                top: metrics.contextTop,
                left: 0,
                right: 0,
                child: SafeArea(
                  top: uiState.isToolbarAtTop,
                  bottom: !uiState.isToolbarAtTop,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ContextToolbar(isCompact: isCompactLayout),
                    ),
                  ),
                ),
              ),
              DraggableToolbar(
                isToolbarAtTop: uiState.isToolbarAtTop,
                toolbarTop: metrics.toolbarTop,
                toolbarBottom: metrics.toolbarBottom,
                isMobile: isMobile,
                isCompact: isCompactLayout,
                onPositionChanged: (atTop) => uiCubit.setToolbarPosition(atTop),
              ),
              Positioned(
                bottom: metrics.utilityBottom,
                left: isCompactLayout ? null : 16,
                right: isCompactLayout ? 16 : null,
                child: SafeArea(
                  child: SlidableUtilityControl(
                    isZoomMode: uiState.isZoomMode,
                    zoomLevel: uiState.zoomLevel,
                    onToggle: () => uiCubit.toggleZoomUndoRedo(),
                    onZoomIn: () {
                      final size = MediaQuery.of(context).size;
                      uiCubit.zoomIn(Offset(size.width / 2, size.height / 2));
                    },
                    onZoomOut: () {
                      final size = MediaQuery.of(context).size;
                      uiCubit.zoomOut(Offset(size.width / 2, size.height / 2));
                    },
                    onUndo: () => context.read<UndoRedoCubit>().undo(),
                    onRedo: () => context.read<UndoRedoCubit>().redo(),
                  ),
                ),
              ),
            ],
            if (isFullScreen)
              Positioned(
                top: metrics.fullscreenButtonTop,
                right: 10,
                child: SafeArea(
                  bottom: false,
                  minimum: const EdgeInsets.only(top: 4),
                  child: FloatingCard(
                    child: AppIconButton(
                      icon: LucideIcons.minimize2,
                      tooltip: 'Sair da tela cheia',
                      onTap: () => uiCubit.toggleFullScreen(),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LayoutMetrics {
  final double headerTop;
  final double? toolbarTop;
  final double? toolbarBottom;
  final double? contextTop;
  final double? contextBottom;
  final double utilityBottom;
  final double fullscreenButtonTop;

  _LayoutMetrics({
    required this.headerTop,
    this.toolbarTop,
    this.toolbarBottom,
    this.contextTop,
    this.contextBottom,
    required this.utilityBottom,
    required this.fullscreenButtonTop,
  });

  factory _LayoutMetrics.calculate({
    required CanvasState state,
    required bool isMobile,
    required bool isCompact,
  }) {
    const double gap = AppSizes.toolbarGap; // Standardized spacing
    final double headerVisualBottom =
        AppSpacing.sm + AppSizes.buttonSmall + (AppSpacing.xs * 2);
    final double toolbarH = isMobile ? AppSizes.toolbarHeight : 48.0;

    // 1. Header: Oculto se em fullscreen
    final double headerTop = state.isFullScreen ? -100 : 0;

    // 2. Toolbar principal
    final double? toolbarTop;
    final double? toolbarBottom;

    if (!state.isToolbarAtTop) {
      toolbarTop = null;
      toolbarBottom = gap;
    } else if (state.isFullScreen) {
      // Fullscreen + topo: toolbar começa abaixo do botão fechar
      toolbarTop = isMobile ? 56.0 : gap;
      toolbarBottom = null;
    } else {
      // Normal + topo: toolbar começa exatamente abaixo do visual do header (56px) mais o gap
      // O HeaderWidget mede 56px de conteúdo visível (8 padding + 40 btn + 8 padding).
      // Como o DraggableToolbar tem SafeArea(top: true), o notch é automaticamente somado.
      toolbarTop = headerVisualBottom + gap;
      toolbarBottom = null;
    }

    // 3. Toolbar contextual (sempre separada da principal pela mesma distância)
    final double? contextTop = (state.isToolbarAtTop && toolbarTop != null)
        ? toolbarTop + toolbarH + gap
        : null;
    final double? contextBottom =
        state.isToolbarAtTop ? null : (toolbarBottom ?? 0) + toolbarH + gap;

    // 4. Utility Control (Zoom/History)
    double utilityBottom;
    if (state.isFullScreen && state.isToolbarAtTop) {
      utilityBottom = gap;
    } else if (isCompact && !state.isToolbarAtTop) {
      // Evita colisão com as toolbars empilhadas no bottom: bottom da contextual + gap
      utilityBottom = (contextBottom ?? gap) + toolbarH + gap;
    } else {
      utilityBottom = gap;
    }

    // 5. Botão de reduzir fullscreen
    // Mobile: -15 restaura posição rente ao topo (SafeArea ajusta o notch)
    final double fullscreenButtonTop = isMobile ? -15.0 : gap;

    return _LayoutMetrics(
      headerTop: headerTop,
      toolbarTop: toolbarTop,
      toolbarBottom: toolbarBottom,
      contextTop: contextTop,
      contextBottom: contextBottom,
      utilityBottom: utilityBottom,
      fullscreenButtonTop: fullscreenButtonTop,
    );
  }
}
