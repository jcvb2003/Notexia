import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/ui_preferences_delegate.dart';

class PreferencesScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final _delegate = const UIPreferencesDelegate();

  PreferencesScope(this._getState, this._emit);

  void toggleSkeletonMode() => _emit(_delegate.toggleSkeletonMode(_getState()));

  void toggleFullScreen() => _emit(_delegate.toggleFullScreen(_getState()));

  void toggleToolbarPosition() =>
      _emit(_delegate.toggleToolbarPosition(_getState()));

  void setToolbarPosition(bool atTop) =>
      _emit(_delegate.setToolbarPosition(_getState(), atTop));

  void toggleZoomUndoRedo() => _emit(_delegate.toggleZoomUndoRedo(_getState()));
}
