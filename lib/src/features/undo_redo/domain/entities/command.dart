abstract class Command {
  /// Executes the command.
  void execute();

  /// Reverses the command.
  void undo();

  /// Optional label for UI display.
  String get label;
}
