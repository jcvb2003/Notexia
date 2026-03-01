import 'dart:async';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/core/errors/result.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/data/repositories/document_repository.dart';

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
    void Function(Failure?)? onComplete,
  }) {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(debounceDuration, () async {
      final result = await _repository.saveDocument(doc);
      if (result.isSuccess) {
        onComplete?.call(null); // Success
      } else {
        onComplete?.call(result.failure);
      }
    });
  }

  /// Salva um elemento individual imediatamente.
  Future<Result<void>> saveElement(
      String documentId, CanvasElement element) async {
    return await _repository.saveElement(documentId, element);
  }
}
