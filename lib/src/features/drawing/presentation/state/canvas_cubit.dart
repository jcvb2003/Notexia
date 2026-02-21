import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

import 'package:notexia/src/features/drawing/domain/commands/elements_command.dart';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/drawing_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/text_scope.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/element_manipulation_delegate.dart';
import 'package:notexia/src/features/undo_redo/domain/services/command_stack_service.dart';
import 'package:uuid/uuid.dart';

import 'package:notexia/src/features/drawing/domain/helpers/canvas_helpers.dart';
import 'package:notexia/src/features/drawing/domain/services/drawing_service.dart';
import 'package:notexia/src/features/drawing/domain/services/persistence_service.dart';

class CanvasCubit extends Cubit<CanvasState> {
  final DocumentRepository _documentRepository;
  final CommandStackService _commandStack;

  final AppSettingsRepository? _settingsRepository;
  final DrawingService _drawingService;
  final PersistenceService _persistenceService;
  final ElementManipulationDelegate _elementManipulationDelegate;
  final SelectionDelegate _selectionDelegate;
  final TextEditingDelegate _textEditingDelegate;
  final ViewportDelegate _viewportDelegate;
  final DrawingDelegate _drawingDelegate;
  final EraserDelegate _eraserDelegate;
  final SnapDelegate _snapDelegate;
  final _uuid = const Uuid();

  List<CanvasElement>? _gestureStartElements;
  String? _gestureLabel;

  CanvasCubit(
    this._documentRepository,
    this._commandStack,
    this._drawingService,
    this._persistenceService,
    this._elementManipulationDelegate,
    this._selectionDelegate,
    this._textEditingDelegate,
    this._viewportDelegate,
    this._drawingDelegate,
    this._eraserDelegate,
    this._snapDelegate,
    DrawingDocument initialDocument, {
    AppSettingsRepository? appSettingsRepository,
  })  : _settingsRepository = appSettingsRepository,
        super(CanvasState(document: initialDocument)) {
    _commandStack.clear();
  }

  @override
  Future<void> close() {
    _persistenceService.dispose();
    drawing.dispose();
    return super.close();
  }

  void beginCommandGesture(String label) {
    _gestureStartElements = List<CanvasElement>.from(state.document.elements);
    _gestureLabel = label;
  }

  void endCommandGesture() {
    final before = _gestureStartElements;
    final label = _gestureLabel;
    _gestureStartElements = null;
    _gestureLabel = null;
    if (before == null || label == null) return;
    final after = state.document.elements;
    if (listEquals(before, after)) return;

    final command = CanvasHelpers.buildElementsCommand(
      label: label,
      before: before,
      after: List<CanvasElement>.from(after),
      applyCallback: _applyElementsFromCommand,
    );
    _commandStack.add(command);
  }

  void _applyElementsFromCommand(List<CanvasElement> elements) {
    if (isClosed) return;
    final updatedDoc = state.document.copyWith(elements: elements);
    emit(state.copyWith(document: updatedDoc));
  }

  void _scheduleSaveDocument(DrawingDocument doc) {
    _persistenceService.scheduleSaveDocument(
      doc,
      onComplete: (failure) {
        if (isClosed) return;
        if (failure != null) {
          emit(state.copyWith(
            error: failure.message,
            lastFailure: failure,
          ));
        } else {
          emit(state.copyWith(error: null, lastFailure: null));
        }
      },
    );
  }

  Future<void> updateTitle(String newTitle) async {
    final updatedDoc = state.document.copyWith(title: newTitle);
    _persistenceService.scheduleSaveDocument(
      updatedDoc,
      debounceDuration: Duration.zero, // Save immediately for title
      onComplete: (failure) {
        if (!isClosed) {
          if (failure != null) {
            emit(state.copyWith(
              error: 'Erro ao atualizar título: ${failure.message}',
              lastFailure: failure,
            ));
          } else {
            emit(state.copyWith(error: null, lastFailure: null));
          }
        }
      },
    );
    emit(state.copyWith(document: updatedDoc));
  }

  // Viewport Operations
  void zoomIn() {
    final result = _viewportDelegate.zoomIn(state);
    if (result.isSuccess) emit(result.data!);
  }

