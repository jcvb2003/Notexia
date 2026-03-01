import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/canvas_manipulation_service.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/domain/services/transformation_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/canvas_interaction_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class _MemoryDocumentRepository implements DocumentRepository {
  final Map<String, DrawingDocument> _docs = {};

  @override
  Future<Result<void>> deleteDocument(String id) async {
    _docs.remove(id);
    return Result.success(null);
  }

  @override
  Future<Result<void>> deleteElement(String drawingId, String elementId) async {
    final doc = _docs[drawingId];
    if (doc == null) return Result.success(null);
    _docs[drawingId] = doc.copyWith(
      elements: doc.elements.where((e) => e.id != elementId).toList(),
    );
    return Result.success(null);
  }

  @override
  Future<Result<DrawingDocument?>> getDocumentById(String id) async {
    return Result.success(_docs[id]);
  }

  @override
  Future<Result<List<DrawingDocument>>> getDocuments() async {
    return Result.success(_docs.values.toList());
  }

  @override
  Future<Result<void>> saveDocument(DrawingDocument document) async {
    _docs[document.id] = document;
    return Result.success(null);
  }

  @override
  Future<Result<void>> saveElement(
      String drawingId, CanvasElement element) async {
    final doc = _docs[drawingId];
    if (doc == null) return Result.success(null);
    final next = [...doc.elements];
    final idx = next.indexWhere((e) => e.id == element.id);
    if (idx >= 0) {
      next[idx] = element;
    } else {
      next.add(element);
    }
    _docs[drawingId] = doc.copyWith(elements: next);
    return Result.success(null);
  }
}

void main() {
  late _MemoryDocumentRepository repository;
  late CommandStackService commandStack;
  late CanvasCubit cubit;

  setUp(() {
    repository = _MemoryDocumentRepository();
    commandStack = CommandStackService();
    final now = DateTime(2026, 1, 1);
    final initial = DrawingDocument(
      id: 'doc-1',
      title: 'Workflow',
      elements: const [],
      createdAt: now,
      updatedAt: now,
    );
    repository.saveDocument(initial);

    final transformation = TransformationService();
    final manipulation = CanvasManipulationService(transformation);
    final drawingService =
        DrawingService(canvasManipulationService: manipulation);
    final persistence = PersistenceService(repository);
    final interaction = CanvasInteractionDelegate(manipulation, transformation);
    cubit = CanvasCubit(
      repository,
      commandStack,
      drawingService,
      persistence,
      interaction,
      const TextEditingDelegate(),
      const ViewportDelegate(),
      const DrawingDelegate(),
      const EraserDelegate(),
      const SnapDelegate(),
      initial,
    );
  });

  tearDown(() async {
    await cubit.close();
    commandStack.dispose();
  });

  test(
      'shape workflow: draw -> move -> rotate -> resize -> undo/redo -> persist',
      () async {
    cubit.selectTool(CanvasElementType.rectangle);
    cubit.drawing.startDrawing(const Offset(10, 10));
    cubit.drawing.updateDrawing(const Offset(110, 70));
    await cubit.drawing.stopDrawing();

    final created = cubit.state.document.elements.single as RectangleElement;
    expect(created.width, 100);
    expect(created.height, 60);

    cubit.selectTool(CanvasElementType.selection);
    cubit.selectElementAt(const Offset(50, 40));
    expect(cubit.state.selectedElementIds, {created.id});

    cubit.beginCommandGesture('Mover');
    cubit.moveSelectedElements(const Offset(20, 30));
    cubit.endCommandGesture();

    final moved = cubit.state.document.elements.single as RectangleElement;
    expect(moved.x, created.x + 20);
    expect(moved.y, created.y + 30);
    expect(commandStack.canUndo, isTrue);

    commandStack.undo();
    final undone = cubit.state.document.elements.single as RectangleElement;
    expect(undone.x, created.x);
    expect(undone.y, created.y);

    commandStack.redo();
    final redone = cubit.state.document.elements.single as RectangleElement;
    expect(redone.x, moved.x);
    expect(redone.y, moved.y);

    cubit.rotateSelectedElement(0.8);
    cubit.resizeSelectedElement(const Rect.fromLTWH(40, 50, 150, 90));
    await cubit.finalizeManipulation();

    final persisted = (await repository.getDocumentById('doc-1')).data!;
    final persistedRect = persisted.elements.single as RectangleElement;
    expect(persistedRect.angle, 0.8);
    expect(persistedRect.bounds, const Rect.fromLTWH(40, 50, 150, 90));
  });

  test('text + freeDraw workflow persists expected element states', () async {
    cubit.selectTool(CanvasElementType.freeDraw);
    cubit.drawing.startDrawing(const Offset(0, 0));
    cubit.drawing.updateDrawing(const Offset(10, 10));
    cubit.drawing.updateDrawing(const Offset(25, 5));
    await cubit.drawing.stopDrawing();

    final textId = cubit.text.createTextElement(const Offset(120, 80));
    expect(textId, isNotNull);
    cubit.text.updateTextElement(textId!, 'hello world');
    await cubit.text.commitTextEditing(textId, 'hello world');

    cubit.selectTool(CanvasElementType.selection);
    cubit.selectElementAt(const Offset(130, 90));
    expect(cubit.state.selectedElementIds, {textId});

    cubit.deleteSelectedElements();
    await cubit.finalizeManipulation();

    final persisted = (await repository.getDocumentById('doc-1')).data!;
    expect(
      persisted.elements.any((e) => e.type == CanvasElementType.freeDraw),
      isTrue,
    );
    final persistedText = persisted.elements.whereType<TextElement>().single;
    expect(persistedText.text, 'hello world');
    expect(persistedText.isDeleted, isTrue);
  });
}
