import 'dart:ui';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';

class BackgroundGridPainter {
  static void drawBackground(PainterCtx ctx, Canvas canvas, Size size) {
    final worldMinX = -ctx.panOffset.dx / ctx.zoomLevel;
    final worldMinY = -ctx.panOffset.dy / ctx.zoomLevel;
    final worldMaxX = (size.width - ctx.panOffset.dx) / ctx.zoomLevel;
    final worldMaxY = (size.height - ctx.panOffset.dy) / ctx.zoomLevel;
    final rect = Rect.fromLTRB(worldMinX, worldMinY, worldMaxX, worldMaxY);
    final paint = Paint()..color = AppColors.canvasBackground;
    canvas.drawRect(rect, paint);
  }

  static void drawGrid(PainterCtx ctx, Canvas canvas, Size size) {
    final worldMinX = -ctx.panOffset.dx / ctx.zoomLevel;
    final worldMinY = -ctx.panOffset.dy / ctx.zoomLevel;
    final worldMaxX = (size.width - ctx.panOffset.dx) / ctx.zoomLevel;
    final worldMaxY = (size.height - ctx.panOffset.dy) / ctx.zoomLevel;

    // Ajusta o tamanho da célula da grade de acordo com o zoom para evitar renderizar milhões de pontos ao afastar a câmera
    double currentGridSize = AppConstants.gridSize;

    // 1. Manter uma distância visual mínima entre os pontos
    // (não renderizar pontos muito apertados um no outro).
    while (currentGridSize * ctx.zoomLevel < AppConstants.gridSize) {
      currentGridSize *= 2;
    }

    // 2. Hard-limit absoluto contra travamentos: 
    // Nunca renderizar mais que ~4000 pontos (grid 63x63 na tela),
    // garantindo performance O(1) fluída pro GPU (evita overpainting).
    int expectedCols = ((worldMaxX - worldMinX) / currentGridSize).ceil() + 1;
    int expectedRows = ((worldMaxY - worldMinY) / currentGridSize).ceil() + 1;
    while ((expectedCols * expectedRows) > 4000) {
      currentGridSize *= 2;
      expectedCols = ((worldMaxX - worldMinX) / currentGridSize).ceil() + 1;
      expectedRows = ((worldMaxY - worldMinY) / currentGridSize).ceil() + 1;
    }

    final startX = (worldMinX / currentGridSize).floorToDouble() * currentGridSize;
    final startY = (worldMinY / currentGridSize).floorToDouble() * currentGridSize;

    // Calculando o raio do ponto do grid
    // Ajusta o raio baseado no zoom e garante um tamanho mínimo/máximo
    final rawRadius = 0.5 / ctx.zoomLevel;
    final dotRadius = rawRadius.clamp(0.5, 2.0);

    // Usando Path com drawRect em vez de PointMode.points por causa de bug de renderização no Flutter Desktop/Windows
    // onde PointMode.points muitas vezes não renderiza de forma consistente
    final path = Path();
    for (double x = startX; x <= worldMaxX; x += currentGridSize) {
      for (double y = startY; y <= worldMaxY; y += currentGridSize) {
        path.addRect(Rect.fromCenter(center: Offset(x, y), width: dotRadius * 1.5, height: dotRadius * 1.5));
      }
    }

    final gridPaint = Paint()
      ..color = AppColors.gray400.withValues(alpha: 0.65) // Cor sutil mas visível! (O border era muito claro e invisível = falha visual)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(path, gridPaint);
  }
}
