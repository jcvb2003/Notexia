import 'package:flutter/material.dart';
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
  }) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Excluir item',
      content:
          'Tem certeza que deseja excluir "${item.name}"? Esta ação não pode ser desfeita.',
      confirmLabel: 'Excluir',
      isDestructive: true,
    );

    if (confirmed == true) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Este build não será mais chamado via show, mas mantemos para compatibilidade
    // ou removemos se não houver outros usos.
    return const SizedBox.shrink();
  }
}
