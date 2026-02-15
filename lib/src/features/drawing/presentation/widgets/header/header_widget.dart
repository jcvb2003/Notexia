import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/file_name_input.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/header_actions_bar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/header_icon_button.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback? onOpenMenu;
  final bool isSidebarOpen;

  const HeaderWidget({super.key, this.onOpenMenu, this.isSidebarOpen = true});

  @override
  Widget build(BuildContext context) {
    const showSidebarButton = true;
    const double elementHeight = 40.0;

    return BlocSelector<CanvasCubit, CanvasState, bool>(
      selector: (state) => state.isFullScreen,
      builder: (context, isFullScreen) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: isFullScreen ? -100 : 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showSidebarButton)
                    HeaderIconButton(
                      icon: LucideIcons.panelLeft,
                      onTap: onOpenMenu,
                      tooltip: 'Alternar barra lateral',
                      isSelected: isSidebarOpen,
                      size: elementHeight,
                    ),
                  Expanded(
                    child: Center(child: FileNameInput(height: elementHeight)),
                  ),
                  HeaderActionsBar(height: elementHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
