import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/sidebar_footer.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/file_explorer_tree.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/file_management/domain/repositories/file_repository.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class SidebarWidget extends StatelessWidget {
  final bool isMobile;

  const SidebarWidget({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final width = isMobile ? 304.0 : 280.0;

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
            Text('Explorer', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            // Espaço reservado para ações futuras (ex: botão de busca, filtros)
            // Pode adicionar ícones aqui quando necessário
          ],
        ),
      ),
    );
  }
}
