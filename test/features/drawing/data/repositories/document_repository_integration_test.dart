import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';
import 'package:notexia/src/core/storage/queries.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late Database db;
  late DocumentRepository repository;
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

    repository = DocumentRepository(mockDbService);
  });

  tearDown(() async {
    await db.close();
  });

  group('DocumentRepository Integration', () {
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

    test(
        'saveDocument removes ghost elements that were deleted from the document',
        () async {
      // Documento com 2 elementos
      final docWith2 = DrawingDocument(
        id: 'doc-ghost',
        title: 'Ghost Test',
        createdAt: now,
        updatedAt: now,
        elements: [
          RectangleElement(
            id: 'rect-keep',
            x: 0,
            y: 0,
            width: 50,
            height: 50,
            strokeColor: const Color(0xFF00FF00),
            updatedAt: now,
          ),
          RectangleElement(
            id: 'rect-remove',
            x: 100,
            y: 100,
            width: 50,
            height: 50,
            strokeColor: const Color(0xFFFF0000),
            updatedAt: now,
          ),
        ],
      );

      // Salvar com 2 elementos
      final save1 = await repository.saveDocument(docWith2);
      expect(save1.isSuccess, isTrue);

      // Verificar que os 2 existem
      final load1 = await repository.getDocumentById('doc-ghost');
      expect(load1.data!.elements.length, 2);

      // Salvar novamente com apenas 1 elemento (simulando deleção do segundo)
      final docWith1 = docWith2.copyWith(
        elements: [docWith2.elements.first],
      );
      final save2 = await repository.saveDocument(docWith1);
      expect(save2.isSuccess, isTrue);

      // Recarregar e verificar que só o elemento mantido existe
      final load2 = await repository.getDocumentById('doc-ghost');
      expect(load2.isSuccess, isTrue);
      expect(load2.data!.elements.length, 1);
      expect(load2.data!.elements.first.id, 'rect-keep');
    });
  });
}
