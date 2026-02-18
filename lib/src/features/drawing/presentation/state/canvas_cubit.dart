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

import 'package:notexia/src/features/drawing/presentation/state/scopes/drawing_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/manipulation_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/selection_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/text_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/viewport_scope.dart';

import 'package:notexia/src/features/drawing/presentation/state/delegates/eraser_delegate.dart';
import 'package:notexia/src/features/drawing/presentation/state/delegates/snap_delegate.dart';
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
  final _eraserDelegate = const EraserDelegate();
  final _snapDelegate = const SnapDelegate();
  final _uuid = const Uuid();

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

  late final viewport = ViewportScope(
    () => state,
    (s) => emit(s),
  );

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

  late final selection = SelectionScope(
    () => state,
    (s) => emit(s),
  );

  // Eraser Operations
  void setEraserMode(EraserMode mode) => emit(
        state.copyWith(
          interaction: _eraserDelegate.setEraserMode(
            state.interaction,
            mode,
          ),
        ),
      );

  void startEraser(Offset point) => emit(
        state.copyWith(
          interaction: _eraserDelegate.startEraser(
            state.interaction,
            point,
          ),
        ),
      );

  void updateEraserTrail(Offset point) => emit(
        state.copyWith(
          interaction: _eraserDelegate.updateEraserTrail(
            state.interaction,
            point,
          ),
        ),
      );

  void endEraser() => emit(
        state.copyWith(
          interaction: _eraserDelegate.endEraser(state.interaction),
        ),
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
  );

  late final text = TextScope(
    () => state,
    (s) => emit(s),
    _scheduleSaveDocument,
    deleteElementById,
    _applyElementsFromCommand,
    _commandStack,
    _persistenceService,
    _uuid,
  );

  late final manipulation = ManipulationScope(
    () => state,
    (s) => emit(s),
    _scheduleSaveDocument,
    _applyElementsFromCommand,
    _elementManipulationDelegate,
    _commandStack,
    _documentRepository,
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

  void deleteElementById(String id) {
    if (isClosed) return;
    final element =
        state.document.elements.where((e) => e.id == id).firstOrNull;
    if (element == null) return;

    final updatedElements = List<CanvasElement>.from(state.document.elements)
      ..removeWhere((e) => e.id == id);

    // Se o elemento deletado estava selecionado, remove da seleção
    final updatedSelection =
        Set<String>.from(state.interaction.selectedElementIds)..remove(id);

    emit(state.copyWith(
      document: state.document.copyWith(elements: updatedElements),
      interaction: state.interaction.copyWith(
        selectedElementIds: updatedSelection,
      ),
    ));

    _commandStack.add(
      ElementsCommand(
        before: [element],
        after: const [],
        applyElements: _applyElementsFromCommand,
        label: 'Excluir elemento',
      ),
    );
  }
}
