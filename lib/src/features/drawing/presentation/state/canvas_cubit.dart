import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';

import 'package:notexia/src/features/drawing/domain/commands/remove_element_command.dart';

import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

import 'package:notexia/src/features/drawing/domain/repositories/document_repository.dart';
import 'package:notexia/src/features/drawing/presentation/state/canvas_state.dart';
import 'package:notexia/src/features/settings/domain/repositories/app_settings_repository.dart';

import 'package:notexia/src/features/drawing/presentation/state/scopes/drawing_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/eraser_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/manipulation_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/preferences_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/selection_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/snap_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/text_scope.dart';
import 'package:notexia/src/features/drawing/presentation/state/scopes/viewport_scope.dart';

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

  late final viewport = ViewportScope(
    () => state,
    (s) => emit(s),
  );

  late final preferences = PreferencesScope(
    () => state,
    (s) => emit(s),
  );

  late final snap = SnapScope(
    () => state,
    (s) => emit(s),
    _settingsRepository,
  );

  late final selection = SelectionScope(
    () => state,
    (s) => emit(s),
  );

  late final eraser = EraserScope(
    () => state,
    (s) => emit(s),
    _scheduleSaveDocument,
  );

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

  void deleteElementById(String id) {
    if (isClosed) return;
    final element =
        state.document.elements.where((e) => e.id == id).firstOrNull;
    if (element == null) return;

    final updatedElements = List<CanvasElement>.from(state.document.elements)
      ..removeWhere((e) => e.id == id);

    // Se o elemento deletado estava selecionado, remove da seleção
    final updatedSelection =
        List<String>.from(state.interaction.selectedElementIds)..remove(id);

    emit(state.copyWith(
      document: state.document.copyWith(elements: updatedElements),
      interaction: state.interaction.copyWith(
        selectedElementIds: updatedSelection,
      ),
    ));

    _commandStack.add(
      RemoveElementCommand(
        before: [element],
        after: const [],
        applyElements: _applyElementsFromCommand,
        label: 'Excluir elemento',
      ),
    );
  }
}
