import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/base_toolbar.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/context_toolbar.dart';

import '../../../../../helpers/pump_app.dart';

class MockCanvasCubit extends MockCubit<CanvasState> implements CanvasCubit {}

void main() {
  late MockCanvasCubit drawingCubit;

  setUp(() {
    drawingCubit = MockCanvasCubit();
  });

  group('ContextToolbar', () {
    testWidgets('renders nothing when selection tool is active (no controls)', (
      tester,
    ) async {
      when(() => drawingCubit.state).thenReturn(
        CanvasState(
          document: DrawingDocument(
            id: '1',
            title: 'Test',
            elements: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          interaction: const InteractionState(
            selectedTool: CanvasElementType.selection,
          ),
        ),
      );

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ContextToolbar(),
        ),
      );

      expect(find.byType(BaseToolbar), findsNothing);
    });

    testWidgets('renders BaseToolbar when rectangle tool is active', (
      tester,
    ) async {
      when(() => drawingCubit.state).thenReturn(
        CanvasState(
          document: DrawingDocument(
            id: '1',
            title: 'Test',
            elements: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          interaction: const InteractionState(
            selectedTool: CanvasElementType.rectangle,
          ),
        ),
      );

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ContextToolbar(),
        ),
      );

      expect(find.byType(BaseToolbar), findsOneWidget);
    });

    testWidgets('BaseToolbar uses white background', (tester) async {
      when(() => drawingCubit.state).thenReturn(
        CanvasState(
          document: DrawingDocument(
            id: '1',
            title: 'Test',
            elements: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          interaction: const InteractionState(
            selectedTool: CanvasElementType.rectangle,
          ),
        ),
      );

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ContextToolbar(),
        ),
      );

      final baseToolbarFinder = find.byType(BaseToolbar);
      final BaseToolbar baseToolbar = tester.widget<BaseToolbar>(
        baseToolbarFinder,
      );
      expect(baseToolbar.backgroundColor, Colors.white);
    });
  });
}
