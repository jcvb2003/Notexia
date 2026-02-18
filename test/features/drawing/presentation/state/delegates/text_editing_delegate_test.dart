import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';

class MockPersistenceService extends Mock implements PersistenceService {}

void main() {
  late TextEditingDelegate delegate;
  late CanvasState baseState;
  late MockPersistenceService mockPersistence;
  late List<CanvasState> emittedStates;

  setUp(() {
    delegate = const TextEditingDelegate();
    mockPersistence = MockPersistenceService();
    emittedStates = [];

    registerFallbackValue(CanvasElement.rectangle(
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
          CanvasElement.text(
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

  void emitCapture(CanvasState state) {
    emittedStates.add(state);
  }

  group('TextEditingDelegate', () {
    group('updateTextElement', () {
      test('updates text content and emits new state', () {
        delegate.updateTextElement(
          state: baseState,
          elementId: 'text1',
          text: 'Updated text',
          emit: emitCapture,
          scheduleSave: (_) {},
        );

        expect(emittedStates, hasLength(1));
        final updatedElement =
            emittedStates.first.elements.whereType<TextElement>().first;
        expect(updatedElement.text, 'Updated text');
      });

      test('schedules save with updated document', () {
        DrawingDocument? savedDoc;
        delegate.updateTextElement(
          state: baseState,
          elementId: 'text1',
          text: 'Saved text',
          emit: emitCapture,
          scheduleSave: (doc) => savedDoc = doc,
        );

        expect(savedDoc, isNotNull);
        final savedElement = savedDoc!.elements.whereType<TextElement>().first;
        expect(savedElement.text, 'Saved text');
      });

      test('does not modify non-matching elements', () {
        final stateWithTwo = baseState.copyWith(
          document: baseState.document.copyWith(
            elements: [
              ...baseState.document.elements,
              CanvasElement.rectangle(
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

        delegate.updateTextElement(
          state: stateWithTwo,
          elementId: 'text1',
          text: 'Changed',
          emit: emitCapture,
          scheduleSave: (_) {},
        );

        expect(emittedStates.first.elements.length, 2);
      });
    });

    group('setEditingText', () {
      test('sets editing text id', () {
        delegate.setEditingText(
          state: baseState,
          id: 'text1',
          emit: emitCapture,
        );

        expect(emittedStates, hasLength(1));
        expect(emittedStates.first.editingTextId, 'text1');
      });

      test('clears editing text id', () {
        final editing = baseState.copyWith(
          interaction: baseState.interaction.copyWith(
            textEditing: baseState.interaction.textEditing.copyWith(
              editingTextId: 'text1',
            ),
          ),
        );

        delegate.setEditingText(
          state: editing,
          id: null,
          emit: emitCapture,
        );

        expect(emittedStates.first.editingTextId, isNull);
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

        await delegate.finalizeTextEditing(
          state: editing,
          elementId: 'text1',
          persistenceService: mockPersistence,
          emit: emitCapture,
        );

        verify(() => mockPersistence.saveElement('doc1', any())).called(1);
        expect(emittedStates, hasLength(1));
        expect(emittedStates.first.editingTextId, isNull);
      });

      test('emits error state on save failure', () async {
        when(() => mockPersistence.saveElement(any(), any()))
            .thenThrow(Exception('Save failed'));

        await delegate.finalizeTextEditing(
          state: baseState,
          elementId: 'text1',
          persistenceService: mockPersistence,
          emit: emitCapture,
        );

        expect(emittedStates, hasLength(1));
        expect(emittedStates.first.error, contains('Save failed'));
      });
    });

    group('commitTextEditing', () {
      test('deletes element when text is empty', () {
        String? deletedId;

        delegate.commitTextEditing(
          state: baseState,
          elementId: 'text1',
          text: '   ',
          emit: emitCapture,
          scheduleSave: (_) {},
          persistenceService: mockPersistence,
          deleteElementByIdCallback: (id) => deletedId = id,
        );

        expect(deletedId, 'text1');
      });

      test('updates and finalizes when text is not empty', () {
        when(() => mockPersistence.saveElement(any(), any()))
            .thenAnswer((_) async => Result.success(null));

        delegate.commitTextEditing(
          state: baseState,
          elementId: 'text1',
          text: 'New content',
          emit: emitCapture,
          scheduleSave: (_) {},
          persistenceService: mockPersistence,
          deleteElementByIdCallback: (_) {},
        );

        // Should have emitted: updateTextElement + finalizeTextEditing
        expect(emittedStates.length, greaterThanOrEqualTo(1));
        final lastTextElement =
            emittedStates.first.elements.whereType<TextElement>().first;
        expect(lastTextElement.text, 'New content');
      });
    });
  });
}
