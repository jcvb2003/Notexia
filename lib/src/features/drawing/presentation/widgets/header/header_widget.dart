import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/core/widgets/common/floating_card.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/file_name_input.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/menu/header_dropdown_menu.dart';

class HeaderWidget extends StatefulWidget {
  final VoidCallback? onOpenMenu;
  final bool isSidebarOpen;
  final double top;

  const HeaderWidget({
    super.key,
    this.onOpenMenu,
    this.isSidebarOpen = true,
    this.top = 0,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppDurations.menuTransition,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isMenuOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    setState(() => _isMenuOpen = true);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  Future<void> _closeMenu() async {
    await _animationController.reverse();
    _removeOverlay();
    if (mounted) {
      setState(() => _isMenuOpen = false);
    }
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final canvasCubit = context.read<CanvasCubit>();

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              behavior: HitTestBehavior.translucent,
              child: Container(color: AppColors.transparent),
            ),
          ),
          Positioned(
            width: 240,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              child: HeaderDropdownMenu(
                onClose: _closeMenu,
                canvasCubit: canvasCubit,
                animation: _animation,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CanvasCubit, CanvasState, bool>(
      selector: (state) => state.isFullScreen,
      builder: (context, isFullScreen) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: widget.top,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  FloatingCard(
                    padding: EdgeInsets.zero,
                    child: AppIconButton(
                      icon: LucideIcons.panelLeft,
                      tooltip: widget.isSidebarOpen
                          ? 'Fechar Sidebar'
                          : 'Abrir Sidebar',
                      onTap: widget.onOpenMenu,
                      isActive: widget.isSidebarOpen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: FloatingCard(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      child: FileNameInput(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  CompositedTransformTarget(
                    link: _layerLink,
                    child: FloatingCard(
                      padding: EdgeInsets.zero,
                      child: AppIconButton(
                        icon: LucideIcons.moreVertical,
                        tooltip: 'Mais opções',
                        onTap: _toggleMenu,
                        isActive: _isMenuOpen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
