import 'package:flutter/material.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/tree/components/tree_item.dart';

/// Container para os filhos de uma pasta, implementa a linha guia vertical.
class TreeChildrenContainer extends StatelessWidget {
  final List<FileItem> children;
  final int level;

  const TreeChildrenContainer({
    super.key,
    required this.children,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          left: 32.0 + (level * 12.0),
          top: 4,
          bottom: 4,
        ),
        child: Text(
          'Vazio',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20), // Indentação base
      child: Stack(
        children: [
          // Linha guia vertical cinza sutil
          Positioned(
            left: 7, // Centralizado com o chevron da pasta pai
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: AppColors.border.withValues(alpha: 0.4),
            ),
          ),
          Column(
            children: children
                .map((child) => TreeItem(item: child, level: level + 1))
                .toList(),
          ),
        ],
      ),
    );
  }
}