  void zoomOut() {
    final result = _viewportDelegate.zoomOut(state);
    if (result.isSuccess) emit(result.data!);
  }

  void setZoom(double value) {
    final result = _viewportDelegate.setZoom(state, value);
    if (result.isSuccess) emit(result.data!);
  }

  void setPanOffset(Offset offset) {
    final result = _viewportDelegate.setPanOffset(state, offset);
    if (result.isSuccess) emit(result.data!);
  }

  void panBy(Offset delta) {
    final result = _viewportDelegate.panBy(state, delta);
    if (result.isSuccess) emit(result.data!);
  }

  void toggleSkeletonMode() {
    emit(state.copyWith(isSkeletonMode: !state.isSkeletonMode));
  }

  void toggleFullScreen() {
    final newValue = !state.isFullScreen;
    if (newValue) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    emit(state.copyWith(isFullScreen: newValue));
  }

  void toggleToolbarPosition() {
    emit(state.copyWith(isToolbarAtTop: !state.isToolbarAtTop));
  }

  void setToolbarPosition(bool atTop) {
    emit(state.copyWith(isToolbarAtTop: atTop));
  }

  void toggleZoomUndoRedo() {
    emit(state.copyWith(isZoomMode: !state.isZoomMode));
  }

  // Snap Operations
  Future<void> loadAngleSnapSettings() async {
    if (_settingsRepository == null) return;
    emit(await _snapDelegate.loadAngleSnapSettings(
      state,
      _settingsRepository,
    ));
  }

  Future<void> setSnapMode(SnapMode mode) async {
    emit(await _snapDelegate.setSnapMode(state, mode, _settingsRepository));
  }

  Future<void> cycleSnapMode() async {
    emit(await _snapDelegate.cycleSnapMode(state, _settingsRepository));
  }

  Future<void> setAngleSnapEnabled(bool value) async {
    emit(await _snapDelegate.setAngleSnapEnabled(
      state,
      value,
      _settingsRepository,
    ));
  }

  Future<void> toggleAngleSnapEnabled() async {
    await cycleSnapMode();
  }

  void setSnapGuides(List<SnapGuide> guides) =>
      emit(_snapDelegate.setSnapGuides(state, guides));

  Future<void> setAngleSnapStep(double value) async {
    emit(await _snapDelegate.setAngleSnapStep(
      state,
      value,
      _settingsRepository,
    ));
  }

  // Selection Operations
  void setSelectionBox(Rect? rect) {
    final result = _selectionDelegate.setSelectionBox(state, rect);
    if (result.isSuccess) emit(result.data!);
  }

  void setHoveredElement(String? id) {
    final result = _selectionDelegate.setHoveredElement(state, id);
    if (result.isSuccess) emit(result.data!);
  }

