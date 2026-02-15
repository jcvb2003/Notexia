import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/menus/app_menu_item.dart';

class FileExplorerMenu extends StatefulWidget {
  const FileExplorerMenu({super.key});

  @override
  State<FileExplorerMenu> createState() => _FileExplorerMenuState();
}

class _FileExplorerMenuState extends State<FileExplorerMenu> {
  bool _isExpanded = false;
  String _selectedItem = 'Explorador de arquivos';

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _selectItem(String item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusRound),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header do Acordeão
          GestureDetector(
            onTap: _toggleExpand,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.folder,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Explorador de arquivos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronsUpDown,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Itens do Menu
          AnimatedCrossFade(
            firstChild: Container(height: 0),
            secondChild: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  AppMenuItem(
                    icon: LucideIcons.search,
                    label: 'Procurar',
                    isSelected: _selectedItem == 'Procurar',
                    onTap: () => _selectItem('Procurar'),
                  ),
                  AppMenuItem(
                    icon: LucideIcons.tags,
                    label: 'Tags',
                    isSelected: _selectedItem == 'Tags',
                    onTap: () => _selectItem('Tags'),
                  ),
                  AppMenuItem(
                    icon: LucideIcons.bookmark,
                    label: 'Marcadores',
                    isSelected: _selectedItem == 'Marcadores',
                    onTap: () => _selectItem('Marcadores'),
                  ),
                  AppMenuItem(
                    icon: LucideIcons.folder,
                    label: 'Explorador de arquivos',
                    isSelected: _selectedItem == 'Explorador de arquivos',
                    onTap: () => _selectItem('Explorador de arquivos'),
                  ),
                ],
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
