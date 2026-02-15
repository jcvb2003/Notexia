import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/footer/components/file_explorer_menu.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/footer/components/vault_selector.dart';
import 'package:notexia/src/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SidebarFooter extends StatelessWidget {
  const SidebarFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FileExplorerCubit>().state;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Seção 1: Botões de Ação Rápida
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ActionButton(
                icon: LucideIcons.filePlus,
                tooltip: 'Novo documento',
                onPressed: () => context.read<FileExplorerCubit>().createFile(
                  'Novo Desenho.notexia',
                ),
              ),
              const ActionButton(
                icon: LucideIcons.fileInput,
                tooltip: 'Abrir arquivo',
              ),
              const ActionButton(
                icon: LucideIcons.pencil,
                tooltip: 'Novo desenho',
              ),
              ActionButton(
                icon: LucideIcons.folderPlus,
                tooltip: 'Nova pasta',
                onPressed: () => context.read<FileExplorerCubit>().createFolder(
                  'Nova Pasta',
                ),
              ),
              const ActionButton(
                icon: LucideIcons.arrowUpDown,
                tooltip: 'Ordenar',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Seção 2: Menu Expansível "Explorador de Arquivos"
          const FileExplorerMenu(),

          const SizedBox(height: 16),

          // Seção 3: Rodapé - Informações do Cofre (Vault)
          Row(
            children: [
              ActionButton(
                icon: LucideIcons.settings,
                tooltip: 'Configurações',
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const SettingsPage(),
                      opaque: false,
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0, 1),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOutCubic,
                                    ),
                                  ),
                              child: child,
                            );
                          },
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: VaultSelector(
                  name: state.vaultName.isEmpty
                      ? 'VAULT'
                      : state.vaultName.toUpperCase(),
                  summary: state.stats?.summary ?? 'Carregando...',
                  onTap: () =>
                      context.read<FileExplorerCubit>().pickVaultDirectory(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
