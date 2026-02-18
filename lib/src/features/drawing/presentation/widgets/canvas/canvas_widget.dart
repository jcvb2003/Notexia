import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_shortcuts_wrapper.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/inline_text_editor.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_input_router.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  late final CanvasInputRouter _router;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _router = CanvasInputRouter(canvasCubit: context.read<CanvasCubit>());
    _focusNode = FocusNode();
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

        return ExcludeSemantics(
          child: CanvasShortcutsWrapper(
            isTextEditing: editingTextId != null,
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
                                elements: uiState.document.activeSortedElements,
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
          ),
        );
      },
    );
  }
}
