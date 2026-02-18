import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/core/storage/queries.dart';
import 'package:notexia/src/core/storage/local_database/database_service.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DatabaseService _dbService;

  DocumentRepositoryImpl(this._dbService);

  @override
  Future<Result<List<DrawingDocument>>> getDocuments() async {
    try {
      final db = await _dbService.database;
      final List<Map<String, dynamic>> maps =
          await db.query(Queries.tableDocuments);

      final documents = maps.map((map) {
        final fullMap = Map<String, dynamic>.from(map);
        fullMap['elements'] = <Map<String, dynamic>>[];
        return DrawingDocumentMapper.fromMap(fullMap);
      }).toList();

      return Result.success(documents);
    } catch (e) {
      return Result.failure(DatabaseFailure('Erro ao carregar documentos: $e'));
    }
  }

  @override
  Future<Result<DrawingDocument?>> getDocumentById(String id) async {
    try {
      final db = await _dbService.database;

      final docMaps = await db.query(
        Queries.tableDocuments,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (docMaps.isEmpty) return Result.success(null);

      final elementMaps = await db.query(
        Queries.tableCanvasElements,
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
      return Result.success(doc.copyWith(elements: elements));
    } catch (e) {
      return Result.failure(
          DatabaseFailure('Erro ao carregar documento $id: $e'));
    }
  }

  @override
  Future<Result<void>> saveDocument(DrawingDocument document) async {
    try {
      final db = await _dbService.database;
      final docMap = DrawingDocumentMapper.toMap(
        document,
        useIntBools: true,
        useIntColors: true,
      );
      final elements =
          (docMap.remove('elements') as List).cast<Map<String, dynamic>>();

      await db.transaction((txn) async {
        await txn.insert(
          Queries.tableDocuments,
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
            Queries.tableCanvasElements,
            cleanedMap,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Erro ao salvar documento: $e'));
    }
  }

  @override
  Future<Result<void>> deleteDocument(String id) async {
    try {
      final db = await _dbService.database;
      await db.delete(Queries.tableDocuments, where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Erro ao remover documento: $e'));
    }
  }

  @override
  Future<Result<void>> saveElement(
      String drawingId, CanvasElement element) async {
    try {
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
        Queries.tableCanvasElements,
        cleanedMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Erro ao salvar elemento: $e'));
    }
  }

  /// Separa campos específicos do tipo de elemento para o campo customData
  (Map<String, dynamic>, String) _separateCustomData(
    Map<String, dynamic> sourceMap,
  ) {
    final customData = <String, dynamic>{};

    final typeName = sourceMap['type'] as String;
    final type = CanvasElementType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => CanvasElementType.rectangle,
    );

    // Lista de chaves específicas do tipo que devem ir para customData
    final keysToRemove = CanvasElementMapper.customDataKeys(type);

    for (var key in keysToRemove) {
      if (sourceMap.containsKey(key)) {
        customData[key] = sourceMap.remove(key);
      }
    }

    return (sourceMap, jsonEncode(customData));
  }

  @override
  Future<Result<void>> deleteElement(String drawingId, String elementId) async {
    try {
      final db = await _dbService.database;
      await db.delete(
        Queries.tableCanvasElements,
        where: 'id = ? AND documentId = ?',
        whereArgs: [elementId, drawingId],
      );
      return Result.success(null);
    } catch (e) {
      return Result.failure(DatabaseFailure('Erro ao remover elemento: $e'));
    }
  }
}
