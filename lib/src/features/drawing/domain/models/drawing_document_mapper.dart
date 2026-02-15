import 'dart:convert';
import 'package:notexia/src/features/drawing/domain/models/canvas_element_mapper.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

class DrawingDocumentMapper {
  static Map<String, dynamic> toMap(
    DrawingDocument doc, {
    bool useIntColors = false,
    bool useIntBools = false,
  }) {
    return {
      'id': doc.id,
      'title': doc.title,
      'description': doc.description,
      'isFavorite': useIntBools ? (doc.isFavorite ? 1 : 0) : doc.isFavorite,
      'createdAt': doc.createdAt.toIso8601String(),
      'updatedAt': doc.updatedAt.toIso8601String(),
      'elements': doc.elements
          .map((e) => CanvasElementMapper.toMap(
                e,
                useIntColors: useIntColors,
                useIntBools: useIntBools,
              ))
          .toList(),
    };
  }

  static DrawingDocument fromMap(Map<String, dynamic> map) {
    final createdAtRaw = map['createdAt'] as String?;
    final updatedAtRaw = map['updatedAt'] as String?;
    final createdAt =
        createdAtRaw != null ? DateTime.parse(createdAtRaw) : DateTime.now();
    final updatedAt =
        updatedAtRaw != null ? DateTime.parse(updatedAtRaw) : DateTime.now();

    final isFavoriteRaw = map['isFavorite'];
    final bool isFavorite;
    if (isFavoriteRaw is int) {
      isFavorite = isFavoriteRaw == 1;
    } else if (isFavoriteRaw is bool) {
      isFavorite = isFavoriteRaw;
    } else {
      isFavorite = false;
    }

    return DrawingDocument(
      id: map['id'] as String,
      title: map['title'] as String,
      elements: (map['elements'] as List)
          .map((e) => CanvasElementMapper.fromMap(e as Map<String, dynamic>))
          .toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      description: map['description'] as String?,
      isFavorite: isFavorite,
    );
  }

  static String toJson(
    DrawingDocument doc, {
    bool useIntColors = false,
    bool useIntBools = false,
  }) {
    return json.encode(toMap(
      doc,
      useIntColors: useIntColors,
      useIntBools: useIntBools,
    ));
  }

  static DrawingDocument fromJson(String source) {
    return fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
