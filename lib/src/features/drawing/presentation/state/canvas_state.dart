import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_enums.dart';
import 'package:notexia/src/features/drawing/domain/models/element_style.dart';
import 'package:notexia/src/features/drawing/domain/models/snap_models.dart';
import 'package:notexia/src/features/drawing/domain/models/drawing_document.dart';

part 'canvas_state.freezed.dart';

enum EraserMode { all, stroke, area }

@freezed
class CanvasTransform with _$CanvasTransform {
  const factory CanvasTransform({
    @Default(1.0) double zoomLevel,
    @Default(Offset.zero) Offset panOffset,
    Rect? selectionBox,
  }) = _CanvasTransform;
}

@freezed
class EraserState with _$EraserState {
  const factory EraserState({
    @Default(EraserMode.stroke) EraserMode mode,
    @Default([]) List<Offset> trail,
    @Default(false) bool isActive,
  }) = _EraserState;
}

@freezed
class SnapState with _$SnapState {
  const SnapState._();
  const factory SnapState({
    @Default(SnapMode.none) SnapMode mode,
    @Default(0.2617993877991494) double angleStep,
    @Default([]) List<SnapGuide> guides,
  }) = _SnapState;

  bool get isAngleSnapEnabled => mode.isAngleSnapEnabled;
}

@freezed
class TextEditingState with _$TextEditingState {
  const factory TextEditingState({
    String? editingTextId,
  }) = _TextEditingState;
}

@freezed
class InteractionState with _$InteractionState {
  const factory InteractionState({
    @Default(CanvasElementType.rectangle) CanvasElementType selectedTool,
    @Default([]) List<String> selectedElementIds,
    @Default(false) bool isDrawing,
    String? activeElementId,
    Offset? gestureStartPosition,
    @Default(ElementStyle()) ElementStyle currentStyle,
    String? hoveredElementId,
    CanvasElement? activeDrawingElement,
    @Default(EraserState()) EraserState eraser,
    @Default(SnapState()) SnapState snap,
    @Default(TextEditingState()) TextEditingState textEditing,
  }) = _InteractionState;
}

@freezed
class CanvasState with _$CanvasState {
  const CanvasState._();
  const factory CanvasState({
    required DrawingDocument document,
    @Default(CanvasTransform()) CanvasTransform transform,
    @Default(InteractionState()) InteractionState interaction,
    @Default(false) bool isSkeletonMode,
    @Default(false) bool isFullScreen,
    @Default(false) bool isToolbarAtTop,
    @Default(false) bool isZoomMode,
    String? error,
  }) = _CanvasState;

  List<CanvasElement> get elements => document.elements;

  CanvasElementType get selectedTool => interaction.selectedTool;
  List<String> get selectedElementIds => interaction.selectedElementIds;
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
}
