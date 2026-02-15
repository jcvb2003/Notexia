import 'package:equatable/equatable.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

class DrawingDocument extends Equatable {
  final String id;
  final String title;
  final List<CanvasElement> elements;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final bool isFavorite;

  const DrawingDocument({
    required this.id,
    required this.title,
    required this.elements,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    elements,
    createdAt,
    updatedAt,
    description,
    isFavorite,
  ];

  List<CanvasElement> get sortedElements {
    final sorted = List<CanvasElement>.from(elements);
    sorted.sort((a, b) => a.zIndex.compareTo(b.zIndex));
    return sorted;
  }

  DrawingDocument copyWith({
    String? title,
    List<CanvasElement>? elements,
    DateTime? updatedAt,
    String? description,
    bool? isFavorite,
  }) {
    return DrawingDocument(
      id: id,
      title: title ?? this.title,
      elements: elements ?? this.elements,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