  void selectElementAt(Offset localPosition, {bool isMultiSelect = false}) {
    final result = _selectionDelegate.selectElementAt(
      state,
      localPosition,
      isMultiSelect: isMultiSelect,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void selectElementsInRect(Rect selectionRect) {
    final result =
        _selectionDelegate.selectElementsInRect(state, selectionRect);
    if (result.isSuccess) emit(result.data!);
  }

  // Manipulation Operations
  void moveSelectedElements(Offset delta) {
    final result = _elementManipulationDelegate.moveSelectedElements(
      state: state,
      delta: delta,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void resizeSelectedElement(Rect rect) {
    final result = _elementManipulationDelegate.resizeSelectedElement(
      state: state,
      rect: rect,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void rotateSelectedElement(double angle) {
    final result = _elementManipulationDelegate.rotateSelectedElement(
      state: state,
      angle: angle,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void updateLineEndpoint({
    required bool isStart,
    required Offset worldPoint,
    bool snapAngle = false,
    double? angleStep,
  }) {
    final result = _elementManipulationDelegate.updateLineEndpoint(
      state: state,
      isStart: isStart,
      worldPoint: worldPoint,
      snapAngle: snapAngle,
      angleStep: angleStep,
    );
    if (result.isSuccess) emit(result.data!);
  }

  Future<void> finalizeManipulation() async {
    final result = await _elementManipulationDelegate.finalizeManipulation(
      state: state,
      documentRepository: _documentRepository,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void deleteSelectedElements() {
    final result = _elementManipulationDelegate.deleteSelectedElements(
      state: state,
      commandStack: _commandStack,
      applyCallback: _applyElementsFromCommand,
      scheduleSave: _scheduleSaveDocument,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void deleteElementById(String elementId) {
    final result = _elementManipulationDelegate.deleteElementById(
      state: state,
      elementId: elementId,
      commandStack: _commandStack,
      applyCallback: _applyElementsFromCommand,
      scheduleSave: _scheduleSaveDocument,
    );
    if (result.isSuccess) emit(result.data!);
  }

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

    final result =
        _elementManipulationDelegate.updateSelectedElementsProperties(
      state: state,
      commandStack: _commandStack,
      applyCallback: _applyElementsFromCommand,
      scheduleSave: _scheduleSaveDocument,
      patch: patch,
    );
    if (result.isSuccess) emit(result.data!);
  }

  void updateCurrentStyle(ElementStyle style) {
    final result = _elementManipulationDelegate.updateCurrentStyle(
      state: state,
      style: style,
    );
    if (result.isSuccess) emit(result.data!);
  }

  // Eraser Operations
  void setEraserMode(EraserMode mode) {
    final result = _eraserDelegate.setEraserMode(state.interaction, mode);
    if (result.isSuccess) {
      emit(state.copyWith(interaction: result.data!));
    }
  }

  void startEraser(Offset point) {
    final result = _eraserDelegate.startEraser(state.interaction, point);
    if (result.isSuccess) {
      emit(state.copyWith(interaction: result.data!));
    }
  }

  void updateEraserTrail(Offset point) {
    final result = _eraserDelegate.updateEraserTrail(state.interaction, point);
    if (result.isSuccess) {
      emit(state.copyWith(interaction: result.data!));
    }
  }

  void endEraser() {
    final result = _eraserDelegate.endEraser(state.interaction);
    if (result.isSuccess) {
      emit(state.copyWith(interaction: result.data!));
    }
  }

  void eraseElementsAtPoint(Offset worldPoint, double radius) {
    final result = _eraserDelegate.eraseElements(
      state.document.elements,
      worldPoint,
      radius,
    );

    if (result.isFailure) return;
    final updatedElements = result.data!;

    if (updatedElements.length == state.document.elements.length) return;

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(selectedElementIds: {}),
      ),
    );
    _scheduleSaveDocument(updatedDoc);
  }

  late final drawing = DrawingScope(
    () => state,
    (s) => emit(s),
    _drawingService,
    _persistenceService,
    () => isClosed,
    _drawingDelegate,
  );

  late final text = TextScope(
    () => state,
    (s) => emit(s),
    _scheduleSaveDocument,
    _applyElementsFromCommand,
    _commandStack,
    _persistenceService,
    _uuid,
    _textEditingDelegate,
  );

  void selectTool(CanvasElementType tool) {
    if (state.selectedTool == tool) return;

    final Set<String> newSelection = (tool == CanvasElementType.selection ||
            tool == CanvasElementType.navigation)
        ? state.selectedElementIds
        : {};

    emit(
      state.copyWith(
        interaction: state.interaction.copyWith(
          selectedTool: tool,
          selectedElementIds: newSelection,
          activeElementId: null,
        ),
      ),
    );
  }

  void clearCanvas() {
    if (state.document.elements.isEmpty) return;
    final before = List<CanvasElement>.from(state.document.elements);
    final updatedDoc = state.document.copyWith(elements: []);
    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(selectedElementIds: {}),
      ),
    );
    _commandStack.add(
      ElementsCommand(
        before: before,
        after: const [],
        applyElements: _applyElementsFromCommand,
        label: 'Limpar tela',
      ),
    );
  }

  void loadDocument(DrawingDocument document) {
    if (isClosed) return;
    emit(
      state.copyWith(
        document: document,
        interaction: state.interaction.copyWith(
          selectedElementIds: {},
          activeElementId: null,
        ),
      ),
    );
  }
}
