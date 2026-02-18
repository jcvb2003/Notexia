import 'package:flutter_test/flutter_test.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/app/config/constants/app_constants.dart';

void main() {
  late ViewportDelegate delegate;
  late CanvasState baseState;

  setUp(() {
    delegate = const ViewportDelegate();
    baseState = CanvasState(
      document: DrawingDocument(
        id: 'doc1',
        title: 'Test',
        elements: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  group('ViewportDelegate', () {
    group('zoomIn', () {
      test('increases zoom by step', () {
        final result = delegate.zoomIn(baseState);
        expect(
          result.zoomLevel,
          closeTo(1.0 + AppConstants.zoomStep, 0.001),
        );
      });

      test('does not exceed max zoom', () {
        var state = baseState.copyWith(
          transform: baseState.transform.copyWith(
            zoomLevel: AppConstants.maxZoom,
          ),
        );
        final result = delegate.zoomIn(state);
        expect(result.zoomLevel, AppConstants.maxZoom);
      });
    });

    group('zoomOut', () {
      test('decreases zoom by step', () {
        final result = delegate.zoomOut(baseState);
        expect(
          result.zoomLevel,
          closeTo(1.0 - AppConstants.zoomStep, 0.001),
        );
      });

      test('does not go below min zoom', () {
        var state = baseState.copyWith(
          transform: baseState.transform.copyWith(
            zoomLevel: AppConstants.minZoom,
          ),
        );
        final result = delegate.zoomOut(state);
        expect(result.zoomLevel, AppConstants.minZoom);
      });
    });

    group('setZoom', () {
      test('sets explicit zoom level', () {
        final result = delegate.setZoom(baseState, 2.0);
        expect(result.zoomLevel, 2.0);
      });

      test('clamps zoom to max', () {
        final result = delegate.setZoom(baseState, 100.0);
        expect(result.zoomLevel, AppConstants.maxZoom);
      });

      test('clamps zoom to min', () {
        final result = delegate.setZoom(baseState, 0.001);
        expect(result.zoomLevel, AppConstants.minZoom);
      });
    });

    group('setPanOffset', () {
      test('sets pan offset', () {
        final result = delegate.setPanOffset(baseState, const Offset(100, 200));
        expect(result.panOffset, const Offset(100, 200));
      });

      test('allows negative pan offset', () {
        final result = delegate.setPanOffset(baseState, const Offset(-50, -75));
        expect(result.panOffset, const Offset(-50, -75));
      });
    });

    group('panBy', () {
      test('adds delta to current pan offset', () {
        final panned = delegate.setPanOffset(baseState, const Offset(100, 100));
        final result = delegate.panBy(panned, const Offset(50, -30));
        expect(result.panOffset, const Offset(150, 70));
      });

      test('works from zero offset', () {
        final result = delegate.panBy(baseState, const Offset(25, 75));
        expect(result.panOffset, const Offset(25, 75));
      });
    });
  });
}
