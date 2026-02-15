import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class SnapScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final AppSettingsRepository? _settingsRepository;
  final _delegate = const SnapDelegate();

  SnapScope(this._getState, this._emit, this._settingsRepository);

  Future<void> loadAngleSnapSettings() async {
    if (_settingsRepository == null) return;
    _emit(await _delegate.loadAngleSnapSettings(
        _getState(), _settingsRepository));
  }

  Future<void> setSnapMode(SnapMode mode) async {
    _emit(await _delegate.setSnapMode(_getState(), mode, _settingsRepository));
  }

  Future<void> cycleSnapMode() async {
    _emit(await _delegate.cycleSnapMode(_getState(), _settingsRepository));
  }

  Future<void> setAngleSnapEnabled(bool value) async {
    _emit(await _delegate.setAngleSnapEnabled(
        _getState(), value, _settingsRepository));
  }

  Future<void> toggleAngleSnapEnabled() async {
    await cycleSnapMode();
  }

  void setSnapGuides(List<SnapGuide> guides) =>
      _emit(_delegate.setSnapGuides(_getState(), guides));

  Future<void> setAngleSnapStep(double value) async {
    _emit(await _delegate.setAngleSnapStep(
        _getState(), value, _settingsRepository));
  }
}
