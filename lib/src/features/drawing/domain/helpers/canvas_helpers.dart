import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';
import 'package:notexia/src/features/undo_redo/domain/entities/command.dart';

// Callback para aplicação de comandos
typedef ApplyElementsCallback = void Function(List<CanvasElement>);

/// Utilitários puros para auxiliar na lógica do CanvasCubit.
/// Contém apenas funções estáticas, sem estado.
class CanvasHelpers {
  CanvasHelpers._();

  /// Mede o tamanho necessário para um elemento de texto.
  static Size measureText(TextElement element, String text) {
    if (text.trim().isEmpty) return Size(element.width, element.height);

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: element.fontFamily,
        fontSize: element.fontSize,
        fontWeight: element.isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: element.isItalic ? FontStyle.italic : FontStyle.normal,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: element.textAlign,
      textDirection: TextDirection.ltr,
    );

    // Layout com largura máxima se definida
    textPainter.layout(
      maxWidth: element.width > 0 ? element.width : double.infinity,
    );

    // Clamping para evitar tamanhos absurdos
    final width = textPainter.size.width.clamp(20.0, 800.0);
    final height = textPainter.size.height.clamp(20.0, 800.0);

    return Size(width, height);
  }

  /// Constrói o comando de Undo/Redo apropriado baseado na diferença entre estados.
  static Command buildElementsCommand({
    required List<CanvasElement> before,
    required List<CanvasElement> after,
    required ApplyElementsCallback applyCallback,
    String? label, // Label opcional, calculado se nulo
  }) {
    final String cmdLabel;

    if (label != null) {
      cmdLabel = label;
    } else if (after.length > before.length) {
      cmdLabel = 'Adicionar Elemento';
    } else if (after.length < before.length) {
      cmdLabel = 'Remover Elemento';
    } else {
      // Se tamanhos iguais, verificar se foi estilo ou transformação
      bool isTransform = false;

      // Verifica se houve mudança em propriedades de transformação (x, y, width, height, angle)
      // Se sim, é uma transformação. Se mudou algo mas não esses campos, é estilo.
      for (int i = 0; i < before.length; i++) {
        // Encontrar o elemento correspondente (assumindo mesma ordem/id para simplificar,
        // ou comparar diretamente se os arrays estão alinhados pelo índice, o que é o caso comum aqui)
        final b = before[i];
        final a = after[i];

        if (b == a) continue;

        if (b.x != a.x ||
            b.y != a.y ||
            b.width != a.width ||
            b.height != a.height ||
            b.angle != a.angle) {
          isTransform = true;
          break;
        }
      }

      cmdLabel = isTransform ? 'Transformar Elemento' : 'Alterar Estilo';
    }

    return ElementsCommand(
      label: cmdLabel,
      before: before,
      after: after,
      applyElements: applyCallback,
    );
  }
}
