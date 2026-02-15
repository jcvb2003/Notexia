import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_color_picker.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_delete_dialog.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_icon_picker.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_rename_dialog.dart';

class ExplorerContextMenu {
  static Future<void> show({
    required BuildContext context,
    required Offset position,
    required FileItem item,
    required Function(String) onRename,
    required VoidCallback onDelete,
    required Function(String) onSetIcon,
    required Function(Color) onSetColor,
  }) async {
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
        _buildItem(
          context: context,
          value: 'rename',
          icon: LucideIcons.edit3,
          label: 'Renomear',
        ),
        _buildItem(
          context: context,
          value: 'icon',
          icon: LucideIcons.hash,
          label: 'Alterar ícone',
        ),
        _buildItem(
          context: context,
          value: 'color',
          icon: LucideIcons.palette,
          label: 'Alterar cor',
        ),
        const PopupMenuDivider(),
        _buildItem(
          context: context,
          value: 'delete',
          icon: LucideIcons.trash2,
          label: 'Apagar',
          color: AppColors.danger,
        ),
      ],
    );

    if (result == null) return;
    if (!context.mounted) return;

    switch (result) {
      case 'rename':
        await FileRenameDialog.show(context, item: item, onRename: onRename);
        break;
      case 'delete':
        await FileDeleteDialog.show(context, item: item, onDelete: onDelete);
        break;
      case 'icon':
        await FileIconPicker.show(context, onSetIcon: onSetIcon);
        break;
      case 'color':
        await FileColorPicker.show(context, onSetColor: onSetColor);
        break;
    }
  }

  static PopupMenuItem<String> _buildItem({
    required BuildContext context,
    required String value,
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 36,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color ?? AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
