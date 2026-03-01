import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/core/widgets/widgets.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_shortcuts_wrapper.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/inline_text_editor.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  late final CanvasInputRouter _router;
  late final FocusNode _focusNode;
  PointerDeviceKind lastPointerKind = PointerDeviceKind.touch;

  MouseCursor _getCursorForState(CanvasState state) {
    if (state.isZoomMode) return SystemMouseCursors.grab;

    switch (state.selectedTool) {
      case CanvasElementType.navigation:
        return SystemMouseCursors.grab;
      case CanvasElementType.selection:
        return SystemMouseCursors.basic;
      case CanvasElementType.text:
        return SystemMouseCursors.text;
      case CanvasElementType.rectangle:
      case CanvasElementType.diamond:
      case CanvasElementType.ellipse:
      case CanvasElementType.line:
      case CanvasElementType.arrow:
      case CanvasElementType.triangle:
      case CanvasElementType.freeDraw:
      case CanvasElementType.eraser:
      case CanvasElementType.image:
        return SystemMouseCursors.precise;
    }
  }

  bool _isCheckingStylus = false;

  void _checkStylusPrompt(PointerDeviceKind kind, CanvasState state) {
    if (kind == PointerDeviceKind.stylus &&
        !state.hasShownStylusPrompt &&
        !_isCheckingStylus) {
      _isCheckingStylus = true;
      final cubit = context.read<CanvasCubit>();

      AppDialog.confirm(
        context,
        title: 'Caneta detectada',
        content:
            'Deseja ativar o Modo Caneta? Apenas a caneta irá desenhar, e você poderá usar os dedos para mover e dar zoom livres.',
        confirmLabel: 'Ativar',
        cancelLabel: 'Agora não',
      ).then((result) {
        if (result != null) {
          cubit.handleStylusPromptResult(result);
        }
        if (mounted) setState(() => _isCheckingStylus = false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _router = CanvasInputRouter(canvasCubit: context.read<CanvasCubit>());
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasCubit, CanvasState>(
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

        return CanvasShortcutsWrapper(
          isTextEditing: editingTextId != null,
          child: Focus(
            focusNode: _focusNode,
            autofocus: true,
            child: RepaintBoundary(
              child: Listener(
                behavior: HitTestBehavior.opaque,
                onPointerDown: (event) {
                  lastPointerKind = event.kind;
                  _checkStylusPrompt(event.kind, uiState);
                  if (editingTextId == null) {
                    _focusNode.requestFocus();
                  }
                  _router.handlePointerDown(event, uiState);
                },
                onPointerMove: (event) {
                  lastPointerKind = event.kind;
                  _router.handlePointerMove(event, uiState);
                },
                onPointerUp: (event) {
                  lastPointerKind = event.kind;
                  _router.handlePointerUp(event, uiState);
                },
                onPointerSignal: (signal) => _router.handlePointerSignal(
                  signal,
                  uiState,
                  selectedTool,
                ),
                child: MouseRegion(
                  cursor: _getCursorForState(uiState),
                  onHover: (event) {
                    _checkStylusPrompt(event.kind, uiState);
                    _router.handleHover(event, uiState);
                  },
                  child: GestureDetector(
                    onTapDown: uiState.isZoomMode
                        ? null
                        : (details) => _router.handleTapDown(
                            details, uiState, lastPointerKind),
                    onScaleStart: (details) => _router.handleScaleStart(
                      details,
                      uiState,
                      selectedTool,
                      lastPointerKind,
                    ),
                    onScaleUpdate: (details) => _router.handleScaleUpdate(
                      details,
                      uiState,
                      selectedTool,
                      lastPointerKind,
                    ),
                    onScaleEnd: (details) => _router.handleScaleEnd(
                      details,
                      uiState,
                      selectedTool,
                      lastPointerKind,
                    ),
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          child: CustomPaint(
                            painter: StaticCanvasPainter(
                              elements: uiState.document.activeSortedElements,
                              selectedElementIds: uiState.selectedElementIds,
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
                              elements: uiState.document.activeSortedElements,
                              selectedElementIds: uiState.selectedElementIds,
                              zoomLevel: uiState.zoomLevel,
                              panOffset: uiState.panOffset,
                              selectionBox: uiState.selectionBox,
                              hoveredElementId: uiState.hoveredElementId,
                              eraserTrail: uiState.eraserTrail,
                              isEraserActive: uiState.isEraserActive,
                              snapGuides: uiState.snapGuides,
                              activeDrawingElement:
                                  uiState.activeDrawingElement,
                            ),
                            size: Size.infinite,
                          ),
                        ),
                        const InlineTextEditor(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
