import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/renderer_provider.dart';

class ElementsPainter {
  static void renderElements(PainterCtx ctx, Canvas canvas, Size size) {
    // Calcula o viewport visível em coordenadas do mundo
    // O canvas já tem a transformação aplicada, mas para culling precisamos saber
    // quais elementos estão na área visível da tela.
    // Viewport no mundo:
    final visibleRect = Rect.fromLTWH(
      -ctx.panOffset.dx / ctx.zoomLevel,
      -ctx.panOffset.dy / ctx.zoomLevel,
      size.width / ctx.zoomLevel,
      size.height / ctx.zoomLevel,
    );

    // Margem de segurança para evitar cortes abruptos em elementos rotacionados ou com strokes grossos
    final cullingRect = visibleRect.inflate(100);

    final sortedElements = ctx.elements.toList()
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    for (final element in sortedElements) {
      if (ctx.editingElementId == element.id) continue;
      if (element.isDeleted) continue;

      // Culling: verifica se o bounding box do elemento intercepta a viewport
      // Nota: element.bounds não considera rotação, mas a margem de segurança ajuda.
      // Para maior precisão, poderíamos calcular o rotated bounding box.
      if (!cullingRect.overlaps(element.bounds)) {
        continue;
      }

      renderSingleElement(ctx, canvas, element);
    }
  }

  static void renderSingleElement(
    PainterCtx ctx,
    Canvas canvas,
    CanvasElement element,
  ) {
    canvas.save();
    if (element.angle != 0) {
      final centerX = element.x + element.width / 2;
      final centerY = element.y + element.height / 2;
      canvas.translate(centerX, centerY);
      canvas.rotate(element.angle);
      canvas.translate(-centerX, -centerY);
    }

    final renderer = RendererProvider.getRenderer(element);
    renderer.render(canvas, element);

    canvas.restore();
  }
}
