import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/core/widgets/common/app_divider.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/toolbar/controls/shape_controls.dart';

import '../../../../../../helpers/pump_app.dart';

class MockCanvasCubit extends MockCubit<CanvasState> implements CanvasCubit {}

void main() {
  late MockCanvasCubit drawingCubit;

  setUp(() {
    drawingCubit = MockCanvasCubit();
  });

  group('ShapeToolControls', () {
    testWidgets('renders shape actions and hides delete when nothing is selected',
        (tester) async {
      when(() => drawingCubit.state).thenReturn(_state(selectedTool: CanvasElementType.rectangle));

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ShapeToolControls(tool: CanvasElementType.rectangle),
        ),
      );

      expect(find.byIcon(LucideIcons.square), findsOneWidget);
      expect(find.byIcon(LucideIcons.circle), findsOneWidget);
      expect(find.byIcon(LucideIcons.diamond), findsOneWidget);
      expect(find.byIcon(LucideIcons.triangle), findsOneWidget);
      expect(find.byType(AppDivider), findsNWidgets(2));
      expect(find.byIcon(LucideIcons.trash2), findsNothing);
    });

    testWidgets('tapping a shape button selects that tool in cubit', (tester) async {
      when(() => drawingCubit.state).thenReturn(_state(selectedTool: CanvasElementType.rectangle));

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ShapeToolControls(tool: CanvasElementType.rectangle),
        ),
      );

      await tester.tap(find.byIcon(LucideIcons.circle));

      verify(() => drawingCubit.selectTool(CanvasElementType.ellipse)).called(1);
    });

    testWidgets('shows delete action for selected element and triggers deletion',
        (tester) async {
      when(() => drawingCubit.state).thenReturn(_state(
            selectedTool: CanvasElementType.rectangle,
            elements: [_rectangle(id: 'shape-1')],
            selectedElementIds: {'shape-1'},
          ));

      await tester.pumpApp(
        BlocProvider<CanvasCubit>.value(
          value: drawingCubit,
          child: const ShapeToolControls(tool: CanvasElementType.rectangle),
        ),
      );

      final deleteFinder = find.byIcon(LucideIcons.trash2);
      expect(deleteFinder, findsOneWidget);

      await tester.tap(deleteFinder);
      verify(() => drawingCubit.deleteSelectedElements()).called(1);
    });
  });
}

CanvasState _state({
  required CanvasElementType selectedTool,
  List<CanvasElement> elements = const [],
  Set<String> selectedElementIds = const {},
}) {
  final now = DateTime(2026, 1, 1);
  return CanvasState(
    document: DrawingDocument(
      id: 'doc-1',
      title: 'Test',
      elements: elements,
      createdAt: now,
      updatedAt: now,
    ),
    interaction: InteractionState(
      selectedTool: selectedTool,
      selectedElementIds: selectedElementIds,
    ),
  );
}

RectangleElement _rectangle({required String id}) {
  return RectangleElement(
    id: id,
    x: 0,
    y: 0,
    width: 10,
    height: 10,
    strokeColor: Colors.black,
    updatedAt: DateTime(2026, 1, 1),
  );
}
