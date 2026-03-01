import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_footer.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/file_explorer_tree.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/features/file_management/data/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/settings/data/repositories/app_settings_repository.dart';

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
            _SidebarHeader(isMobile: isMobile),
            const Expanded(child: FileExplorerTree()),
            const SidebarFooter(),
          ],
        ),
      ),
    );
  }
}

/// Cabeçalho estruturado da sidebar com branding e espaço para ações futuras.
class _SidebarHeader extends StatefulWidget {
  final bool isMobile;
  const _SidebarHeader({required this.isMobile});

  @override
  State<_SidebarHeader> createState() => _SidebarHeaderState();
}

class _SidebarHeaderState extends State<_SidebarHeader> {
  bool _isSortMenuOpen = false;

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
                if (widget.isMobile) {
                  return AppIconButton(
                    icon: LucideIcons.arrowUpDown,
                    tooltip: 'Ordenar',
                    size: 32,
                    isActive: _isSortMenuOpen,
                    onTap: () {
                      _showSortBottomSheet(context, state);
                    },
                  );
                }
                return PopupMenuButton<SortMode>(
                  tooltip: 'Ordenar',
                  color: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  offset: const Offset(0, 44),
                  onOpened: () => setState(() => _isSortMenuOpen = true),
                  onCanceled: () => setState(() => _isSortMenuOpen = false),
                  onSelected: (mode) {
                    setState(() => _isSortMenuOpen = false);
                    context.read<FileExplorerCubit>().setSortMode(mode);
                  },
                  itemBuilder: (context) => [
                    _buildSortItem(context, SortMode.name, 'Por nome', state),
                    _buildSortItem(
                        context, SortMode.createdAt, 'Data de criação', state),
                    _buildSortItem(context, SortMode.updatedAt,
                        'Data de alteração', state),
                  ],
                  child: AppIconButton(
                    icon: LucideIcons.arrowUpDown,
                    tooltip: 'Ordenar',
                    size: 32,
                    isActive: _isSortMenuOpen,
                  ),
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

  void _showSortBottomSheet(BuildContext context, FileExplorerState state) {
    AppBottomSheet.show(
      context,
      title: const Text('Ordenar por'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSortOption(context, SortMode.name, 'Por nome', state),
          _buildSortOption(
              context, SortMode.createdAt, 'Data de criação', state),
          _buildSortOption(
              context, SortMode.updatedAt, 'Data de alteração', state),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    SortMode mode,
    String label,
    FileExplorerState state,
  ) {
    final isActive = state.sortMode == mode;
    final dirIcon = state.sortDir == SortDirection.ascending
        ? LucideIcons.chevronUp
        : LucideIcons.chevronDown;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isActive ? Icon(dirIcon, color: AppColors.primary) : null,
      onTap: () {
        context.read<FileExplorerCubit>().setSortMode(mode);
        Navigator.pop(context);
      },
    );
  }
}
