import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class SkeletonView extends StatefulWidget {
  const SkeletonView({super.key});

  @override
  State<SkeletonView> createState() => _SkeletonViewState();
}

class _SkeletonViewState extends State<SkeletonView> {
  late TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CanvasCubit>();
    final doc = cubit.state.document;
    final jsonString = const JsonEncoder.withIndent('  ').convert({
      'id': doc.id,
      'title': doc.title,
      'createdAt': doc.createdAt.toIso8601String(),
      'updatedAt': doc.updatedAt.toIso8601String(),
      'elements':
          doc.elements.map((e) => CanvasElementMapper.toMap(e)).toList(),
    });
    _controller = TextEditingController(text: jsonString);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyChanges() {
    try {
      final json = jsonDecode(_controller.text);
      // Validar minimamente
      if (json is! Map<String, dynamic> || !json.containsKey('elements')) {
        throw Exception('JSON invÃ¡lido: deve conter a chave "elements"');
      }

      final updatedDoc = DrawingDocumentMapper.fromMap(json);
      context.read<CanvasCubit>().loadDocument(updatedDoc);

      setState(() => _error = 'MudanÃ§as aplicadas com sucesso!');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _error = null);
      });
    } catch (e) {
      setState(() => _error = 'Erro no JSON: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.gray900,
      padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'EDITOR JSON (BETA)',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: AppColors.textMuted),
              ),
              const Spacer(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    _error!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.danger),
                  ),
                ),
              TextButton.icon(
                onPressed: _applyChanges,
                icon: const Icon(LucideIcons.save, size: 16),
                label: const Text('Aplicar'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ],
          ),
          Expanded(
            child: ExcludeSemantics(
              child: AppTextField(
                controller: _controller,
                maxLines: null,
                showBorder: false,
                isDense: false,
                contentPadding: EdgeInsets.zero,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray300,
                      fontFamily: 'Consolas',
                      fontSize: 13,
                      height: 1.4,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
