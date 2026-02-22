import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FileIconUtils {
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
}
