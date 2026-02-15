import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/app_dialog.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';

class FileDeleteDialog extends StatelessWidget {
  final FileItem item;
  final VoidCallback onDelete;

  const FileDeleteDialog({
    super.key,
    required this.item,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required FileItem item,
    required VoidCallback onDelete,
  }) {
    return AppDialog.show(
      context,
      builder: (context) => FileDeleteDialog(item: item, onDelete: onDelete),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppDialog(
      title: Text('Excluir item', style: textTheme.titleMedium),
      content: Text(
        'Tem certeza que deseja excluir "${item.name}"? Esta ação não pode ser desfeita.',
        style: textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: Text(
            'Excluir',
            style: textTheme.labelLarge?.copyWith(color: AppColors.iconActive),
          ),
        ),
      ],
    );
  }
}
