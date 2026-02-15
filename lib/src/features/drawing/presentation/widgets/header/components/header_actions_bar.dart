import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/header_icon_button.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/header/components/menu/header_dropdown_menu.dart';

class HeaderActionsBar extends StatefulWidget {
  final double height;
  const HeaderActionsBar({super.key, this.height = 40.0});

  @override
  State<HeaderActionsBar> createState() => _HeaderActionsBarState();
}

class _HeaderActionsBarState extends State<HeaderActionsBar> {
  bool _isMenuOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
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
  }

  void _closeMenu() {
    _removeOverlay();
    setState(() => _isMenuOpen = false);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    // Captura o cubit do contexto atual para passar para o Overlay
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderIconButton(
          icon: LucideIcons.menu,
          tooltip: 'Menu',
          size: widget.height,
        ),
        const SizedBox(width: 8),
        HeaderIconButton(
          icon: LucideIcons.save,
          tooltip: 'Salvar',
          size: widget.height,
        ),
        const SizedBox(width: 8),
        CompositedTransformTarget(
          link: _layerLink,
          child: HeaderIconButton(
            icon: LucideIcons.moreVertical,
            tooltip: 'Mais',
            onTap: _toggleMenu,
            isSelected: _isMenuOpen,
            size: widget.height,
          ),
        ),
      ],
    );
  }
}
