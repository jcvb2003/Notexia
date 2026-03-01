import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

class MockAppSettingsRepository extends Mock implements AppSettingsRepository {}

void main() {
  const delegate = SnapDelegate();
  late MockAppSettingsRepository settingsRepo;

  setUp(() {
    settingsRepo = MockAppSettingsRepository();
  });

  group('SnapDelegate.loadAngleSnapSettings', () {
    test('loads enabled mode and custom step from settings', () async {
      when(() => settingsRepo.getSetting(AppConstants.prefsAngleSnapEnabledKey))
          .thenAnswer((_) async => 'true');
      when(() => settingsRepo.getSetting(AppConstants.prefsAngleSnapStepKey))
          .thenAnswer((_) async => '0.5');

      final result = await delegate.loadAngleSnapSettings(_state(), settingsRepo);

      expect(result.snapMode, SnapMode.angle);
      expect(result.angleSnapStep, 0.5);
    });

    test('falls back to defaults for missing/invalid values', () async {
      when(() => settingsRepo.getSetting(AppConstants.prefsAngleSnapEnabledKey))
          .thenAnswer((_) async => null);
      when(() => settingsRepo.getSetting(AppConstants.prefsAngleSnapStepKey))
          .thenAnswer((_) async => 'invalid');

      final result = await delegate.loadAngleSnapSettings(_state(), settingsRepo);

      expect(result.snapMode, SnapMode.none);
      expect(result.angleSnapStep, AppConstants.angleSnapStep);
    });
  });

  group('SnapDelegate.setSnapMode and cycle', () {
    test('setSnapMode updates state and persists enabled flag', () async {
      when(() => settingsRepo.saveSetting(any(), any()))
          .thenAnswer((_) async {});

      final result = await delegate.setSnapMode(_state(), SnapMode.both, settingsRepo);

      expect(result.snapMode, SnapMode.both);
      verify(() => settingsRepo.saveSetting(
            AppConstants.prefsAngleSnapEnabledKey,
            'true',
          )).called(1);
    });

    test('cycleSnapMode follows none -> angle -> object -> both -> none', () async {
      when(() => settingsRepo.saveSetting(any(), any()))
          .thenAnswer((_) async {});

      var state = _state();
      state = await delegate.cycleSnapMode(state, settingsRepo);
      expect(state.snapMode, SnapMode.angle);
      state = await delegate.cycleSnapMode(state, settingsRepo);
      expect(state.snapMode, SnapMode.object);
      state = await delegate.cycleSnapMode(state, settingsRepo);
      expect(state.snapMode, SnapMode.both);
      state = await delegate.cycleSnapMode(state, settingsRepo);
      expect(state.snapMode, SnapMode.none);
    });
  });

  group('SnapDelegate.setAngleSnapEnabled and step', () {
    test('enabling angle snap converts object mode to both', () async {
      when(() => settingsRepo.saveSetting(any(), any()))
          .thenAnswer((_) async {});

      final start = _state(mode: SnapMode.object);
      final result = await delegate.setAngleSnapEnabled(start, true, settingsRepo);

      expect(result.snapMode, SnapMode.both);
    });

    test('disabling angle snap converts both mode to object', () async {
      when(() => settingsRepo.saveSetting(any(), any()))
          .thenAnswer((_) async {});

      final start = _state(mode: SnapMode.both);
      final result = await delegate.setAngleSnapEnabled(start, false, settingsRepo);

      expect(result.snapMode, SnapMode.object);
    });

    test('setAngleSnapStep persists new step and updates state', () async {
      when(() => settingsRepo.saveSetting(any(), any()))
          .thenAnswer((_) async {});

      final result = await delegate.setAngleSnapStep(_state(), 0.75, settingsRepo);

      expect(result.angleSnapStep, 0.75);
      verify(() => settingsRepo.saveSetting(
            AppConstants.prefsAngleSnapStepKey,
            '0.75',
          )).called(1);
    });
  });
}

CanvasState _state({SnapMode mode = SnapMode.none}) {
  final now = DateTime(2026, 1, 1);
  return CanvasState(
    document: DrawingDocument(
      id: 'doc-1',
      title: 'Doc',
      elements: const [],
      createdAt: now,
      updatedAt: now,
    ),
    interaction: InteractionState(
      snap: SnapState(mode: mode),
    ),
  );
}
