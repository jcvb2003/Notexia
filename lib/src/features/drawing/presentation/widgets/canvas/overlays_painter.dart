import 'dart:ui';
import 'package:notexia/src/core/utils/constants/ui_constants.dart';
import 'package:notexia/src/core/canvas/rendering/painters/dashed_painter.dart';
import 'package:notexia/src/features/drawing/domain/utils/selection_utils.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_painter.dart';

class OverlaysPainter {
  static void drawSelectionBox(PainterCtx ctx, Canvas canvas) {
    final rect = ctx.selectionBox;
    if (rect == null) return;
    final primaryColor = AppColors.primaryAccent;
    final selectionPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1.0 / ctx.zoomLevel
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, fillPaint);
    DashedPainter.drawDashedRRect(canvas, rect, selectionPaint);
  }

  static void drawHover(PainterCtx ctx, Canvas canvas) {
    if (ctx.hoveredElementId == null ||
        ctx.hoveredElementId!.isEmpty ||
        ctx.selectedElementIds.contains(ctx.hoveredElementId)) {
      return;
    }
    final element =
        ctx.elements.where((e) => e.id == ctx.hoveredElementId).firstOrNull;
    if (element == null) return;
    final hoverPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.save();
    if (element.angle != 0) {
      final centerX = element.x + element.width / 2;
      final centerY = element.y + element.height / 2;
      canvas.translate(centerX, centerY);
      canvas.rotate(element.angle);
      canvas.translate(-centerX, -centerY);
    }
    canvas.drawRect(element.bounds.inflate(4), hoverPaint);
    canvas.restore();
  }

  static void drawSelection(PainterCtx ctx, Canvas canvas) {
    if (ctx.selectedElementIds.isEmpty) return;
    final primaryColor = AppColors.primaryAccent;
    final selectionPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1.2 / ctx.zoomLevel
      ..style = PaintingStyle.stroke;
    final handlePaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;
    final handleStrokePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1.0 / ctx.zoomLevel
      ..style = PaintingStyle.stroke;
    final highlightPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final handleSize = 8.0 / ctx.zoomLevel;
    const rotateOffset = 24.0;
    for (final id in ctx.selectedElementIds) {
      final element = ctx.elements.where((e) => e.id == id).firstOrNull;
      if (element == null) continue;
      canvas.save();
      if (element.angle != 0) {
        final centerX = element.x + element.width / 2;
        final centerY = element.y + element.height / 2;
        canvas.translate(centerX, centerY);
        canvas.rotate(element.angle);
        canvas.translate(-centerX, -centerY);
      }
      final rect = element.bounds.inflate(6 / ctx.zoomLevel);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(4 / ctx.zoomLevel)),
        highlightPaint,
      );
      DashedPainter.drawDashedRRect(canvas, rect, selectionPaint);
      if (SelectionUtils.isLineElement(element)) {
        final endpoints = SelectionUtils.lineEndpoints(element);
        if (endpoints != null) {
          _drawHandle(
            canvas,
            endpoints.$1,
            handleSize,
            handlePaint,
            handleStrokePaint,
            ctx,
          );
          _drawHandle(
            canvas,
            endpoints.$2,
            handleSize,
            handlePaint,
            handleStrokePaint,
            ctx,
          );
        }
        canvas.restore();
        continue;
      }
      if (SelectionUtils.isResizableElementType(element.type)) {
        final handles = [
          rect.topLeft,
          rect.topRight,
          rect.bottomLeft,
          rect.bottomRight,
          rect.topCenter,
          rect.centerRight,
          rect.bottomCenter,
          rect.centerLeft,
        ];
        for (final pos in handles) {
          _drawHandle(
            canvas,
            pos,
            handleSize,
            handlePaint,
            handleStrokePaint,
            ctx,
          );
        }
        final rotateCenter = SelectionUtils.computeRotateHandleCenter(
          rect,
          ctx.zoomLevel,
          rotateOffset: rotateOffset,
        );
        canvas.drawLine(rect.topCenter, rotateCenter, selectionPaint);
        _drawHandle(
          canvas,
          rotateCenter,
          handleSize * 1.1,
          handlePaint,
          handleStrokePaint,
          ctx,
          isCircle: true,
        );
      }
      canvas.restore();
    }
  }

  static void drawEraserTrail(PainterCtx ctx, Canvas canvas) {
    if (!ctx.isEraserActive || ctx.eraserTrail.isEmpty) return;
    final points = ctx.eraserTrail;
    if (points.length == 1) {
      final radius = 6.0 / ctx.zoomLevel;
      final paint = Paint()
        ..color = AppColors.textPrimary.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points.first, radius, paint);
      return;
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final outerPaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.12)
      ..strokeWidth = 10.0 / ctx.zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final innerPaint = Paint()
      ..color = AppColors.textPrimary.withValues(alpha: 0.45)
      ..strokeWidth = 4.0 / ctx.zoomLevel
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, outerPaint);
    canvas.drawPath(path, innerPaint);
  }

  static void drawSnapGuides(PainterCtx ctx, Canvas canvas) {
    if (ctx.snapGuides.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.danger
      ..strokeWidth = 1.0 / ctx.zoomLevel
      ..style = PaintingStyle.stroke;

    for (final guide in ctx.snapGuides) {
      if (guide.isVertical) {
        canvas.drawLine(
          Offset(guide.offset, guide.min),
          Offset(guide.offset, guide.max),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(guide.min, guide.offset),
          Offset(guide.max, guide.offset),
          paint,
        );
      }
    }
  }

  static void _drawHandle(
    Canvas canvas,
    Offset position,
    double size,
    Paint fill,
    Paint stroke,
    PainterCtx ctx, {
    bool isCircle = false,
  }) {
    final rect = Rect.fromCenter(center: position, width: size, height: size);
    canvas.drawShadow(
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            rect,
            Radius.circular(isCircle ? size : 2 / ctx.zoomLevel),
          ),
        ),
      AppColors.textPrimary,
      2.0,
      false,
    );
    if (isCircle) {
      canvas.drawCircle(position, size / 2, fill);
      canvas.drawCircle(position, size / 2, stroke);
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(2 / ctx.zoomLevel)),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(2 / ctx.zoomLevel)),
        stroke,
      );
    }
  }
}
