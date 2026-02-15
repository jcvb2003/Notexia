/// Tipos de elementos que podem ser desenhados no canvas.
enum CanvasElementType {
  rectangle,
  ellipse,
  diamond,
  triangle,
  line,
  arrow,
  freeDraw,
  text,
  image,
  eraser,
  selection,
  navigation,
}

/// Estilos de traço para os elementos.
enum StrokeStyle { solid, dashed, dotted }

/// Tipos de preenchimento para as formas.
enum FillType { transparent, solid, hachure, crossHatch }
