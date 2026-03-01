import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';

/// An inline text editor overlay positioned on top of a [TextElement].
///
/// Manages its own [TextEditingController] and [FocusNode], syncing
/// with the cubit when text editing begins, changes, or commits.
class InlineTextEditor extends StatefulWidget {
  const InlineTextEditor({super.key});

  @override
  State<InlineTextEditor> createState() => _InlineTextEditorState();
}

class _InlineTextEditorState extends State<InlineTextEditor> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() {
        final cubit = context.read<CanvasCubit>();
        final editingId = cubit.state.editingTextId;
        if (!_focusNode.hasFocus && editingId != null) {
          _commitTextEditing(cubit, editingId);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commitTextEditing(CanvasCubit cubit, String editingId) {
    cubit.text.commitTextEditing(editingId, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CanvasCubit, CanvasState>(
      listenWhen: (previous, current) =>
          previous.editingTextId != current.editingTextId,
      listener: (context, state) {
        if (state.editingTextId != null) {
          final element = state.elements
              .where((e) => e.id == state.editingTextId)
              .firstOrNull;
          if (element is TextElement) {
            _controller.text = element.text;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _focusNode.requestFocus();
            });
          }
        }
      },
      child: BlocBuilder<CanvasCubit, CanvasState>(
        buildWhen: (previous, current) =>
            previous.editingTextId != current.editingTextId ||
            previous.transform != current.transform ||
            previous.document != current.document,
        builder: (context, uiState) {
          final editingId = uiState.editingTextId;
          if (editingId == null) return const SizedBox.shrink();

          return _buildEditor(context, uiState, editingId);
        },
      ),
    );
  }

  Widget _buildEditor(
    BuildContext context,
    CanvasState uiState,
    String editingId,
  ) {
    final editingElement =
        uiState.elements.where((e) => e.id == editingId).firstOrNull;

    if (editingElement is! TextElement) return const SizedBox.shrink();

    return Positioned(
      left: editingElement.x * uiState.zoomLevel + uiState.panOffset.dx,
      top: editingElement.y * uiState.zoomLevel + uiState.panOffset.dy,
      child: SizedBox(
        width: (editingElement.width * uiState.zoomLevel)
            .clamp(60.0, 600.0)
            .toDouble(),
        child: AppTextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          showBorder: false,
          textAlign: editingElement.textAlign,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          minLines: 1,
          contentPadding: EdgeInsets.zero,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: editingElement.fontSize * uiState.zoomLevel,
                fontFamily: editingElement.fontFamily,
                fontWeight:
                    editingElement.isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: editingElement.isItalic
                    ? FontStyle.italic
                    : FontStyle.normal,
                decoration: TextDecoration.combine([
                  if (editingElement.isUnderlined) TextDecoration.underline,
                  if (editingElement.isStrikethrough)
                    TextDecoration.lineThrough,
                ]),
                color: editingElement.strokeColor.withValues(
                  alpha: editingElement.opacity,
                ),
                backgroundColor: editingElement.backgroundColor,
              ),
          onChanged: (value) {
            context.read<CanvasCubit>().text.updateTextElement(
                  editingElement.id,
                  value,
                );
          },
          onSubmitted: (_) {
            _commitTextEditing(context.read<CanvasCubit>(), editingId);
          },
          onEditingComplete: () {
            _commitTextEditing(context.read<CanvasCubit>(), editingId);
          },
        ),
      ),
    );
  }
}
