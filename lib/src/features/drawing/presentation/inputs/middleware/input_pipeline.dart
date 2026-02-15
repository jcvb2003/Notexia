import 'package:notexia/src/features/drawing/presentation/inputs/middleware/input_event.dart';

/// Interface para middlewares que processam eventos de input.
abstract class InputMiddleware {
  /// Processa o evento.
  /// [next] deve ser chamado para passar o evento para o próximo middleware na cadeia.
  void handle(InputEvent event, void Function(InputEvent) next);
}

/// Gerencia a execução de uma cadeia de middlewares.
class InputPipeline {
  final List<InputMiddleware> _middlewares = [];
  
  // Handler final que será executado após todos os middlewares
  void Function(InputEvent)? onProcessed;

  void addMiddleware(InputMiddleware middleware) {
    _middlewares.add(middleware);
  }

  void process(InputEvent event) {
    _executeMiddleware(0, event);
  }

  void _executeMiddleware(int index, InputEvent event) {
    if (index >= _middlewares.length) {
      if (onProcessed != null && !event.handled) {
        onProcessed!(event);
      }
      return;
    }

    final middleware = _middlewares[index];
    middleware.handle(event, (nextEvent) {
      _executeMiddleware(index + 1, nextEvent);
    });
  }
}
