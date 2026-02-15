import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

/// Contrato para persistÃªncia e recuperaÃ§Ã£o de documentos e elementos.
abstract class DocumentRepository {
  /// Recupera todos os documentos salvos.
  Future<List<DrawingDocument>> getDocuments();

  /// Recupera um documento especÃ­fico pelo ID.
  Future<DrawingDocument?> getDocumentById(String id);

  /// Salva ou atualiza um documento completo.
  Future<void> saveDocument(DrawingDocument document);

  /// Remove um documento.
  Future<void> deleteDocument(String id);

  /// Salva ou atualiza um elemento individual em um documento.
  Future<void> saveElement(String drawingId, CanvasElement element);

  /// Remove um elemento de um documento.
  Future<void> deleteElement(String drawingId, String elementId);
}

