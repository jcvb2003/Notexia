import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_state.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/tree/components/tree_item.dart';

/// Explorador de arquivos em Árvore Aninhada Recursiva.
/// Restaura a estética visual premium da Fase 13 com funcionalidade dinâmica.
class FileExplorerTree extends StatelessWidget {
  const FileExplorerTree({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileExplorerCubit, FileExplorerState>(
      builder: (context, state) {
        // Estado inicial de loading
        if (state.isLoading && state.rootItems.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
            ),
          );
        }

        // Estado de erro
        if (state.error != null && state.rootItems.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  LucideIcons.alertCircle,
                  size: 40,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      context.read<FileExplorerCubit>().initialize(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    textStyle: context.typography.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  child: const Text('Tentar Novamente'),
                ),
              ],
            ),
          );
        }

        // Lista vazia
        if (state.rootItems.isEmpty && !state.isLoading) {
          return Center(
            child: Text(
              'Vault vazio',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          children: state.rootItems
              .map((item) => TreeItem(item: item, level: 0))
              .toList(),
        );
      },
    );
  }
}
