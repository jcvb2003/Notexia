import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';
import 'package:notexia/src/core/storage/queries.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository_impl.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late Database db;
  late DocumentRepositoryImpl repository;
  late MockDatabaseService mockDbService;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    db = await openDatabase(inMemoryDatabasePath);
    await db.execute('PRAGMA foreign_keys = ON');
    await db.execute(Queries.createDocumentsTable);
    await db.execute(Queries.createCanvasElementsTable);

    mockDbService = MockDatabaseService();
    when(() => mockDbService.database).thenAnswer((_) async => db);

    repository = DocumentRepositoryImpl(mockDbService);
  });

  tearDown(() async {
    await db.close();
  });

  group('DocumentRepositoryImpl Integration', () {
    final now = DateTime(2026, 1, 1);
    final testDoc = DrawingDocument(
      id: 'doc-1',
      title: 'Test Doc',
      createdAt: now,
      updatedAt: now,
      elements: [
        RectangleElement(
          id: 'rect-1',
          x: 10,
          y: 10,
          width: 100,
          height: 100,
          strokeColor: const Color(0xFFFF0000),
          updatedAt: now,
        ),
      ],
    );

    test('saveDocument and getDocumentById', () async {
      final saveResult = await repository.saveDocument(testDoc);
      expect(saveResult.isSuccess, isTrue);

      final result = await repository.getDocumentById(testDoc.id);
      expect(result.isSuccess, isTrue);

      final retrieved = result.data;
      expect(retrieved, isNotNull);
      expect(retrieved!.id, testDoc.id);
      expect(retrieved.title, testDoc.title);
      expect(retrieved.elements.length, 1);
      expect(retrieved.elements.first, isA<RectangleElement>());
      expect(retrieved.elements.first.id, 'rect-1');
      expect(retrieved.elements.first.strokeColor.toARGB32(),
          const Color(0xFFFF0000).toARGB32());
    });

    test(
        'getDocuments returns list of documents (without full elements initially)',
        () async {
      await repository.saveDocument(testDoc);
      await repository.saveDocument(DrawingDocument(
        id: 'doc-2',
        title: 'Doc 2',
        elements: const [],
        createdAt: now,
        updatedAt: now,
      ));

      final result = await repository.getDocuments();
      expect(result.isSuccess, isTrue);

      final docs = result.data!;
      expect(docs.length, 2);
      expect(docs.any((d) => d.id == 'doc-1'), isTrue);
      expect(docs.any((d) => d.id == 'doc-2'), isTrue);
      // O repositório getDocuments não carrega elementos por performance
      expect(docs.first.elements, isEmpty);
    });

    test('saveElement updates individual element', () async {
      await repository.saveDocument(testDoc);

      final updatedRect = testDoc.elements.first.copyWith(
        width: 200,
      ) as RectangleElement;

      final saveResult = await repository.saveElement(testDoc.id, updatedRect);
      expect(saveResult.isSuccess, isTrue);

      final result = await repository.getDocumentById(testDoc.id);
      expect(result.isSuccess, isTrue);
      expect(result.data!.elements.first.width, 200);
    });

    test('deleteElement removes specific element', () async {
      await repository.saveDocument(testDoc);

      final deleteResult = await repository.deleteElement(testDoc.id, 'rect-1');
      expect(deleteResult.isSuccess, isTrue);

      final result = await repository.getDocumentById(testDoc.id);
      expect(result.isSuccess, isTrue);
      expect(result.data!.elements, isEmpty);
    });

    test('deleteDocument removes document and its elements (cascade)',
        () async {
      await repository.saveDocument(testDoc);

      final deleteResult = await repository.deleteDocument(testDoc.id);
      expect(deleteResult.isSuccess, isTrue);

      final result = await repository.getDocumentById(testDoc.id);
      expect(result.isSuccess, isTrue);
      expect(result.data, isNull);

      // Verificar se os elementos foram removidos (cascade manual ou automático)
      final elementMaps = await db.query(
        'canvas_elements',
        where: 'documentId = ?',
        whereArgs: [testDoc.id],
      );
      expect(elementMaps, isEmpty);
    });
  });
}
