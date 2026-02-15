import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/elements/text_element.dart';
import 'package:notexia/src/features/drawing/domain/commands/add_element_command.dart';
import 'package:notexia/src/features/drawing/domain/commands/remove_element_command.dart';
import 'package:notexia/src/features/drawing/domain/commands/transform_element_command.dart';
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
    required String label,
    required List<CanvasElement> before,
    required List<CanvasElement> after,
    required ApplyElementsCallback applyCallback,
  }) {
    // Detecta adição
    if (after.length > before.length) {
      return AddElementCommand(
        before: before,
        after: after,
        applyElements: applyCallback,
        label: label,
      );
    }
    // Detecta remoção
    if (after.length < before.length) {
      return RemoveElementCommand(
        before: before,
        after: after,
        applyElements: applyCallback,
        label: label,
      );
    }
    // Assume transformação se tamanhos iguais
    return TransformElementCommand(
      before: before,
      after: after,
      applyElements: applyCallback,
      label: label,
    );
  }
}
