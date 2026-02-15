import 'package:flutter/foundation.dart';

/// Resultado de uma operação de snap.
@immutable
class SnapResult {
  const SnapResult({this.dx = 0, this.dy = 0, this.guides = const []});

  /// Offset horizontal a ser aplicado.
  final double dx;

  /// Offset vertical a ser aplicado.
  final double dy;

  /// Guias visuais para exibir os snaps ativos.
  final List<SnapGuide> guides;

  /// Se algum snap foi encontrado.
  bool get hasSnap => dx != 0 || dy != 0;
}

/// Guia visual para snaps.
@immutable
class SnapGuide {
  const SnapGuide({
    required this.isVertical,
    required this.offset,
    required this.min,
    required this.max,
  });

  /// Se a guia é vertical (x constante) ou horizontal (y constante).
  final bool isVertical;

  /// A coordenada constante da guia (x para vertical, y para horizontal).
  final double offset;

  /// O início do segmento da linha.
  final double min;

  /// O fim do segmento da linha.
  final double max;
}

enum SnapMode {
  none,
  angle,
  object,
  both;

  bool get isAngleSnapEnabled =>
      this == SnapMode.angle || this == SnapMode.both;
  bool get isObjectSnapEnabled =>
      this == SnapMode.object || this == SnapMode.both;

  String get tooltip {
    switch (this) {
      case SnapMode.none:
        return 'Snap: Desativado';
      case SnapMode.angle:
        return 'Snap: Ângulo';
      case SnapMode.object:
        return 'Snap: Objetos';
      case SnapMode.both:
        return 'Snap: Ângulo + Objetos';
    }
  }
}
