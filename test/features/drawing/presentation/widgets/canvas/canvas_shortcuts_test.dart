import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_cubit.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/widgets/canvas/canvas_widget.dart';
import 'package:notexia/src/features/undo_redo/presentation/state/undo_redo_cubit.dart';

import 'package:notexia/src/features/drawing/presentation/state/scopes/manipulation_scope.dart';

import 'package:notexia/src/features/drawing/presentation/state/scopes/selection_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/drawing_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/text_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/viewport_scope.dart';

class MockManipulationScope extends Mock implements ManipulationScope {}

class MockSelectionScope extends Mock implements SelectionScope {}

class MockDrawingScope extends Mock implements DrawingScope {}

class MockTextScope extends Mock implements TextScope {}

class MockViewportScope extends Mock implements ViewportScope {}

class MockCanvasCubit extends MockCubit<CanvasState> implements CanvasCubit {
  @override
  late final ManipulationScope manipulation = MockManipulationScope();
  @override
  late final SelectionScope selection = MockSelectionScope();
  @override
  late final DrawingScope drawing = MockDrawingScope();
  @override
  late final TextScope text = MockTextScope();
  @override
  late final ViewportScope viewport = MockViewportScope();
}

class MockUndoRedoCubit extends MockCubit<UndoRedoState>
    implements UndoRedoCubit {}

void main() {
  late MockCanvasCubit drawingCubit;
  late MockUndoRedoCubit undoRedoCubit;

  setUp(() {
    drawingCubit = MockCanvasCubit();
    undoRedoCubit = MockUndoRedoCubit();
    when(() => drawingCubit.state).thenReturn(
      CanvasState(
        document: DrawingDocument(
          id: 'test_doc',
          title: 'Test Document',
          elements: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        interaction: const InteractionState(
          selectedTool: CanvasElementType.selection,
        ),
      ),
    );

    when(() => undoRedoCubit.state).thenReturn(UndoRedoInitial());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CanvasCubit>.value(value: drawingCubit),
          BlocProvider<UndoRedoCubit>.value(value: undoRedoCubit),
        ],
        child: const Scaffold(body: CanvasWidget()),
      ),
    );
  }

  testWidgets('Delete key triggers deleteSelectedElements', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Ensure focus handling setup

    // Tap to ensure focus
    await tester.tap(find.byType(CustomPaint).first);
    await tester.pump();

    // Send Delete key event
    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pump();

    verify(() => drawingCubit.manipulation.deleteSelectedElements()).called(1);
  });

  testWidgets('Backspace key triggers deleteSelectedElements', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Tap to ensure focus
    await tester.tap(find.byType(CustomPaint).first);
    await tester.pump();

    // Send Backspace key event
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();

    verify(() => drawingCubit.manipulation.deleteSelectedElements()).called(1);
  });

  testWidgets('Tool shortcuts select correct tools', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.byType(CustomPaint).first);
    await tester.pump();

    // 'R' for Rectangle
    await tester.sendKeyEvent(LogicalKeyboardKey.keyR);
    await tester.pump();
    verify(
      () => drawingCubit.selectTool(CanvasElementType.rectangle),
    ).called(1);

    // 'L' for Line
    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.pump();
    verify(() => drawingCubit.selectTool(CanvasElementType.line)).called(1);
  });

  testWidgets('Numeric shortcuts select correct tools', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    await tester.tap(find.byType(CustomPaint).first);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pump();
    verify(
      () => drawingCubit.selectTool(CanvasElementType.selection),
    ).called(1);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
    await tester.pump();
    verify(
      () => drawingCubit.selectTool(CanvasElementType.rectangle),
    ).called(1);
  });
}
