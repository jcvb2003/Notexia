import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class MockCommand extends Mock implements Command {}

void main() {
  late CommandStackService commandStack;

  setUp(() {
    commandStack = CommandStackService();
  });

  tearDown(() {
    commandStack.dispose();
  });

  group('CommandStackService', () {
    test('initial state is empty', () {
      expect(commandStack.canUndo, isFalse);
      expect(commandStack.canRedo, isFalse);
      expect(commandStack.lastActionLabel, isNull);
    });

    test('add command updates state and clears redo stack', () {
      final command1 = MockCommand();
      final command2 = MockCommand();
      when(() => command1.label).thenReturn('Action 1');

      commandStack.add(command1);
      expect(commandStack.canUndo, isTrue);
      expect(commandStack.lastActionLabel, 'Action 1');

      // Add another to undo stack, then move to redo stack
      commandStack.undo();
      expect(commandStack.canRedo, isTrue);

      // Adding new command should clear redo stack
      commandStack.add(command2);
      expect(commandStack.canRedo, isFalse);
      expect(commandStack.canUndo, isTrue);
    });

    test('undo removes from undo stack and adds to redo stack', () {
      final command = MockCommand();
      when(() => command.undo()).thenReturn(null);

      commandStack.add(command);
      commandStack.undo();

      verify(() => command.undo()).called(1);
      expect(commandStack.canUndo, isFalse);
      expect(commandStack.canRedo, isTrue);
    });

    test('redo removes from redo stack and adds to undo stack', () {
      final command = MockCommand();
      when(() => command.undo()).thenReturn(null);
      when(() => command.execute()).thenReturn(null);

      commandStack.add(command);
      commandStack.undo();
      commandStack.redo();

      verify(() => command.execute()).called(1);
      expect(commandStack.canUndo, isTrue);
      expect(commandStack.canRedo, isFalse);
    });

    test('clear empties both stacks', () {
      final command = MockCommand();
      commandStack.add(command);
      commandStack.undo(); // Move to redo stack

      expect(commandStack.canRedo, isTrue);

      commandStack.clear();
      expect(commandStack.canUndo, isFalse);
      expect(commandStack.canRedo, isFalse);
    });

    test('changes stream emits on add/undo/redo/clear', () async {
      final command = MockCommand();
      when(() => command.undo()).thenReturn(null);

      final emissions = <void>[];
      commandStack.changes.listen((_) => emissions.add(null));

      commandStack.add(command);
      commandStack.undo();
      commandStack.redo();
      commandStack.clear();

      // Wait for stream events
      await Future.delayed(Duration.zero);
      expect(emissions.length, 4);
    });
  });
}
