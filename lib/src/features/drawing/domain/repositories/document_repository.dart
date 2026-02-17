import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

/// Contrato para persistÃªncia e recuperaÃ§Ã£o de documentos e elementos.
abstract class DocumentRepository {
  /// Recupera todos os documentos salvos.
  Future<Result<List<DrawingDocument>>> getDocuments();

  /// Recupera um documento especÃ­fico pelo ID.
  Future<Result<DrawingDocument?>> getDocumentById(String id);

  /// Salva ou atualiza um documento completo.
  Future<Result<void>> saveDocument(DrawingDocument document);

  /// Remove um documento.
  Future<Result<void>> deleteDocument(String id);

  /// Salva ou atualiza um elemento individual em um documento.
  Future<Result<void>> saveElement(String drawingId, CanvasElement element);

  /// Remove um elemento de um documento.
  Future<Result<void>> deleteElement(String drawingId, String elementId);
}
