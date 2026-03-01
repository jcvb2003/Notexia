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

    if (result == null) return;
    if (!context.mounted) return;

    switch (result) {
      case 'rename':
        await FileRenameDialog.show(context, item: item, onRename: onRename);
        break;
      case 'delete':
        await FileDeleteDialog.show(context, item: item, onDelete: onDelete);
        break;
      case 'search':
        onSearchInFolder();
        break;
      case 'show':
        onShowInFolder();
        break;
      case 'appearance':
        await FileIconColorPicker.show(
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
