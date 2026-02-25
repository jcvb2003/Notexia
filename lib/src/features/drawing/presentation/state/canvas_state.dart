import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:notexia/src/core/errors/failure.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

const Object _default = Object();

enum EraserMode { all, stroke, area }

class CanvasTransform extends Equatable {
  final double zoomLevel;
  final Offset panOffset;
  final Rect? selectionBox;

  const CanvasTransform({
    this.zoomLevel = 1.0,
    this.panOffset = Offset.zero,
    this.selectionBox,
  });

  CanvasTransform copyWith({
    double? zoomLevel,
    Offset? panOffset,
    Object? selectionBox = _default,
  }) {
    return CanvasTransform(
      zoomLevel: zoomLevel ?? this.zoomLevel,
      panOffset: panOffset ?? this.panOffset,
      selectionBox:
          selectionBox == _default ? this.selectionBox : selectionBox as Rect?,
    );
  }

  @override
  List<Object?> get props => [zoomLevel, panOffset, selectionBox];
}

class EraserState extends Equatable {
  final EraserMode mode;
  final List<Offset> trail;
  final bool isActive;

  const EraserState({
    this.mode = EraserMode.stroke,
    this.trail = const [],
    this.isActive = false,
  });

  EraserState copyWith({
    EraserMode? mode,
    List<Offset>? trail,
    bool? isActive,
  }) {
    return EraserState(
      mode: mode ?? this.mode,
      trail: trail ?? this.trail,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [mode, trail, isActive];
}

class SnapState extends Equatable {
  final SnapMode mode;
  final double angleStep;
  final List<SnapGuide> guides;

  const SnapState({
    this.mode = SnapMode.none,
    this.angleStep = 0.2617993877991494,
    this.guides = const [],
  });

  bool get isAngleSnapEnabled => mode.isAngleSnapEnabled;

  SnapState copyWith({
    SnapMode? mode,
    double? angleStep,
    List<SnapGuide>? guides,
  }) {
    return SnapState(
      mode: mode ?? this.mode,
      angleStep: angleStep ?? this.angleStep,
      guides: guides ?? this.guides,
    );
  }

  @override
  List<Object?> get props => [mode, angleStep, guides];
}

class TextEditingState extends Equatable {
  final String? editingTextId;

  const TextEditingState({this.editingTextId});

  TextEditingState copyWith({
    Object? editingTextId = _default,
  }) {
    return TextEditingState(
      editingTextId: editingTextId == _default
          ? this.editingTextId
          : editingTextId as String?,
    );
  }

  @override
  List<Object?> get props => [editingTextId];
}

class InteractionState extends Equatable {
  final CanvasElementType selectedTool;
  final Set<String> selectedElementIds;
  final bool isDrawing;
  final String? activeElementId;
  final Offset? gestureStartPosition;
  final ElementStyle currentStyle;
  final String? hoveredElementId;
  final CanvasElement? activeDrawingElement;
  final EraserState eraser;
  final SnapState snap;
  final TextEditingState textEditing;

  const InteractionState({
    this.selectedTool = CanvasElementType.rectangle,
    this.selectedElementIds = const {},
    this.isDrawing = false,
    this.activeElementId,
    this.gestureStartPosition,
    this.currentStyle = const ElementStyle(),
    this.hoveredElementId,
    this.activeDrawingElement,
    this.eraser = const EraserState(),
    this.snap = const SnapState(),
    this.textEditing = const TextEditingState(),
  });

  InteractionState copyWith({
    CanvasElementType? selectedTool,
    Set<String>? selectedElementIds,
    bool? isDrawing,
    Object? activeElementId = _default,
    Object? gestureStartPosition = _default,
    ElementStyle? currentStyle,
    Object? hoveredElementId = _default,
    Object? activeDrawingElement = _default,
    EraserState? eraser,
    SnapState? snap,
    TextEditingState? textEditing,
  }) {
    return InteractionState(
      selectedTool: selectedTool ?? this.selectedTool,
      selectedElementIds: selectedElementIds ?? this.selectedElementIds,
      isDrawing: isDrawing ?? this.isDrawing,
      activeElementId: activeElementId == _default
          ? this.activeElementId
          : activeElementId as String?,
      gestureStartPosition: gestureStartPosition == _default
          ? this.gestureStartPosition
          : gestureStartPosition as Offset?,
      currentStyle: currentStyle ?? this.currentStyle,
      hoveredElementId: hoveredElementId == _default
          ? this.hoveredElementId
          : hoveredElementId as String?,
      activeDrawingElement: activeDrawingElement == _default
          ? this.activeDrawingElement
          : activeDrawingElement as CanvasElement?,
      eraser: eraser ?? this.eraser,
      snap: snap ?? this.snap,
      textEditing: textEditing ?? this.textEditing,
    );
  }

  @override
  List<Object?> get props => [
        selectedTool,
        selectedElementIds,
        isDrawing,
        activeElementId,
        gestureStartPosition,
        currentStyle,
        hoveredElementId,
        activeDrawingElement,
        eraser,
        snap,
        textEditing,
      ];
}

class CanvasState extends Equatable {
  final DrawingDocument document;
  final CanvasTransform transform;
  final InteractionState interaction;
  final bool isSkeletonMode;
  final bool isFullScreen;
  final bool isToolbarAtTop;
  final bool isZoomMode;
  final bool isDrawWithFingerEnabled;
  final bool hasShownStylusPrompt;
  final String? error;
  final Failure? lastFailure;

  const CanvasState({
    required this.document,
    this.transform = const CanvasTransform(),
    this.interaction = const InteractionState(),
    this.isSkeletonMode = false,
    this.isFullScreen = false,
    this.isToolbarAtTop = false,
    this.isZoomMode = false,
    this.isDrawWithFingerEnabled = true,
    this.hasShownStylusPrompt = false,
    this.error,
    this.lastFailure,
  });

  // Convenience getters — delegated from sub-states
  List<CanvasElement> get elements => document.elements;

  CanvasElementType get selectedTool => interaction.selectedTool;
  Set<String> get selectedElementIds => interaction.selectedElementIds;
  bool get isDrawing => interaction.isDrawing;
  String? get activeElementId => interaction.activeElementId;
  Offset? get gestureStartPosition => interaction.gestureStartPosition;
  ElementStyle get currentStyle => interaction.currentStyle;
  String? get hoveredElementId => interaction.hoveredElementId;
  CanvasElement? get activeDrawingElement => interaction.activeDrawingElement;

  // Delegated getters for Sub-states
  EraserMode get eraserMode => interaction.eraser.mode;
  List<Offset> get eraserTrail => interaction.eraser.trail;
  bool get isEraserActive => interaction.eraser.isActive;

  SnapMode get snapMode => interaction.snap.mode;
  double get angleSnapStep => interaction.snap.angleStep;
  List<SnapGuide> get snapGuides => interaction.snap.guides;
  bool get isAngleSnapEnabled => interaction.snap.isAngleSnapEnabled;

  String? get editingTextId => interaction.textEditing.editingTextId;

  double get zoomLevel => transform.zoomLevel;
  Offset get panOffset => transform.panOffset;
  Rect? get selectionBox => transform.selectionBox;

  CanvasElement? get activeElement {
    if (interaction.activeDrawingElement != null) {
      return interaction.activeDrawingElement;
    }
    if (interaction.activeElementId == null) return null;
    return elements
        .where((e) => e.id == interaction.activeElementId)
        .firstOrNull;
  }

  CanvasState copyWith({
    DrawingDocument? document,
    CanvasTransform? transform,
    InteractionState? interaction,
    bool? isSkeletonMode,
    bool? isFullScreen,
    bool? isToolbarAtTop,
    bool? isZoomMode,
    bool? isDrawWithFingerEnabled,
    bool? hasShownStylusPrompt,
    Object? error = _default,
    Object? lastFailure = _default,
  }) {
    return CanvasState(
      document: document ?? this.document,
      transform: transform ?? this.transform,
      interaction: interaction ?? this.interaction,
      isSkeletonMode: isSkeletonMode ?? this.isSkeletonMode,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      isToolbarAtTop: isToolbarAtTop ?? this.isToolbarAtTop,
      isZoomMode: isZoomMode ?? this.isZoomMode,
      isDrawWithFingerEnabled:
          isDrawWithFingerEnabled ?? this.isDrawWithFingerEnabled,
      hasShownStylusPrompt: hasShownStylusPrompt ?? this.hasShownStylusPrompt,
      error: error == _default ? this.error : error as String?,
      lastFailure:
          lastFailure == _default ? this.lastFailure : lastFailure as Failure?,
    );
  }

  @override
  List<Object?> get props => [
        document,
        transform,
        interaction,
        isSkeletonMode,
        isFullScreen,
        isToolbarAtTop,
        isZoomMode,
        isDrawWithFingerEnabled,
        hasShownStylusPrompt,
        error,
        lastFailure,
      ];
}
