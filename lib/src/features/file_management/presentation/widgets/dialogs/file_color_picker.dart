import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class FileColorPicker extends StatelessWidget {
  final Function(Color) onSetColor;

  const FileColorPicker({super.key, required this.onSetColor});

  static Future<void> show(
    BuildContext context, {
    required Function(Color) onSetColor,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FileColorPicker(onSetColor: onSetColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.palette;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Escolha uma cor',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: colors
                    .map(
                      (c) => GestureDetector(
                        onTap: () {
                          onSetColor(c);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
