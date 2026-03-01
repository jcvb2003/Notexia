import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_icon_color_picker.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_delete_dialog.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_rename_dialog.dart';

class ExplorerContextMenu {
  static Future<void> show({
    required BuildContext context,
    required Offset position,
    required FileItem item,
    required Function(String) onRename,
    required VoidCallback onDelete,
    required VoidCallback onShowInFolder,
    required VoidCallback onSearchInFolder,
    required Function(String? icon, Color? color) onApplyAppearance,
    bool isMobile = false,
  }) async {
    if (isMobile) {
      return _showBottomSheet(
        context,
        item,
        onRename,
        onDelete,
        onShowInFolder,
        onSearchInFolder,
        onApplyAppearance,
      );
    }

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.background,
      elevation: 8,
      items: <PopupMenuEntry<String>>[
        AppPopupMenuItem(
          value: 'rename',
          icon: LucideIcons.edit3,
          label: 'Renomear',
        ),
        AppPopupMenuItem(
          value: 'search',
          icon: LucideIcons.search,
          label: 'Pesquisar na pasta',
        ),
        AppPopupMenuItem(
          value: 'show',
          icon: LucideIcons.externalLink,
          label: 'Mostrar na pasta',
        ),
        const PopupMenuDivider(),
        AppPopupMenuItem(
          value: 'appearance',
          icon: LucideIcons.palette,
          label: 'Aparência',
        ),
        const PopupMenuDivider(),
        AppPopupMenuItem(
          value: 'delete',
          icon: LucideIcons.trash2,
          label: 'Apagar',
          isDestructive: true,
        ),
      ],
    );

    if (result == null || !context.mounted) return;
    _handleResult(
      context,
      result,
      item,
      onRename,
      onDelete,
      onShowInFolder,
      onSearchInFolder,
      onApplyAppearance,
    );
  }

  static Future<void> _showBottomSheet(
    BuildContext context,
    FileItem item,
    Function(String) onRename,
    VoidCallback onDelete,
    VoidCallback onShowInFolder,
    VoidCallback onSearchInFolder,
    Function(String? icon, Color? color) onApplyAppearance,
  ) async {
    await AppBottomSheet.show(
      context,
      title: Text(item.name.replaceAll('.notexia', '')),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionItem(
            context,
            icon: LucideIcons.edit3,
            label: 'Renomear',
            onTap: () {
              Navigator.pop(context);
              FileRenameDialog.show(context, item: item, onRename: onRename);
            },
          ),
          _buildActionItem(
            context,
            icon: LucideIcons.search,
            label: 'Pesquisar na pasta',
            onTap: () {
              Navigator.pop(context);
              onSearchInFolder();
            },
          ),
          _buildActionItem(
            context,
            icon: LucideIcons.externalLink,
            label: 'Mostrar na pasta',
            onTap: () {
              Navigator.pop(context);
              onShowInFolder();
            },
          ),
          const Divider(height: 16),
          _buildActionItem(
            context,
            icon: LucideIcons.palette,
            label: 'Aparência',
            onTap: () async {
              Navigator.pop(context);
              await FileIconColorPicker.show(
                context,
                initialIcon: item.customIcon,
                initialColor:
                    item.customColor != null ? Color(item.customColor!) : null,
                onApply: onApplyAppearance,
              );
            },
          ),
          const Divider(height: 16),
          _buildActionItem(
            context,
            icon: LucideIcons.trash2,
            label: 'Apagar',
            isDestructive: true,
            onTap: () {
              Navigator.pop(context);
              FileDeleteDialog.show(context, item: item, onDelete: onDelete);
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.danger : AppColors.textPrimary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? AppColors.danger : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  static void _handleResult(
    BuildContext context,
    String result,
    FileItem item,
    Function(String) onRename,
    VoidCallback onDelete,
    VoidCallback onShowInFolder,
    VoidCallback onSearchInFolder,
    Function(String? icon, Color? color) onApplyAppearance,
  ) {
    if (!context.mounted) return;

    switch (result) {
      case 'rename':
        FileRenameDialog.show(context, item: item, onRename: onRename);
        break;
      case 'delete':
        FileDeleteDialog.show(context, item: item, onDelete: onDelete);
        break;
      case 'search':
        onSearchInFolder();
        break;
      case 'show':
        onShowInFolder();
        break;
      case 'appearance':
        FileIconColorPicker.show(
          context,
          initialIcon: item.customIcon,
          initialColor:
              item.customColor != null ? Color(item.customColor!) : null,
          onApply: onApplyAppearance,
        );
        break;
    }
  }
}
