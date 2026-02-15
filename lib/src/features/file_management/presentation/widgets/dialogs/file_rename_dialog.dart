import 'package:flutter/material.dart';
import 'package:notexia/src/core/widgets/common/app_dialog.dart';
import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';

class FileRenameDialog extends StatelessWidget {
  final FileItem item;
  final Function(String) onRename;

  const FileRenameDialog({
    super.key,
    required this.item,
    required this.onRename,
  });

  static Future<void> show(
    BuildContext context, {
    required FileItem item,
    required Function(String) onRename,
  }) {
    return AppDialog.show(
      context,
      builder: (context) => FileRenameDialog(item: item, onRename: onRename),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
      text: item.name.replaceAll('.notexia', ''),
    );

    final textTheme = Theme.of(context).textTheme;
    return AppDialog(
      title: Text('Renomear', style: textTheme.titleMedium),
      content: AppTextField(
        controller: controller,
        autofocus: true,
        hintText: 'Novo nome',
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          onRename(controller.text);
          Navigator.pop(context);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            onRename(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
