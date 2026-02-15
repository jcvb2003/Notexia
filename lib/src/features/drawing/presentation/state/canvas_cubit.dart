import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';

import 'package:notexia/src/features/drawing/domain/commands/remove_element_command.dart';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/viewport_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/ui_preferences_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/selection_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/text_editing_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/drawing_delegate.dart';
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
  final _uuid = const Uuid();

  Timer? _drawThrottleTimer;
  DateTime _lastDrawUpdate = DateTime.fromMillisecondsSinceEpoch(0);
  List<CanvasElement>? _gestureStartElements;
  String? _gestureLabel;

  CanvasCubit(
    this._documentRepository,
    this._commandStack,
    this._drawingService,
    this._persistenceService,
    this._elementManipulationDelegate,
    DrawingDocument initialDocument, {
    AppSettingsRepository? appSettingsRepository,
  })  : _settingsRepository = appSettingsRepository,
        super(CanvasState(document: initialDocument)) {
    _commandStack.clear();
  }

  @override
  Future<void> close() {
    _persistenceService.dispose();
    _drawThrottleTimer?.cancel();
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
      onComplete: (error) {
        if (isClosed) return;
        if (error != null) {
          emit(state.copyWith(error: 'Erro ao salvar documento: $error'));
        } else {
          emit(state.copyWith(error: null));
        }
      },
    );
  }

  Future<void> updateTitle(String newTitle) async {
    try {
      final updatedDoc = state.document.copyWith(title: newTitle);
      _persistenceService.scheduleSaveDocument(
        updatedDoc,
        debounceDuration: Duration.zero, // Save immediately for title
        onComplete: (error) {
          if (!isClosed && error != null) {
            emit(state.copyWith(error: 'Erro ao atualizar título: $error'));
          }
        },
      );
      emit(state.copyWith(document: updatedDoc, error: null));
    } catch (e) {
      emit(state.copyWith(error: 'Erro ao atualizar título: $e'));
    }
  }

  void toggleSkeletonMode() =>
      emit(_uiPreferencesDelegate.toggleSkeletonMode(state));

  final _viewportDelegate = const ViewportDelegate();
  final _eraserDelegate = const EraserDelegate();
  final _snapDelegate = const SnapDelegate();
  final _uiPreferencesDelegate = const UIPreferencesDelegate();
  final _selectionDelegate = const SelectionDelegate();
  final _textEditingDelegate = const TextEditingDelegate();
  final _drawingDelegate = const DrawingDelegate();

  void toggleFullScreen() =>
      emit(_uiPreferencesDelegate.toggleFullScreen(state));

  void toggleToolbarPosition() =>
      emit(_uiPreferencesDelegate.toggleToolbarPosition(state));

  void setToolbarPosition(bool atTop) =>
      emit(_uiPreferencesDelegate.setToolbarPosition(state, atTop));

  void toggleZoomUndoRedo() =>
      emit(_uiPreferencesDelegate.toggleZoomUndoRedo(state));

  void zoomIn() => emit(_viewportDelegate.zoomIn(state));

  void zoomOut() => emit(_viewportDelegate.zoomOut(state));

  void setZoom(double value) => emit(_viewportDelegate.setZoom(state, value));

  void setPanOffset(Offset offset) =>
      emit(_viewportDelegate.setPanOffset(state, offset));

  void panBy(Offset delta) => emit(_viewportDelegate.panBy(state, delta));

  void setSelectionBox(Rect? rect) =>
      emit(_selectionDelegate.setSelectionBox(state, rect));

  void setHoveredElement(String? id) =>
      emit(_selectionDelegate.setHoveredElement(state, id));

  void setEraserMode(EraserMode mode) => emit(
        state.copyWith(
          interaction: _eraserDelegate.setEraserMode(state.interaction, mode),
        ),
      );
  void startEraser(Offset point) => emit(
        state.copyWith(
          interaction: _eraserDelegate.startEraser(state.interaction, point),
        ),
      );
  void updateEraserTrail(Offset point) => emit(
        state.copyWith(
          interaction:
              _eraserDelegate.updateEraserTrail(state.interaction, point),
        ),
      );
  void endEraser() => emit(
        state.copyWith(
          interaction: _eraserDelegate.endEraser(state.interaction),
        ),
      );

  Future<void> loadAngleSnapSettings() async {
    final repo = _settingsRepository;
    if (repo == null) return;
    emit(await _snapDelegate.loadAngleSnapSettings(state, repo));
  }

  Future<void> setSnapMode(SnapMode mode) async {
    emit(await _snapDelegate.setSnapMode(state, mode, _settingsRepository));
  }

  Future<void> cycleSnapMode() async {
    emit(await _snapDelegate.cycleSnapMode(state, _settingsRepository));
  }

  Future<void> setAngleSnapEnabled(bool value) async {
    emit(await _snapDelegate.setAngleSnapEnabled(
        state, value, _settingsRepository));
  }

  Future<void> toggleAngleSnapEnabled() async {
    await cycleSnapMode();
  }

  void setSnapGuides(List<SnapGuide> guides) =>
      emit(_snapDelegate.setSnapGuides(state, guides));

  Future<void> setAngleSnapStep(double value) async {
    emit(await _snapDelegate.setAngleSnapStep(
        state, value, _settingsRepository));
  }

  void selectTool(CanvasElementType tool) {
    if (state.selectedTool == tool) return;

    final List<String> newSelection = (tool == CanvasElementType.selection ||
            tool == CanvasElementType.navigation)
        ? state.selectedElementIds
        : [];

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

  void startDrawing(Offset position) => _drawingDelegate.startDrawing(
        state: state,
        position: position,
        drawingService: _drawingService,
        emit: emit,
      );

  String? createTextElement(Offset position) =>
      _textEditingDelegate.createTextElement(
        state: state,
        position: position,
        uuid: _uuid,
        commandStack: _commandStack,
        emit: emit,
        applyCallback: _applyElementsFromCommand,
      );

  void updateDrawing(
    Offset currentPosition, {
    bool keepAspect = false,
    bool snapAngle = false,
    bool createFromCenter = false,
    double? snapAngleStep,
  }) {
    if (!state.isDrawing || state.activeElementId == null) return;

    final now = DateTime.now();
    if (now.difference(_lastDrawUpdate) < const Duration(milliseconds: 16)) {
      _drawThrottleTimer?.cancel();
      _drawThrottleTimer = Timer(const Duration(milliseconds: 16), () {
        if (isClosed) return;
        updateDrawing(
          currentPosition,
          keepAspect: keepAspect,
          snapAngle: snapAngle,
          createFromCenter: createFromCenter,
          snapAngleStep: snapAngleStep,
        );
      });
      return;
    }

    _drawThrottleTimer?.cancel();
    _lastDrawUpdate = now;

    final element = state.activeElement;
    if (element == null) return;

    _drawingDelegate.updateDrawing(
      state: state,
      currentPosition: currentPosition,
      drawingService: _drawingService,
      emit: emit,
      keepAspect: keepAspect,
      snapAngle: snapAngle,
      snapAngleStep: snapAngleStep,
      createFromCenter: createFromCenter,
    );
  }

  void updateTextElement(String elementId, String text) =>
      _textEditingDelegate.updateTextElement(
        state: state,
        elementId: elementId,
        text: text,
        emit: emit,
        scheduleSave: _scheduleSaveDocument,
      );

  void commitTextEditing(String elementId, String text) =>
      _textEditingDelegate.commitTextEditing(
        state: state,
        elementId: elementId,
        text: text,
        emit: emit,
        scheduleSave: _scheduleSaveDocument,
        persistenceService: _persistenceService,
        deleteElementByIdCallback: deleteElementById,
      );

  Future<void> finalizeTextEditing(String elementId) =>
      _textEditingDelegate.finalizeTextEditing(
        state: state,
        elementId: elementId,
        persistenceService: _persistenceService,
        emit: emit,
      );

  void setEditingText(String? id) =>
      _textEditingDelegate.setEditingText(state: state, id: id, emit: emit);

  Future<void> stopDrawing() => _drawingDelegate.stopDrawing(
        state: state,
        persistenceService: _persistenceService,
        emit: emit,
      );

  void clearCanvas() {
    if (state.document.elements.isEmpty) return;
    final before = List<CanvasElement>.from(state.document.elements);
    final updatedDoc = state.document.copyWith(elements: []);
    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(selectedElementIds: []),
      ),
    );
    _commandStack.add(
      RemoveElementCommand(
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
          selectedElementIds: [],
          activeElementId: null,
        ),
      ),
    );
  }

  void selectElementAt(Offset localPosition, {bool isMultiSelect = false}) {
    emit(_selectionDelegate.selectElementAt(
      state,
      localPosition,
      isMultiSelect: isMultiSelect,
    ));
  }

  void selectElementsInRect(Rect selectionRect) {
    emit(_selectionDelegate.selectElementsInRect(state, selectionRect));
  }

  void moveSelectedElements(Offset delta) =>
      _elementManipulationDelegate.moveSelectedElements(
        state: state,
        delta: delta,
        emit: emit,
      );

  void resizeSelectedElement(Rect rect) =>
      _elementManipulationDelegate.resizeSelectedElement(
        state: state,
        rect: rect,
        emit: emit,
      );

  void rotateSelectedElement(double angle) =>
      _elementManipulationDelegate.rotateSelectedElement(
        state: state,
        angle: angle,
        emit: emit,
      );

  void updateLineEndpoint({
    required bool isStart,
    required Offset worldPoint,
    bool snapAngle = false,
    double? angleStep,
  }) =>
      _elementManipulationDelegate.updateLineEndpoint(
        state: state,
        isStart: isStart,
        worldPoint: worldPoint,
        emit: emit,
        snapAngle: snapAngle,
        angleStep: angleStep,
      );

  Future<void> finalizeManipulation() =>
      _elementManipulationDelegate.finalizeManipulation(
        state: state,
        documentRepository: _documentRepository,
        emit: emit,
      );

  void deleteSelectedElements() =>
      _elementManipulationDelegate.deleteSelectedElements(
        state: state,
        commandStack: _commandStack,
        emit: emit,
        applyCallback: _applyElementsFromCommand,
        scheduleSave: _scheduleSaveDocument,
      );

  void eraseElementsAtPoint(Offset worldPoint, double radius) {
    final updatedElements = _eraserDelegate.eraseElements(
      state.document.elements,
      worldPoint,
      radius,
    );

    if (updatedElements.length == state.document.elements.length) return;

    final updatedDoc = state.document.copyWith(elements: updatedElements);
    emit(
      state.copyWith(
        document: updatedDoc,
        interaction: state.interaction.copyWith(selectedElementIds: []),
      ),
    );
    _scheduleSaveDocument(updatedDoc);
  }

  void deleteElementById(String elementId) =>
      _elementManipulationDelegate.deleteElementById(
        state: state,
        elementId: elementId,
        commandStack: _commandStack,
        emit: emit,
        applyCallback: _applyElementsFromCommand,
        scheduleSave: _scheduleSaveDocument,
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

    _elementManipulationDelegate.updateSelectedElementsProperties(
      state: state,
      commandStack: _commandStack,
      emit: emit,
      applyCallback: _applyElementsFromCommand,
      scheduleSave: _scheduleSaveDocument,
      patch: patch,
    );
  }

  void updateCurrentStyle(ElementStyle style) =>
      _elementManipulationDelegate.updateCurrentStyle(
        state: state,
        style: style,
        emit: emit,
      );
}
