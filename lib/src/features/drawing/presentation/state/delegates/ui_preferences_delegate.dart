import 'package:flutter/services.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';

class UIPreferencesDelegate {
  const UIPreferencesDelegate();

  CanvasState toggleSkeletonMode(CanvasState state) {
    return state.copyWith(isSkeletonMode: !state.isSkeletonMode);
  }

  CanvasState toggleFullScreen(CanvasState state) {
    final newValue = !state.isFullScreen;
    if (newValue) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    return state.copyWith(isFullScreen: newValue);
  }

  CanvasState toggleToolbarPosition(CanvasState state) {
    return state.copyWith(isToolbarAtTop: !state.isToolbarAtTop);
  }

  CanvasState setToolbarPosition(CanvasState state, bool atTop) {
    return state.copyWith(isToolbarAtTop: atTop);
  }

  CanvasState toggleZoomUndoRedo(CanvasState state) {
    return state.copyWith(isZoomMode: !state.isZoomMode);
  }
}
