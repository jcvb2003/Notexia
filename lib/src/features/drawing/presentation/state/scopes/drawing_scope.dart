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
  final DrawingDelegate _delegate;

  DateTime _lastDrawUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _drawThrottleTimer;

  bool _isDisposed = false;
  bool get isDisposed => _isDisposed || _isClosed();

  DrawingScope(
    this._getState,
    this._emit,
    this._drawingService,
    this._persistenceService,
    this._isClosed,
    this._delegate,
  );

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _drawThrottleTimer?.cancel();
  }

  void startDrawing(Offset position) {
    _drawThrottleTimer?.cancel();
    final result = _delegate.startDrawing(
      state: _getState(),
      position: position,
      drawingService: _drawingService,
      isDisposed: () => isDisposed,
    );
    if (result.isSuccess) _emit(result.data!);
  }

  void updateDrawing(
    Offset currentPosition, {
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    final state = _getState();
    if (!state.isDrawing && state.activeElementId == null) return;

    final now = DateTime.now();
    if (now.difference(_lastDrawUpdate) < const Duration(milliseconds: 16)) {
      _drawThrottleTimer?.cancel();
      _drawThrottleTimer = Timer(const Duration(milliseconds: 16), () {
        if (isDisposed) return;
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

    final result = _delegate.updateDrawing(
      state: state,
      currentPosition: currentPosition,
      drawingService: _drawingService,
      isDisposed: () => isDisposed,
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
    if (result.isSuccess) _emit(result.data!);
  }

  Future<void> stopDrawing() async {
    final result = await _delegate.stopDrawing(
      state: _getState(),
      persistenceService: _persistenceService,
      isDisposed: () => isDisposed,
    );
    if (result.isSuccess) {
      _emit(result.data!);
    } else {
      final state = _getState();
      _emit(state.copyWith(
        error: result.failure!.message,
        interaction: state.interaction.copyWith(
          isDrawing: false,
          activeElementId: null,
          activeDrawingElement: null,
        ),
      ));
    }
  }
}
