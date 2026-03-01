import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/settings/data/repositories/app_settings_repository.dart';

class SnapDelegate {
  const SnapDelegate();

  Future<CanvasState> loadAngleSnapSettings(
    CanvasState state,
    AppSettingsRepository repo,
  ) async {
    final enabledStr = await repo.getSetting(
      AppConstants.prefsAngleSnapEnabledKey,
    );
    final stepStr = await repo.getSetting(AppConstants.prefsAngleSnapStepKey);
    final enabled = enabledStr == 'true';
    final step = double.tryParse(stepStr ?? '') ?? AppConstants.angleSnapStep;

    final mode = enabled ? SnapMode.angle : SnapMode.none;

    return state.copyWith(
      interaction: state.interaction.copyWith(
        snap: state.interaction.snap.copyWith(
          mode: mode,
          angleStep: step,
        ),
      ),
    );
  }

  Future<CanvasState> setSnapMode(
    CanvasState state,
    SnapMode mode,
    AppSettingsRepository? repo,
  ) async {
    if (repo != null) {
      await repo.saveSetting(
        AppConstants.prefsAngleSnapEnabledKey,
        mode.isAngleSnapEnabled ? 'true' : 'false',
      );
    }
    return state.copyWith(
      interaction: state.interaction.copyWith(
        snap: state.interaction.snap.copyWith(mode: mode),
      ),
    );
  }

  Future<CanvasState> cycleSnapMode(
    CanvasState state,
    AppSettingsRepository? repo,
  ) async {
    final current = state.snapMode;
    final next = switch (current) {
      SnapMode.none => SnapMode.angle,
      SnapMode.angle => SnapMode.object,
      SnapMode.object => SnapMode.both,
      SnapMode.both => SnapMode.none,
    };
    return setSnapMode(state, next, repo);
  }

  Future<CanvasState> setAngleSnapEnabled(
    CanvasState state,
    bool value,
    AppSettingsRepository? repo,
  ) async {
    if (value) {
      if (!state.snapMode.isAngleSnapEnabled) {
        final newMode =
            state.snapMode == SnapMode.object ? SnapMode.both : SnapMode.angle;
        return setSnapMode(state, newMode, repo);
      }
    } else {
      if (state.snapMode.isAngleSnapEnabled) {
        final newMode =
            state.snapMode == SnapMode.both ? SnapMode.object : SnapMode.none;
        return setSnapMode(state, newMode, repo);
      }
    }
    return state;
  }

  CanvasState setSnapGuides(CanvasState state, List<SnapGuide> guides) {
    return state.copyWith(
      interaction: state.interaction.copyWith(
        snap: state.interaction.snap.copyWith(guides: guides),
      ),
    );
  }

  Future<CanvasState> setAngleSnapStep(
    CanvasState state,
    double value,
    AppSettingsRepository? repo,
  ) async {
    if (repo != null) {
      await repo.saveSetting(
        AppConstants.prefsAngleSnapStepKey,
        value.toString(),
      );
    }
    return state.copyWith(
      interaction: state.interaction.copyWith(
        snap: state.interaction.snap.copyWith(angleStep: value),
      ),
    );
  }
}
