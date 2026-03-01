import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class HeaderDropdownMenu extends StatelessWidget {
  final VoidCallback onClose;
  final CanvasCubit canvasCubit;

  const HeaderDropdownMenu({
    super.key,
    required this.onClose,
    required this.canvasCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: canvasCubit,
      child: Material(
        color: AppColors.transparent,
        child: Container(
          width: 240,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            boxShadow: AppShadows.elevated,
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownItem(
                icon: LucideIcons.x,
                label: 'Fechar',
                onTap: onClose,
              ),
              DropdownItem(
                icon: LucideIcons.save,
                label: 'Salvar',
                onTap: () {
                  onClose();
                },
              ),
              const DropdownItem(icon: LucideIcons.search, label: 'Pesquisar'),
              DropdownItem(
                icon: LucideIcons.maximize2,
                label: 'Tela cheia',
                showDivider: true,
                onTap: () {
                  canvasCubit.toggleFullScreen();
                  onClose();
                },
              ),
              HeaderDropdownToggle(
                icon: LucideIcons.code,
                label: 'Modo: Esqueleto',
                onClose: onClose,
              ),
              DropdownItem(
                icon: LucideIcons.fingerprint,
                label: 'Desenhar com dedo',
                trailing: BlocBuilder<CanvasCubit, CanvasState>(
                  builder: (context, state) {
                    return AppCompactSwitch(
                      value: state.isDrawWithFingerEnabled,
                      onChanged: (_) {
                        canvasCubit.toggleDrawWithFinger();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderDropdownToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onClose;

  const HeaderDropdownToggle({
    super.key,
    required this.icon,
    required this.label,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
      builder: (context, state) {
        final value = state.isSkeletonMode;
        void toggle() {
          context.read<CanvasCubit>().toggleSkeletonMode();
          onClose?.call();
        }

        return DropdownItem(
          icon: icon,
          label: label,
          onTap: toggle,
          trailing: AppCompactSwitch(value: value, onChanged: (v) => toggle()),
        );
      },
    );
  }
}
