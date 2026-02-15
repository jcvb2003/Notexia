import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document_mapper.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/file_management/domain/entities/file_item.dart';
import 'package:notexia/src/features/file_management/presentation/state/file_explorer_cubit.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/tree/components/tree_children_container.dart';
import 'package:notexia/src/features/file_management/presentation/widgets/tree/components/tree_item_row.dart';

/// Widget recursivo para itens da Ã¡rvore.
class TreeItem extends StatelessWidget {
  final FileItem item;
  final int level;

  const TreeItem({super.key, required this.item, required this.level});

  @override
  Widget build(BuildContext context) {
    final isExpanded = context.select<FileExplorerCubit, bool>(
      (c) => c.state.isExpanded(item.path),
    );
    final children = context.select<FileExplorerCubit, List<FileItem>>(
      (c) => c.state.childrenOf(item.path),
    );

    // OtimizaÃ§Ã£o: A Ã¡rvore sÃ³ reconstrÃ³i se o ID ou TÃ­tulo do documento ativo mudar.
    // Isso evita lags na sidebar enquanto o usuÃ¡rio desenha no canvas.
    final currentDocId = context.select<CanvasCubit, String>(
      (c) => c.state.document.id,
    );
    final currentDocTitle = context.select<CanvasCubit, String>(
      (c) => c.state.document.title,
    );

    final isSelected = currentDocId == item.id ||
        currentDocTitle == item.name.replaceAll('.notexia', '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TreeItemRow(
          item: item,
          level: level,
          isExpanded: isExpanded,
          isSelected: isSelected,
          onTap: () async {
            if (item.isFolder) {
              await context.read<FileExplorerCubit>().toggleFolder(item.path);
            } else if (item.name.endsWith('.notexia')) {
              final content = await context.read<FileExplorerCubit>().readFile(
                    item.path,
                  );
              if (content != null && content.isNotEmpty && context.mounted) {
                try {
                  final drawingCubit = context.read<CanvasCubit>();
                  final doc = DrawingDocumentMapper.fromJson(content);
                  drawingCubit.loadDocument(doc);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erro ao carregar arquivo')),
                  );
                }
              }
            }
          },
        ),
        if (item.isFolder && isExpanded)
          TreeChildrenContainer(children: children, level: level),
      ],
    );
  }
}
