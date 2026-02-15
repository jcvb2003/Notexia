import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DatabaseService _dbService;

  DocumentRepositoryImpl(this._dbService);

  @override
  Future<List<DrawingDocument>> getDocuments() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('documents');

    return maps.map((map) {
      final fullMap = Map<String, dynamic>.from(map);
      fullMap['elements'] = <Map<String, dynamic>>[];
      return DrawingDocumentMapper.fromMap(fullMap);
    }).toList();
  }

  @override
  Future<DrawingDocument?> getDocumentById(String id) async {
    final db = await _dbService.database;

    final docMaps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (docMaps.isEmpty) return null;

    final elementMaps = await db.query(
      'canvas_elements',
      where: 'documentId = ?',
      whereArgs: [id],
    );

    final List<CanvasElement> elements = elementMaps.map((map) {
      final Map<String, dynamic> fullMap = Map.from(map);
      if (map['customData'] != null) {
        final customData =
            jsonDecode(map['customData'] as String) as Map<String, dynamic>;
        fullMap.addAll(customData);
      }
      return CanvasElementMapper.fromMap(fullMap);
    }).toList();

    final docMap = Map<String, dynamic>.from(docMaps.first);
    docMap['elements'] = [];

    final doc = DrawingDocumentMapper.fromMap(docMap);
    return doc.copyWith(elements: elements);
  }

  @override
  Future<void> saveDocument(DrawingDocument document) async {
    final db = await _dbService.database;
    final docMap = DrawingDocumentMapper.toMap(
      document,
      useIntBools: true,
      useIntColors: true,
    );
    final elements = docMap.remove('elements') as List;

    await db.transaction((txn) async {
      await txn.insert(
        'documents',
        docMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Sincronizar elementos
      for (var elementMap in elements) {
        final (cleanedMap, customDataJson) = _separateCustomData(
          Map.from(elementMap),
        );

        cleanedMap['documentId'] = document.id;
        cleanedMap['customData'] = customDataJson;

        await txn.insert(
          'canvas_elements',
          cleanedMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<void> deleteDocument(String id) async {
    final db = await _dbService.database;
    await db.delete('documents', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> saveElement(String drawingId, CanvasElement element) async {
    final db = await _dbService.database;
    final elementMap = CanvasElementMapper.toMap(
      element,
      useIntColors: true,
      useIntBools: true,
    );

    final (cleanedMap, customDataJson) = _separateCustomData(elementMap);

    cleanedMap['documentId'] = drawingId;
    cleanedMap['customData'] = customDataJson;

    await db.insert(
      'canvas_elements',
      cleanedMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Separa campos específicos do tipo de elemento para o campo customData
  (Map<String, dynamic>, String) _separateCustomData(
    Map<String, dynamic> sourceMap,
  ) {
    final customData = <String, dynamic>{};
    // Lista de chaves que não pertencem à tabela base e devem ir para customData
    const keysToRemove = [
      'points',
      'text',
      'fontFamily',
      'fontSize',
      'textAlign',
      'fileId',
      'status',
      'scale',
    ];

    for (var key in keysToRemove) {
      if (sourceMap.containsKey(key)) {
        customData[key] = sourceMap.remove(key);
      }
    }

    return (sourceMap, jsonEncode(customData));
  }

  @override
  Future<void> deleteElement(String drawingId, String elementId) async {
    final db = await _dbService.database;
    await db.delete(
      'canvas_elements',
      where: 'id = ? AND documentId = ?',
      whereArgs: [elementId, drawingId],
    );
  }
}
