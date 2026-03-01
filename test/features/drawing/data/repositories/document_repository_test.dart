import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/core/storage/queries.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockDatabase extends Mock implements Database {}

void main() {
  late DocumentRepository repository;
  late MockDatabaseService mockDatabaseService;
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockDatabase = MockDatabase();
    repository = DocumentRepository(mockDatabaseService);

    when(() => mockDatabaseService.database)
        .thenAnswer((_) async => mockDatabase);

    // Default matchers
    registerFallbackValue(ConflictAlgorithm.replace);
  });

  group('saveElement', () {
    test('should save text element with custom data separated', () async {
      final textElement = TextElement(
        id: 't1',
        x: 10,
        y: 20,
        width: 100,
        height: 50,
        strokeColor: Colors.black,
        updatedAt: DateTime.now(),
        text: 'Hello',
        fontSize: 20,
        backgroundColor: const Color(0xFFFF0000),
      );

      when(() => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1);

      await repository.saveElement('doc1', textElement);

      final captured = verify(() => mockDatabase.insert(
            Queries.tableCanvasElements,
            captureAny(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).captured;

      final map = captured.first as Map<String, dynamic>;

      // Verify standard fields are present
      expect(map['id'], 't1');
      expect(map['type'], 'text');

      // Verify custom data fields are REMOVED from main map
      expect(map.containsKey('text'), false);
      expect(map.containsKey('fontSize'), false);
      expect(map.containsKey('backgroundColor'), false);

      // Verify customData JSON contains them
      final customData = map['customData'] as String;
      expect(customData, contains('"text":"Hello"'));
      expect(customData, contains('"fontSize":20')); // 20 or 20.0
      expect(customData, contains('"backgroundColor":4294901760'));
    });

    test('should save rectangle element with empty custom data', () async {
      final rectElement = RectangleElement(
        id: 'r1',
        x: 0,
        y: 0,
        width: 10,
        height: 10,
        strokeColor: Colors.black,
        updatedAt: DateTime.now(),
      );

      when(() => mockDatabase.insert(
            any(),
            any(),
            conflictAlgorithm: any(named: 'conflictAlgorithm'),
          )).thenAnswer((_) async => 1);

      await repository.saveElement('doc1', rectElement);

      final captured = verify(() => mockDatabase.insert(
            Queries.tableCanvasElements,
            captureAny(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          )).captured;

      final map = captured.first as Map<String, dynamic>;

      expect(map['id'], 'r1');

      final customData = map['customData'] as String;
      expect(customData, '{}');
    });
  });
}
