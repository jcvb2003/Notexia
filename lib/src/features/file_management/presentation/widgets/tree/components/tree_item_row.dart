import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/buttons/app_icon_button.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/dialogs/file_icon_picker.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/explorer_context_menu.dart';

/// A linha (Row) visual de cada item na árvore.
class TreeItemRow extends StatefulWidget {
  final FileItem item;
  final int level;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onTap;

  const TreeItemRow({
    super.key,
    required this.item,
    required this.level,
    required this.isExpanded,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<TreeItemRow> createState() => _TreeItemRowState();
}

class _TreeItemRowState extends State<TreeItemRow> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    const selectedBg = AppColors.successBackground;
    const selectedFg = AppColors.success;
    const defaultFg = AppColors.textPrimary;

    final cubit = context.read<FileExplorerCubit>();

    return GestureDetector(
      onSecondaryTapDown: (details) => _tapPosition = details.globalPosition,
      onSecondaryTap: () => _showMenu(context, cubit),
      onLongPressStart: (details) => _tapPosition = details.globalPosition,
      onLongPress: () => _showMenu(context, cubit),
      child: HoverAnimatedScale(
        tooltip: null,
        onTap: widget.onTap,
        hoverScale: 1.01,
        isActive: widget.isSelected,
        activeScale: 1.01,
        builder: (context, isHovering) {
          return Container(
            height: 32,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            padding: const EdgeInsets.only(left: 4.0),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? selectedBg
                  : (isHovering ? AppColors.gray50 : AppColors.transparent),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                if (widget.item.isFolder)
                  Icon(
                    widget.isExpanded
                        ? LucideIcons.chevronDown
                        : LucideIcons.chevronRight,
                    size: 14,
                    color: AppColors.textMuted,
                  )
                else
                  const SizedBox(width: 14),
                const SizedBox(width: 6),
                Icon(
                  _getIcon(),
                  size: 16,
                  color: widget.isSelected ? selectedFg : _getIconColor(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.item.name.replaceAll('.notexia', ''),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: widget.isSelected ? selectedFg : defaultFg,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMenu(BuildContext context, FileExplorerCubit cubit) {
    ExplorerContextMenu.show(
      context: context,
      position: _tapPosition,
      item: widget.item,
      onRename: (newName) => cubit.renameItem(widget.item.path, newName),
      onDelete: () => cubit.deleteItem(widget.item.path),
      onSetIcon: (icon) =>
          cubit.updateItemMetadata(widget.item.path, icon: icon),
      onSetColor: (color) =>
          cubit.updateItemMetadata(widget.item.path, color: color.toARGB32()),
    );
  }

  IconData _getIcon() {
    if (widget.item.customIcon != null) {
      return FileIconPicker.resolveIcon(widget.item.customIcon);
    }
    if (widget.item.isFolder) return LucideIcons.folder;
    final ext = widget.item.name.split('.').last.toLowerCase();
    if (ext == 'notexia' || ext == 'drawing') return LucideIcons.fileEdit;
    return LucideIcons.file;
  }

  Color _getIconColor() {
    if (widget.item.customColor != null) {
      return Color(widget.item.customColor!);
    }
    if (widget.item.isFolder) return AppColors.info;
    return AppColors.textMuted;
  }
}
