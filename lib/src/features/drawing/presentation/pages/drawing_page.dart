import 'package:flutter/material.dart';
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
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
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

        final double bottomMargin = 10.0;
        final double? toolbarTop =
            uiState.isToolbarAtTop ? (isMobile ? 12 : 80) : null;
        final double? toolbarBottom =
            uiState.isToolbarAtTop ? null : bottomMargin;

        final double? contextualTop = uiState.isToolbarAtTop
            ? (toolbarTop != null ? toolbarTop + 60 : null)
            : null;
        final double? contextualBottom =
            uiState.isToolbarAtTop ? null : (bottomMargin + 52);

        return ExcludeSemantics(
          child: Stack(
            children: [
              Positioned.fill(
                child: isSkeleton ? const SkeletonView() : const CanvasWidget(),
              ),
              HeaderWidget(
                onOpenMenu: onOpenMenu,
                isSidebarOpen: isSidebarOpen,
              ),
              if (!isSkeleton) ...[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  bottom: contextualBottom,
                  top: contextualTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const ContextToolbar(),
                    ),
                  ),
                ),
                DraggableToolbar(
                  isToolbarAtTop: uiState.isToolbarAtTop,
                  toolbarTop: toolbarTop,
                  toolbarBottom: toolbarBottom,
                  isMobile: isMobile,
                  onPositionChanged: (atTop) =>
                      uiCubit.preferences.setToolbarPosition(atTop),
                ),
                Positioned(
                  bottom: isCompactLayout
                      ? (uiState.isToolbarAtTop ? bottomMargin : 140)
                      : bottomMargin,
                  left: isCompactLayout ? null : 16,
                  right: isCompactLayout ? 16 : null,
                  child: SafeArea(
                    child: SlidableUtilityControl(
                      isZoomMode: uiState.isZoomMode,
                      zoomLevel: uiState.zoomLevel,
                      onToggle: () => uiCubit.preferences.toggleZoomUndoRedo(),
                      onZoomIn: () => uiCubit.viewport.zoomIn(),
                      onZoomOut: () => uiCubit.viewport.zoomOut(),
                      onUndo: () => context.read<UndoRedoCubit>().undo(),
                      onRedo: () => context.read<UndoRedoCubit>().redo(),
                    ),
                  ),
                ),
              ],
              if (isFullScreen)
                Positioned(
                  top: isMobile ? -15 : 7,
                  right: 10,
                  child: SafeArea(
                    bottom: false,
                    minimum: const EdgeInsets.only(top: 4),
                    child: FloatingCard(
                      child: AppIconButton(
                        icon: LucideIcons.minimize2,
                        tooltip: 'Sair da tela cheia',
                        onTap: () => uiCubit.preferences.toggleFullScreen(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
