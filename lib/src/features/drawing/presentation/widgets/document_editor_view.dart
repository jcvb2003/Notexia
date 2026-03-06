import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

class DocumentEditorView extends StatefulWidget {
  const DocumentEditorView({super.key});

  @override
  State<DocumentEditorView> createState() => _DocumentEditorViewState();
}

class _DocumentEditorViewState extends State<DocumentEditorView> {
  late TextEditingController _controller;
  String? _error;
  bool _isValid = true;
  Timer? _debounce;
  late String _originalJson;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CanvasCubit>();
    final doc = cubit.state.document;

    _originalJson = const JsonEncoder.withIndent('  ').convert({
      'id': doc.id,
      'title': doc.title,
      'createdAt': doc.createdAt.toIso8601String(),
      'updatedAt': doc.updatedAt.toIso8601String(),
      'elements':
          doc.elements.map((e) => CanvasElementMapper.toMap(e)).toList(),
    });

    _controller = TextEditingController(text: _originalJson);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _validateJsonInline);
  }

  void _validateJsonInline() {
    if (!mounted) return;
    try {
      final json = jsonDecode(_controller.text);
      if (json is! Map<String, dynamic> || !json.containsKey('elements')) {
        setState(() {
          _error = 'JSON inválido: deve conter a chave "elements"';
          _isValid = false;
        });
        return;
      }
      DrawingDocumentMapper.fromMap(json); // Teste de parsing completo
      setState(() {
        _error = null;
        _isValid = true;
      });
    } catch (e) {
      setState(() {
        _error = 'JSON inválido: formato incorreto';
        _isValid = false;
      });
    }
  }

  bool get _isDirty => _controller.text != _originalJson;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _applyChanges() {
    if (!_isValid) return;
    try {
      final json = jsonDecode(_controller.text);
      if (json is! Map<String, dynamic> || !json.containsKey('elements')) {
        throw Exception('JSON inválido: deve conter a chave "elements"');
      }

      final updatedDoc = DrawingDocumentMapper.fromMap(json);
      context.read<CanvasCubit>().loadDocument(
            updatedDoc,
            recordCommand: true,
            commandLabel: 'Editar JSON',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mudanças aplicadas com sucesso!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _originalJson = _controller.text;
          _error = null;
          _isValid = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro no JSON: $e';
        _isValid = false;
      });
    }
  }

  Future<void> _handleClose() async {
    if (_isDirty) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.gray900,
          title: const Text('Descartar mudanças?'),
          content: const Text(
              'Você tem alterações não salvas. Deseja sair sem aplicar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: TextButton.styleFrom(foregroundColor: AppColors.textMuted),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
              child: const Text('Descartar'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }
    if (mounted) {
      FocusScope.of(context).unfocus();
      // Executa a mudança de estado num tick futuro pro TextField dar mount down tranquilo
      unawaited(Future.microtask(() {
        if (mounted) {
          context.read<CanvasCubit>().toggleDocumentEditorMode();
        }
      }));
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copiado para a área de transferência!'),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
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
                onPressed: _copyToClipboard,
                icon: const Icon(LucideIcons.copy, size: 16),
                label: const Text('Copiar'),
                style:
                    TextButton.styleFrom(foregroundColor: AppColors.textMuted),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: _isValid ? _applyChanges : null,
                icon: Icon(LucideIcons.save,
                    size: 16,
                    color: _isValid ? AppColors.primary : AppColors.textMuted),
                label: Text('Aplicar',
                    style: TextStyle(
                        color: _isValid
                            ? AppColors.primary
                            : AppColors.textMuted)),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _handleClose,
                icon: const Icon(LucideIcons.x, size: 20),
                color: AppColors.textMuted,
                tooltip: 'Sair e Descartar',
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
