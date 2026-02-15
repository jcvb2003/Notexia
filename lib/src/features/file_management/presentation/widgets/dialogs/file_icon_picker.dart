import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';

class FileIconPicker extends StatelessWidget {
  final Function(String) onSetIcon;

  const FileIconPicker({super.key, required this.onSetIcon});

  static const Map<String, IconData> iconMap = {
    'folder': LucideIcons.folder,
    'star': LucideIcons.star,
    'heart': LucideIcons.heart,
    'bookmark': LucideIcons.bookmark,
    'tag': LucideIcons.tag,
    'file': LucideIcons.file,
    'image': LucideIcons.image,
    'music': LucideIcons.music,
  };

  static IconData resolveIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) {
      return LucideIcons.folder;
    }
    return iconMap[iconName] ?? LucideIcons.folder;
  }

  static Future<void> show(
    BuildContext context, {
    required Function(String) onSetIcon,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FileIconPicker(onSetIcon: onSetIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Escolha um ícone',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: iconMap.entries
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          onSetIcon(e.key);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.gray100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            e.value,
                            size: 24,
                            color: AppColors.textSecondary,
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
