import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class _CachedPathData {
  final Path path;
  final int pointsCount;
  final Offset origin;
  final Picture? picture;

  _CachedPathData(this.path, this.pointsCount, this.origin, {this.picture});

  void dispose() {
    picture?.dispose();
  }
}

class FreeDrawRenderer implements ElementRenderer<FreeDrawElement> {
  static final Map<String, _CachedPathData> _cache = {};
  static const int _maxCacheSize = 1000;

  /// Limpa todo o cache estático (ideal ao trocar de documento).
  static void clearCache() {
    for (final cached in _cache.values) {
      cached.dispose();
    }
    _cache.clear();
  }

  /// Remove entradas de cache de elementos específicos (ex: caso de exclusão).
  static void invalidateCache(Iterable<String> elementIds) {
    for (final id in elementIds) {
      _cache[id]?.dispose();
      _cache.remove(id);
    }
  }

  @override
  void render(Canvas canvas, FreeDrawElement element) {
    if (element.points.isEmpty) return;

    final paint = Paint()
      ..color = element.strokeColor.withValues(alpha: element.opacity)
      ..strokeWidth = element.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (element.points.length == 1) {
      final point = Offset(
        element.x + element.points[0].dx,
        element.y + element.points[0].dy,
      );
      final path = Path();
      path.addOval(
          Rect.fromCircle(center: point, radius: element.strokeWidth / 2));
      canvas.drawPath(path, paint);
      return;
    }

    _CachedPathData? cached = _cache[element.id];
    final currentOrigin = Offset(element.x, element.y);

    if (cached != null &&
        cached.pointsCount == element.points.length &&
        cached.origin == currentOrigin) {
      if (cached.picture != null) {
        canvas.save();
        canvas.translate(element.x, element.y);
        canvas.drawPicture(cached.picture!);
        canvas.restore();
        return;
      }
      final picture = _recordPicture(cached.path, element, paint);

      cached.dispose();
      final newCache = _CachedPathData(
          cached.path, cached.pointsCount, cached.origin,
          picture: picture);
      _cache[element.id] = newCache;

      canvas.save();
      canvas.translate(element.x, element.y);
      canvas.drawPicture(picture);
      canvas.restore();
      return;
    }

    Path mainPath;

    if (cached != null &&
        element.points.length >= cached.pointsCount &&
        cached.origin == currentOrigin) {
      mainPath = cached.path;

      if (element.points.length > cached.pointsCount) {
        final startSafe = cached.pointsCount > 1 ? cached.pointsCount - 1 : 1;
        for (int i = startSafe; i < element.points.length - 1; i++) {
          final current = element.points[i];
          final next = element.points[i + 1];
          final mid = Offset(
            (current.dx + next.dx) / 2,
            (current.dy + next.dy) / 2,
          );
          mainPath.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
        }
      }
    } else {
      if (cached != null &&
          cached.origin != currentOrigin &&
          element.points.length == cached.pointsCount) {
        final shift = cached.origin - currentOrigin;
        mainPath = cached.path.shift(shift);
      } else {
        mainPath = Path();
        final firstPoint = element.points[0];
        mainPath.moveTo(firstPoint.dx, firstPoint.dy);

        for (int i = 1; i < element.points.length - 1; i++) {
          final current = element.points[i];
          final next = element.points[i + 1];
          final mid = Offset(
            (current.dx + next.dx) / 2,
            (current.dy + next.dy) / 2,
          );
          mainPath.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
        }
      }
    }

    final newCache = _CachedPathData(
      mainPath,
      element.points.length,
      currentOrigin,
      picture: null,
    );

    if (_cache.length > _maxCacheSize) {
      _cache.clear();
    }

    if (_cache.containsKey(element.id)) {
      _cache[element.id]!.dispose();
    }
    _cache[element.id] = newCache;

    canvas.save();
    canvas.translate(element.x, element.y);

    final renderPath = Path.from(mainPath);
    final lastPoint = element.points.last;
    renderPath.lineTo(lastPoint.dx, lastPoint.dy);

    canvas.drawPath(renderPath, paint);
    canvas.restore();
  }

  Picture _recordPicture(Path mainPath, FreeDrawElement element, Paint paint) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final renderPath = Path.from(mainPath);
    final lastPoint = element.points.last;
    renderPath.lineTo(lastPoint.dx, lastPoint.dy);

    canvas.drawPath(renderPath, paint);
    return recorder.endRecording();
  }
}
