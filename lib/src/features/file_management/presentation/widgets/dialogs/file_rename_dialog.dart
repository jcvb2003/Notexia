import 'package:flutter/material.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
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

    return AppDialog(
      title: const Text('Renomear'),
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
        AppTextButton(
          onPressed: () => Navigator.pop(context),
          label: 'Cancelar',
        ),
        AppFilledButton(
          onPressed: () {
            onRename(controller.text);
            Navigator.pop(context);
          },
          label: 'Salvar',
        ),
      ],
    );
  }
}
