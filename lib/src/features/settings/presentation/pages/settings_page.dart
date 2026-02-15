import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Column(
        children: [
          // Header Sticky
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Configurações',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.subtle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          LucideIcons.x,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        // Usando Navigator.maybePop para segurança
                        onPressed: () => Navigator.of(context).maybePop(),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(), // Minimiza constraints padrão
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo Rolável
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSection(
                  title: 'Configurações',
                  items: [
                    _SettingsItem(icon: LucideIcons.user, label: 'Sobre'),
                    _SettingsItem(icon: LucideIcons.pencil, label: 'Editor'),
                    _SettingsItem(
                      icon: LucideIcons.wrench,
                      label: 'Barra de ferramentas móvel',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.folder,
                      label: 'Arquivos & Links',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.palette,
                      label: 'Aparência',
                    ),
                    _SettingsItem(icon: LucideIcons.command, label: 'Atalhos'),
                    _SettingsItem(icon: LucideIcons.key, label: 'Keychain'),
                    _SettingsItem(
                      icon: LucideIcons.box,
                      label: 'Plugins nativos',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.puzzle,
                      label: 'Plugins não oficiais',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Plugins nativos',
                  items: [
                    _SettingsItem(icon: LucideIcons.link, label: 'Backlinks'),
                    _SettingsItem(
                      icon: LucideIcons.penTool,
                      label: 'Compositor de notas',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.eye,
                      label: 'Espiar página',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.fileSearch,
                      label: 'Navegação rápida',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.command,
                      label: 'Paleta de comandos',
                    ),
                    _SettingsItem(
                      icon: LucideIcons.history,
                      label: 'Recuperação de arquivos',
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Espaço extra no final
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.labelMedium),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.subtle,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Container(
                decoration: !isLast
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.border, width: 1),
                        ),
                      )
                    : null,
                child: item,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SettingsItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppColors.textPrimary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
