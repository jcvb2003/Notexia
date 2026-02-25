import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';

class MockPersistenceService extends Mock implements PersistenceService {}

class MockCommandStackService extends Mock implements CommandStackService {}

void main() {
  late TextEditingDelegate delegate;
  late CanvasState baseState;
  late MockPersistenceService mockPersistence;
  late MockCommandStackService mockCommandStack;

  setUp(() {
    delegate = const TextEditingDelegate();
    mockPersistence = MockPersistenceService();
    mockCommandStack = MockCommandStackService();

    registerFallbackValue(ElementsCommand(
      before: const [],
      after: const [],
      applyElements: (_) {},
      label: 'fallback',
    ));

    registerFallbackValue(RectangleElement(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    ));

    baseState = CanvasState(
      document: DrawingDocument(
        id: 'doc1',
        title: 'Test',
        elements: [
          TextElement(
            id: 'text1',
            x: 100,
            y: 100,
            width: 200,
            height: 30,
            text: 'Hello',
            strokeColor: Colors.black,
            fontSize: 16,
            updatedAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  // Removed emitCapture helper as we now use Result data directly

  group('TextEditingDelegate', () {
    group('updateTextElement', () {
      test('updates text content and returns new state', () {
        final result = delegate.updateTextElement(
          state: baseState,
          elementId: 'text1',
          text: 'Updated text',
          scheduleSave: (_) {},
        );

        expect(result.isSuccess, isTrue);
        final updatedElement =
            result.data!.elements.whereType<TextElement>().first;
        expect(updatedElement.text, 'Updated text');
      });

      test('schedules save with updated document', () {
        DrawingDocument? savedDoc;
        final result = delegate.updateTextElement(
          state: baseState,
          elementId: 'text1',
          text: 'Saved text',
          scheduleSave: (doc) => savedDoc = doc,
        );

        expect(result.isSuccess, isTrue);
        expect(savedDoc, isNotNull);
        final savedElement = savedDoc!.elements.whereType<TextElement>().first;
        expect(savedElement.text, 'Saved text');
      });

      test('does not modify non-matching elements', () {
        final stateWithTwo = baseState.copyWith(
          document: baseState.document.copyWith(
            elements: [
              ...baseState.document.elements,
              RectangleElement(
                id: 'rect1',
                x: 0,
                y: 0,
                width: 50,
                height: 50,
                strokeColor: Colors.red,
                updatedAt: DateTime.now(),
              ),
            ],
          ),
        );

        final result = delegate.updateTextElement(
          state: stateWithTwo,
          elementId: 'text1',
          text: 'Changed',
          scheduleSave: (_) {},
        );

        expect(result.data!.elements.length, 2);
      });
    });

    group('setEditingText', () {
      test('sets editing text id', () {
        final result = delegate.setEditingText(
          state: baseState,
          id: 'text1',
        );

        expect(result.isSuccess, isTrue);
        expect(result.data!.editingTextId, 'text1');
      });

      test('clears editing text id', () {
        final editing = baseState.copyWith(
          interaction: baseState.interaction.copyWith(
            textEditing: baseState.interaction.textEditing.copyWith(
              editingTextId: 'text1',
            ),
          ),
        );

        final result = delegate.setEditingText(
          state: editing,
          id: null,
        );

        expect(result.data!.editingTextId, isNull);
      });
    });

    group('finalizeTextEditing', () {
      test('saves element and clears editing id on success', () async {
        when(() => mockPersistence.saveElement(any(), any()))
            .thenAnswer((_) async => Result.success(null));

        final editing = baseState.copyWith(
          interaction: baseState.interaction.copyWith(
            textEditing: baseState.interaction.textEditing.copyWith(
              editingTextId: 'text1',
            ),
          ),
        );

        final result = await delegate.finalizeTextEditing(
          state: editing,
          elementId: 'text1',
          persistenceService: mockPersistence,
        );

        verify(() => mockPersistence.saveElement('doc1', any())).called(1);
        expect(result.isSuccess, isTrue);
        expect(result.data!.editingTextId, isNull);
      });

      test('returns failure on save failure', () async {
        when(() => mockPersistence.saveElement(any(), any()))
            .thenThrow(Exception('Save failed'));

        final result = await delegate.finalizeTextEditing(
          state: baseState,
          elementId: 'text1',
          persistenceService: mockPersistence,
        );

        expect(result.isFailure, isTrue);
        expect(result.failure!.message, contains('Save failed'));
      });
    });

    group('commitTextEditing', () {
      test('deletes element when text is empty', () async {
        final result = await delegate.commitTextEditing(
          state: baseState,
          elementId: 'text1',
          text: '   ',
          scheduleSave: (_) {},
          persistenceService: mockPersistence,
          commandStack: mockCommandStack,
          applyCallback: (_) {},
        );

        expect(result.isSuccess, isTrue);
        expect(result.data!.document.elements, isEmpty);
        expect(result.data!.editingTextId, isNull);
        verify(() => mockCommandStack.add(any())).called(1);
      });

      test('updates and finalizes when text is not empty', () async {
        when(() => mockPersistence.saveElement(any(), any()))
            .thenAnswer((_) async => Result.success(null));

        final result = await delegate.commitTextEditing(
          state: baseState,
          elementId: 'text1',
          text: 'New content',
          scheduleSave: (_) {},
          persistenceService: mockPersistence,
          commandStack: mockCommandStack,
          applyCallback: (_) {},
        );

        expect(result.isSuccess, isTrue);
        final lastTextElement =
            result.data!.elements.whereType<TextElement>().first;
        expect(lastTextElement.text, 'New content');
      });
    });
  });
}
