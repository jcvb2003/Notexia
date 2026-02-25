import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockDrawingDocument extends Mock implements DrawingDocument {}

class DrawingDocumentFake extends Fake implements DrawingDocument {}

void main() {
  setUpAll(() {
    registerFallbackValue(DrawingDocumentFake());
    registerFallbackValue(RectangleElement(
      id: 'fallback',
      x: 0,
      y: 0,
      width: 1,
      height: 1,
      strokeColor: Colors.black,
      updatedAt: DateTime.now(),
    ));
  });

  late PersistenceService persistenceService;
  late MockDocumentRepository mockRepository;

  setUp(() {
    mockRepository = MockDocumentRepository();
    persistenceService = PersistenceService(mockRepository);
  });

  tearDown(() {
    persistenceService.dispose();
  });

  group('PersistenceService', () {
    test('scheduleSaveDocument calls repository after debounce', () async {
      final doc = MockDrawingDocument();
      when(() => mockRepository.saveDocument(any()))
          .thenAnswer((_) async => Result.success(null));

      persistenceService.scheduleSaveDocument(
        doc,
        debounceDuration: const Duration(milliseconds: 50),
      );

      // Should not be called immediately
      verifyNever(() => mockRepository.saveDocument(doc));

      // Wait for debounce
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockRepository.saveDocument(doc)).called(1);
    });

    test('scheduleSaveDocument cancels previous timer on new call', () async {
      final doc1 = MockDrawingDocument();
      final doc2 = MockDrawingDocument();
      when(() => mockRepository.saveDocument(any()))
          .thenAnswer((_) async => Result.success(null));

      persistenceService.scheduleSaveDocument(doc1,
          debounceDuration: const Duration(milliseconds: 50));
      persistenceService.scheduleSaveDocument(doc2,
          debounceDuration: const Duration(milliseconds: 50));

      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(() => mockRepository.saveDocument(doc1));
      verify(() => mockRepository.saveDocument(doc2)).called(1);
    });

    test('saveElement calls repository immediately', () async {
      final element = RectangleElement(
        id: 'elem-1',
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        strokeColor: Colors.black,
        updatedAt: DateTime.now(),
      );
      const docId = 'doc-123';
      when(() => mockRepository.saveElement(any(), any()))
          .thenAnswer((_) async => Result.success(null));

      await persistenceService.saveElement(docId, element);

      verify(() => mockRepository.saveElement(docId, element)).called(1);
    });

    test('onComplete is called with null on success', () async {
      final doc = MockDrawingDocument();
      Failure? result;
      var called = false;
      when(() => mockRepository.saveDocument(any()))
          .thenAnswer((_) async => Result.success(null));

      persistenceService.scheduleSaveDocument(
        doc,
        debounceDuration: Duration.zero,
        onComplete: (failure) {
          result = failure;
          called = true;
        },
      );

      await Future.delayed(Duration.zero);
      expect(called, isTrue);
      expect(result, isNull);
    });

    test('onComplete is called with failure object on failure', () async {
      final doc = MockDrawingDocument();
      Failure? result;
      const failure = DatabaseFailure('Save failed');
      when(() => mockRepository.saveDocument(any()))
          .thenAnswer((_) async => Result.failure(failure));

      persistenceService.scheduleSaveDocument(
        doc,
        debounceDuration: Duration.zero,
        onComplete: (f) => result = f,
      );

      await Future.delayed(Duration.zero);
      expect(result, equals(failure));
    });
  });
}
