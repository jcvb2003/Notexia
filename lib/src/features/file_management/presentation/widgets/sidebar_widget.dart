import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_footer.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/file_explorer_tree.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class SidebarWidget extends StatelessWidget {
  final bool isMobile;

  const SidebarWidget({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final width =
        isMobile ? AppSizes.sidebarWidthMobile : AppSizes.sidebarWidth;

    return BlocProvider(
      create: (context) => FileExplorerCubit(
        context.read<FileRepository>(),
        context.read<AppSettingsRepository>(),
      )..initialize(),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(right: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          children: [
            const _SidebarHeader(),
            const Expanded(child: FileExplorerTree()),
            const SidebarFooter(),
          ],
        ),
      ),
    );
  }
}

/// Cabeçalho estruturado da sidebar com branding e espaço para ações futuras.
class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Explorador de arquivos',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            BlocBuilder<FileExplorerCubit, FileExplorerState>(
              builder: (context, state) {
                return PopupMenuButton<SortMode>(
                  icon: const Icon(LucideIcons.arrowUpDown, size: 18),
                  tooltip: 'Ordenar',
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  offset: const Offset(0, 40),
                  onSelected: (mode) {
                    context.read<FileExplorerCubit>().setSortMode(mode);
                  },
                  itemBuilder: (context) => [
                    _buildSortItem(context, SortMode.name, 'Por nome', state),
                    _buildSortItem(
                        context, SortMode.createdAt, 'Data de criação', state),
                    _buildSortItem(context, SortMode.updatedAt,
                        'Data de alteração', state),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<SortMode> _buildSortItem(
    BuildContext context,
    SortMode mode,
    String label,
    FileExplorerState state,
  ) {
    final isActive = state.sortMode == mode;
    final dirIcon = state.sortDir == SortDirection.ascending
        ? LucideIcons.chevronUp
        : LucideIcons.chevronDown;

    return PopupMenuItem<SortMode>(
      value: mode,
      height: 36,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
          ),
          if (isActive) ...[
            const SizedBox(width: 8),
            Icon(dirIcon, size: 16, color: AppColors.primary),
          ],
        ],
      ),
    );
  }
}
