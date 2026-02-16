import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/presentation/rendering/element_renderer.dart';

class _CachedPathData {
  final Path path;
  final int pointsCount;
  final Offset origin;

  _CachedPathData(this.path, this.pointsCount, this.origin);
}

class FreeDrawRenderer implements ElementRenderer<FreeDrawElement> {
  // Cache global para persistir entre frames do DynamicCanvasPainter
  static final Map<String, _CachedPathData> _cache = {};

  @override
  void render(Canvas canvas, FreeDrawElement element) {
    if (element.points.isEmpty) return;

    final paint = Paint()
      ..color = element.strokeColor.withValues(alpha: element.opacity)
      ..strokeWidth = element.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // Caso simples: ponto único
    if (element.points.length == 1) {
      final point = Offset(
        element.x + element.points[0].dx,
        element.y + element.points[0].dy,
      );
      // Não usamos cache para pontos simples (círculo) pois é barato
      final path = Path();
      path.addOval(Rect.fromCircle(center: point, radius: element.strokeWidth));
      canvas.drawPath(path, paint);
      return;
    }

    // Tenta recuperar do cache
    Path mainPath;
    final cached = _cache[element.id];
    final currentOrigin = Offset(element.x, element.y);

    // Lógica de Cache
    // Usamos o cache se o elemento existe e o número de pontos aumentou ou manteve (append)
    // Se diminuiu (undo) ou não existe, rebuild total.
    if (cached != null && element.points.length >= cached.pointsCount) {
      // Verifica se a origem mudou (normalização) e aplica shift
      if (cached.origin != currentOrigin) {
        final shift = cached.origin - currentOrigin;
        // Se a origem moveu para ESQUERDA (x diminuiu), shift.dx > 0.
        // Os pontos relativos aumentaram. O Path antigo estava com coords menores.
        // Espera.
        // P_world = Origin + P_local.
        // P_world deve ser constante.
        // OldOf + OldPlocal = NewOf + NewPlocal
        // NewPlocal = OldOf - NewOf + OldPlocal.
        // O Path armazena P_local. Queremos transformar para NewPlocal.
        // Path.shift soma o offset a todos os pontos.
        // Então shift = OldOf - NewOf.
        mainPath = cached.path.shift(shift);
      } else {
        mainPath = cached.path;
      }

      // Adiciona novos segmentos (Append)
      // O loop original vai de i=1 até points.length - 1
      // cached.pointsCount incluía até o último.
      // Se tinhamos 5 pontos (indices 0..4). Loop foi até i=3.
      // mainPath tem curvas até mid(3,4).
      // Agora temos 6 pontos (0..5). Precisamos i=4.
      // i começa em (cached.pointsCount - 1).
      // Ex: cached=5. start=4. Loop i=4. quad(p4, mid(4,5)).
      // Correto.

      if (element.points.length > cached.pointsCount) {
        final startSafe = cached.pointsCount > 1 ? cached.pointsCount - 1 : 1;

        for (int i = startSafe; i < element.points.length - 1; i++) {
          final current = element.points[i]; // Já relativo ao novo x,y
          final next = element.points[i + 1];
          final mid = Offset(
            (current.dx + next.dx) / 2,
            (current.dy + next.dy) / 2,
          );
          mainPath.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
        }
      }
    } else {
      // Rebuild total (Primeira vez ou Invalidação)
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

    // Atualiza cache com o path limpo (sem o lineTo final)
    _cache[element.id] = _CachedPathData(
      mainPath,
      element.points.length,
      currentOrigin,
    );

    // Prepara para desenhar
    // O path contem coordenadas LOCAIS. Precisamos transladar para desenhar no lugar certo
    // ou fazer shift.
    // O código original somava element.x a cada ponto.
    // Aqui mantivemos mainPath com coordenadas SÓ PONTOS (relativas a element.x,y).
    // Então usamos translate.

    canvas.save();
    canvas.translate(element.x, element.y);

    // Adiciona o segmento final (lineTo) em uma cópia para não sujar o cache
    // Use Path.from para copiar barato (referencia interna Skia até escrita)
    final renderPath = Path.from(mainPath);
    final lastPoint = element.points.last;
    renderPath.lineTo(lastPoint.dx, lastPoint.dy);

    canvas.drawPath(renderPath, paint);
    canvas.restore();
  }
}
