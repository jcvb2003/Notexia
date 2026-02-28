import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/core/widgets/common/floating_card.dart';
import 'package:notexia/src/core/widgets/panels/app_section_block.dart';

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
            height: AppSizes.headerHeight,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: const BoxDecoration(
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
                      style: context.typography.titleLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppIconButton(
                      icon: LucideIcons.x,
                      tooltip: 'Fechar',
                      onTap: () => Navigator.of(context).maybePop(),
                      activeBackgroundColor: AppColors.background,
                      inactiveColor: AppColors.textSecondary,
                      size: AppSizes.buttonSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Conteúdo Rolável
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.xl - 4),
              children: [
                _SettingsSection(
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
                const SizedBox(height: AppSpacing.xl),
                _SettingsSection(
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
                const SizedBox(height: AppSpacing.xxl + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return AppSectionBlock(
      title: title,
      padding: EdgeInsets.zero,
      headerPadding: const EdgeInsets.only(
        left: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: FloatingCard(
        variant: FloatingCardVariant.outlined,
        padding: EdgeInsets.zero,
        borderRadius: AppSizes.radiusRound + 4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusRound + 4),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return Container(
                decoration: !isLast
                    ? const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.border, width: 1),
                        ),
                      )
                    : null,
                child: item,
              );
            }).toList(),
          ), // Column
        ), // ClipRRect
      ), // FloatingCard
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl - 4,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: AppSizes.iconLarge + 2, color: AppColors.textPrimary),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(label, style: context.typography.bodyLarge),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: AppSizes.iconLarge,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
