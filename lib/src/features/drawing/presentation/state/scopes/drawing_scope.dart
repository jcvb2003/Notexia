import 'dart:async';
import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';

class DrawingScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final DrawingService _drawingService;
  final PersistenceService _persistenceService;
  final bool Function() _isClosed;
  final _delegate = const DrawingDelegate();

  DateTime _lastDrawUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _drawThrottleTimer;

  DrawingScope(
    this._getState,
    this._emit,
    this._drawingService,
    this._persistenceService,
    this._isClosed,
  );

  void startDrawing(Offset position) {
    _drawThrottleTimer?.cancel();
    _delegate.startDrawing(
      state: _getState(),
      position: position,
      drawingService: _drawingService,
      emit: _emit,
    );
  }

  void updateDrawing(
    Offset currentPosition, {
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    final state = _getState();
    if (!state.isDrawing || state.activeElementId == null) return;

    final now = DateTime.now();
    if (now.difference(_lastDrawUpdate) < const Duration(milliseconds: 16)) {
      _drawThrottleTimer?.cancel();
      _drawThrottleTimer = Timer(const Duration(milliseconds: 16), () {
        if (_isClosed()) return;
        updateDrawing(
          currentPosition,
          keepAspect: keepAspect,
          snapAngle: snapAngle,
          createFromCenter: createFromCenter,
          snapAngleStep: snapAngleStep,
        );
      });
      return;
    }

    _drawThrottleTimer?.cancel();
    _lastDrawUpdate = now;

    _delegate.updateDrawing(
      state: state,
      currentPosition: currentPosition,
      drawingService: _drawingService,
      emit: _emit,
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
  }

  Future<void> stopDrawing() => _delegate.stopDrawing(
        state: _getState(),
        persistenceService: _persistenceService,
        emit: _emit,
      );
}
