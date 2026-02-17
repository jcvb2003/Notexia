import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_entities.dart';

import 'package:notexia/src/core/widgets/common/app_text_field.dart';
import 'package:notexia/src/features/drawing/presentation/utils/shortcuts/app_intents.dart';
import 'package:notexia/src/features/drawing/presentation/utils/shortcuts/app_shortcuts.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  late final CanvasInputRouter _router;
  late final FocusNode _focusNode;
  late final TextEditingController _textController;
  late final FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _router = CanvasInputRouter(canvasCubit: context.read<CanvasCubit>());
    _focusNode = FocusNode();
    _textController = TextEditingController();
    _textFocusNode = FocusNode()
      ..addListener(() {
        final cubit = context.read<CanvasCubit>();
        final editingId = cubit.state.editingTextId;
        if (!_textFocusNode.hasFocus && editingId != null) {
          _commitTextEditing(cubit, editingId);
        }
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _commitTextEditing(CanvasCubit cubit, String editingId) {
    final value = _textController.text;
    cubit.text.commitTextEditing(editingId, value);
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
            _textController.text = element.text;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _textFocusNode.requestFocus();
            });
          }
        }
      },
      child: BlocBuilder<CanvasCubit, CanvasState>(
        buildWhen: (previous, current) {
          return previous.document != current.document ||
              previous.interaction != current.interaction ||
              previous.transform != current.transform ||
              previous.snapGuides != current.snapGuides ||
              previous.isSkeletonMode != current.isSkeletonMode ||
              previous.interaction.selectedTool !=
                  current.interaction.selectedTool;
        },
        builder: (context, uiState) {
          final selectedTool = uiState.selectedTool;
          final editingTextId = uiState.editingTextId;

          final Map<ShortcutActivator, Intent> shortcuts = editingTextId != null
              ? const <ShortcutActivator, Intent>{}
              : AppShortcuts.defaultShortcuts;

          return ExcludeSemantics(
            child: Shortcuts(
              shortcuts: shortcuts,
              child: Actions(
                actions: <Type, Action<Intent>>{
                  DeleteSelectedElementsIntent:
                      CallbackAction<DeleteSelectedElementsIntent>(
                    onInvoke: (_) {
                      context
                          .read<CanvasCubit>()
                          .manipulation
                          .deleteSelectedElements();
                      return null;
                    },
                  ),
                  UndoIntent: CallbackAction<UndoIntent>(
                    onInvoke: (_) {
                      context.read<UndoRedoCubit>().undo();
                      return null;
                    },
                  ),
                  RedoIntent: CallbackAction<RedoIntent>(
                    onInvoke: (_) {
                      context.read<UndoRedoCubit>().redo();
                      return null;
                    },
                  ),
                  ClearCanvasIntent: CallbackAction<ClearCanvasIntent>(
                    onInvoke: (_) {
                      context.read<CanvasCubit>().clearCanvas();
                      return null;
                    },
                  ),
                  SelectToolIntent: CallbackAction<SelectToolIntent>(
                    onInvoke: (intent) {
                      context.read<CanvasCubit>().selectTool(intent.tool);
                      return null;
                    },
                  ),
                },
                child: Focus(
                  focusNode: _focusNode,
                  autofocus: true,
                  child: RepaintBoundary(
                    child: Listener(
                      behavior: HitTestBehavior.opaque,
                      onPointerDown: (event) {
                        if (editingTextId == null) {
                          _focusNode.requestFocus();
                        }
                        _router.handlePointerDown(event, uiState);
                      },
                      onPointerMove: (event) =>
                          _router.handlePointerMove(event, uiState),
                      onPointerUp: (event) =>
                          _router.handlePointerUp(event, uiState),
                      onPointerSignal: (signal) => _router.handlePointerSignal(
                        signal,
                        uiState,
                        selectedTool,
                      ),
                      child: MouseRegion(
                        onHover: (event) => _router.handleHover(event, uiState),
                        child: GestureDetector(
                          onTapDown: uiState.isZoomMode
                              ? null
                              : (details) =>
                                  _router.handleTapDown(details, uiState),
                          onScaleStart: (details) => _router.handleScaleStart(
                            details,
                            uiState,
                            selectedTool,
                          ),
                          onScaleUpdate: (details) => _router.handleScaleUpdate(
                            details,
                            uiState,
                            selectedTool,
                          ),
                          onScaleEnd: (details) => _router.handleScaleEnd(
                            details,
                            uiState,
                            selectedTool,
                          ),
                          child: Stack(
                            children: [
                              RepaintBoundary(
                                child: CustomPaint(
                                  painter: StaticCanvasPainter(
                                    elements:
                                        uiState.document.activeSortedElements,
                                    zoomLevel: uiState.zoomLevel,
                                    panOffset: uiState.panOffset,
                                    editingElementId: editingTextId,
                                  ),
                                  size: Size.infinite,
                                ),
                              ),
                              RepaintBoundary(
                                child: CustomPaint(
                                  painter: DynamicCanvasPainter(
                                    elements:
                                        uiState.document.activeSortedElements,
                                    selectedElementIds:
                                        uiState.selectedElementIds,
                                    zoomLevel: uiState.zoomLevel,
                                    panOffset: uiState.panOffset,
                                    selectionBox: uiState.selectionBox,
                                    hoveredElementId: uiState.hoveredElementId,
                                    eraserTrail: uiState.eraserTrail,
                                    isEraserActive: uiState.isEraserActive,
                                    snapGuides: uiState.snapGuides,
                                    activeDrawingElement:
                                        uiState.activeDrawingElement,
                                    activeElementListenable: context
                                        .read<CanvasCubit>()
                                        .drawing
                                        .activeElementNotifier,
                                  ),
                                  size: Size.infinite,
                                ),
                              ),
                              if (editingTextId != null)
                                _buildTextEditor(
                                  context,
                                  uiState,
                                  editingTextId,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextEditor(
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
          controller: _textController,
          focusNode: _textFocusNode,
          autofocus: true,
          showBorder: false,
          textAlign: editingElement.textAlign,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: null,
          minLines: 1,
          contentPadding: EdgeInsets.zero,
          style: TextStyle(
            fontSize: editingElement.fontSize * uiState.zoomLevel,
            fontFamily: editingElement.fontFamily,
            fontWeight:
                editingElement.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle:
                editingElement.isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: TextDecoration.combine([
              if (editingElement.isUnderlined) TextDecoration.underline,
              if (editingElement.isStrikethrough) TextDecoration.lineThrough,
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
            final cubit = context.read<CanvasCubit>();
            _commitTextEditing(cubit, editingId);
          },
          onEditingComplete: () {
            final cubit = context.read<CanvasCubit>();
            _commitTextEditing(cubit, editingId);
          },
        ),
      ),
    );
  }
}
