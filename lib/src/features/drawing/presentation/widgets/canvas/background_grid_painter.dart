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

    final gridSize = AppConstants.gridSize;
    final startX = (worldMinX / gridSize).floorToDouble() * gridSize;
    final startY = (worldMinY / gridSize).floorToDouble() * gridSize;

    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.4)
      ..strokeWidth = 0.5;

    final path = Path();
    for (double x = startX; x <= worldMaxX; x += gridSize) {
      path.moveTo(x, worldMinY);
      path.lineTo(x, worldMaxY);
    }
    for (double y = startY; y <= worldMaxY; y += gridSize) {
      path.moveTo(worldMinX, y);
      path.lineTo(worldMaxX, y);
    }
    canvas.drawPath(path, gridPaint);
  }
}
