import 'dart:async';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';

class PersistenceService {
  final DocumentRepository _repository;
  Timer? _saveDebounceTimer;

  PersistenceService(this._repository);

  void dispose() {
    _saveDebounceTimer?.cancel();
  }

  /// Agenda o salvamento do documento com debounce.
  void scheduleSaveDocument(
    DrawingDocument doc, {
    Duration debounceDuration = const Duration(milliseconds: 350),
    void Function(String?)? onComplete,
  }) {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(debounceDuration, () async {
      try {
        await _repository.saveDocument(doc);
        onComplete?.call(null); // Success
      } catch (e) {
        onComplete?.call(e.toString()); // Error
      }
    });
  }

  /// Salva um elemento individual imediatamente.
  Future<void> saveElement(String documentId, CanvasElement element) async {
    await _repository.saveElement(documentId, element);
  }
}
