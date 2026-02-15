import 'dart:ui';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';

class ManipulationScope {
  final CanvasState Function() _getState;
  final void Function(CanvasState) _emit;
  final void Function(DrawingDocument) _saveDocument;
  final void Function(List<CanvasElement>) _applyCommand;
  final ElementManipulationDelegate _delegate;
  final CommandStackService _commandStack;
  final DocumentRepository _documentRepository;

  ManipulationScope(
    this._getState,
    this._emit,
    this._saveDocument,
    this._applyCommand,
    this._delegate,
    this._commandStack,
    this._documentRepository,
  );

  void moveSelectedElements(Offset delta) => _delegate.moveSelectedElements(
        state: _getState(),
        delta: delta,
        emit: _emit,
      );

  void resizeSelectedElement(Rect rect) => _delegate.resizeSelectedElement(
        state: _getState(),
        rect: rect,
        emit: _emit,
      );

  void rotateSelectedElement(double angle) => _delegate.rotateSelectedElement(
        state: _getState(),
        angle: angle,
        emit: _emit,
      );

  void updateLineEndpoint({
    required bool isStart,
    required Offset worldPoint,
    bool snapAngle = false,
    double? angleStep,
  }) =>
      _delegate.updateLineEndpoint(
        state: _getState(),
        isStart: isStart,
        worldPoint: worldPoint,
        emit: _emit,
        snapAngle: snapAngle,
        angleStep: angleStep,
      );

  Future<void> finalizeManipulation() => _delegate.finalizeManipulation(
        state: _getState(),
        documentRepository: _documentRepository,
        emit: _emit,
      );

  void deleteSelectedElements() => _delegate.deleteSelectedElements(
        state: _getState(),
        commandStack: _commandStack,
        emit: _emit,
        applyCallback: _applyCommand,
        scheduleSave: _saveDocument,
      );

  void deleteElementById(String elementId) => _delegate.deleteElementById(
        state: _getState(),
        elementId: elementId,
        commandStack: _commandStack,
        emit: _emit,
        applyCallback: _applyCommand,
        scheduleSave: _saveDocument,
      );

  void updateSelectedElementsProperties({
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    StrokeStyle? strokeStyle,
    FillType? fillType,
    double? opacity,
    double? roughness,
    String? text,
    String? fontFamily,
    double? fontSize,
    TextAlign? textAlign,
    Color? backgroundColor,
    double? backgroundRadius,
    bool? isBold,
    bool? isItalic,
    bool? isUnderlined,
    bool? isStrikethrough,
  }) {
    final patch = ElementStylePatch(
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      strokeStyle: strokeStyle,
      fillType: fillType,
      opacity: opacity,
      roughness: roughness,
      text: text,
      fontFamily: fontFamily,
      fontSize: fontSize,
      textAlign: textAlign,
      backgroundColor: backgroundColor,
      backgroundRadius: backgroundRadius,
      isBold: isBold,
      isItalic: isItalic,
      isUnderlined: isUnderlined,
      isStrikethrough: isStrikethrough,
    );

    _delegate.updateSelectedElementsProperties(
      state: _getState(),
      commandStack: _commandStack,
      emit: _emit,
      applyCallback: _applyCommand,
      scheduleSave: _saveDocument,
      patch: patch,
    );
  }

  void updateCurrentStyle(ElementStyle style) => _delegate.updateCurrentStyle(
        state: _getState(),
        style: style,
        emit: _emit,
      );
}
