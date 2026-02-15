// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CanvasTransform {
  double get zoomLevel => throw _privateConstructorUsedError;
  Offset get panOffset => throw _privateConstructorUsedError;
  Rect? get selectionBox => throw _privateConstructorUsedError;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanvasTransformCopyWith<CanvasTransform> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasTransformCopyWith<$Res> {
  factory $CanvasTransformCopyWith(
          CanvasTransform value, $Res Function(CanvasTransform) then) =
      _$CanvasTransformCopyWithImpl<$Res, CanvasTransform>;
  @useResult
  $Res call({double zoomLevel, Offset panOffset, Rect? selectionBox});
}

/// @nodoc
class _$CanvasTransformCopyWithImpl<$Res, $Val extends CanvasTransform>
    implements $CanvasTransformCopyWith<$Res> {
  _$CanvasTransformCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoomLevel = null,
    Object? panOffset = null,
    Object? selectionBox = freezed,
  }) {
    return _then(_value.copyWith(
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      selectionBox: freezed == selectionBox
          ? _value.selectionBox
          : selectionBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CanvasTransformImplCopyWith<$Res>
    implements $CanvasTransformCopyWith<$Res> {
  factory _$$CanvasTransformImplCopyWith(_$CanvasTransformImpl value,
          $Res Function(_$CanvasTransformImpl) then) =
      __$$CanvasTransformImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double zoomLevel, Offset panOffset, Rect? selectionBox});
}

/// @nodoc
class __$$CanvasTransformImplCopyWithImpl<$Res>
    extends _$CanvasTransformCopyWithImpl<$Res, _$CanvasTransformImpl>
    implements _$$CanvasTransformImplCopyWith<$Res> {
  __$$CanvasTransformImplCopyWithImpl(
      _$CanvasTransformImpl _value, $Res Function(_$CanvasTransformImpl) _then)
      : super(_value, _then);

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoomLevel = null,
    Object? panOffset = null,
    Object? selectionBox = freezed,
  }) {
    return _then(_$CanvasTransformImpl(
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      selectionBox: freezed == selectionBox
          ? _value.selectionBox
          : selectionBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ));
  }
}

/// @nodoc

class _$CanvasTransformImpl implements _CanvasTransform {
  const _$CanvasTransformImpl(
      {this.zoomLevel = 1.0, this.panOffset = Offset.zero, this.selectionBox});

  @override
  @JsonKey()
  final double zoomLevel;
  @override
  @JsonKey()
  final Offset panOffset;
  @override
  final Rect? selectionBox;

  @override
  String toString() {
    return 'CanvasTransform(zoomLevel: $zoomLevel, panOffset: $panOffset, selectionBox: $selectionBox)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanvasTransformImpl &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.panOffset, panOffset) ||
                other.panOffset == panOffset) &&
            (identical(other.selectionBox, selectionBox) ||
                other.selectionBox == selectionBox));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, zoomLevel, panOffset, selectionBox);

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanvasTransformImplCopyWith<_$CanvasTransformImpl> get copyWith =>
      __$$CanvasTransformImplCopyWithImpl<_$CanvasTransformImpl>(
          this, _$identity);
}

abstract class _CanvasTransform implements CanvasTransform {
  const factory _CanvasTransform(
      {final double zoomLevel,
      final Offset panOffset,
      final Rect? selectionBox}) = _$CanvasTransformImpl;

  @override
  double get zoomLevel;
  @override
  Offset get panOffset;
  @override
  Rect? get selectionBox;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanvasTransformImplCopyWith<_$CanvasTransformImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$EraserState {
  EraserMode get mode => throw _privateConstructorUsedError;
  List<Offset> get trail => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EraserStateCopyWith<EraserState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EraserStateCopyWith<$Res> {
  factory $EraserStateCopyWith(
          EraserState value, $Res Function(EraserState) then) =
      _$EraserStateCopyWithImpl<$Res, EraserState>;
  @useResult
  $Res call({EraserMode mode, List<Offset> trail, bool isActive});
}

/// @nodoc
class _$EraserStateCopyWithImpl<$Res, $Val extends EraserState>
    implements $EraserStateCopyWith<$Res> {
  _$EraserStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? trail = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as EraserMode,
      trail: null == trail
          ? _value.trail
          : trail // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EraserStateImplCopyWith<$Res>
    implements $EraserStateCopyWith<$Res> {
  factory _$$EraserStateImplCopyWith(
          _$EraserStateImpl value, $Res Function(_$EraserStateImpl) then) =
      __$$EraserStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EraserMode mode, List<Offset> trail, bool isActive});
}

/// @nodoc
class __$$EraserStateImplCopyWithImpl<$Res>
    extends _$EraserStateCopyWithImpl<$Res, _$EraserStateImpl>
    implements _$$EraserStateImplCopyWith<$Res> {
  __$$EraserStateImplCopyWithImpl(
      _$EraserStateImpl _value, $Res Function(_$EraserStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? trail = null,
    Object? isActive = null,
  }) {
    return _then(_$EraserStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as EraserMode,
      trail: null == trail
          ? _value._trail
          : trail // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$EraserStateImpl implements _EraserState {
  const _$EraserStateImpl(
      {this.mode = EraserMode.stroke,
      final List<Offset> trail = const [],
      this.isActive = false})
      : _trail = trail;

  @override
  @JsonKey()
  final EraserMode mode;
  final List<Offset> _trail;
  @override
  @JsonKey()
  List<Offset> get trail {
    if (_trail is EqualUnmodifiableListView) return _trail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trail);
  }

  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'EraserState(mode: $mode, trail: $trail, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EraserStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other._trail, _trail) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mode, const DeepCollectionEquality().hash(_trail), isActive);

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EraserStateImplCopyWith<_$EraserStateImpl> get copyWith =>
      __$$EraserStateImplCopyWithImpl<_$EraserStateImpl>(this, _$identity);
}

abstract class _EraserState implements EraserState {
  const factory _EraserState(
      {final EraserMode mode,
      final List<Offset> trail,
      final bool isActive}) = _$EraserStateImpl;

  @override
  EraserMode get mode;
  @override
  List<Offset> get trail;
  @override
  bool get isActive;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EraserStateImplCopyWith<_$EraserStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SnapState {
  SnapMode get mode => throw _privateConstructorUsedError;
  double get angleStep => throw _privateConstructorUsedError;
  List<SnapGuide> get guides => throw _privateConstructorUsedError;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnapStateCopyWith<SnapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapStateCopyWith<$Res> {
  factory $SnapStateCopyWith(SnapState value, $Res Function(SnapState) then) =
      _$SnapStateCopyWithImpl<$Res, SnapState>;
  @useResult
  $Res call({SnapMode mode, double angleStep, List<SnapGuide> guides});
}

/// @nodoc
class _$SnapStateCopyWithImpl<$Res, $Val extends SnapState>
    implements $SnapStateCopyWith<$Res> {
  _$SnapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? angleStep = null,
    Object? guides = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SnapMode,
      angleStep: null == angleStep
          ? _value.angleStep
          : angleStep // ignore: cast_nullable_to_non_nullable
              as double,
      guides: null == guides
          ? _value.guides
          : guides // ignore: cast_nullable_to_non_nullable
              as List<SnapGuide>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SnapStateImplCopyWith<$Res>
    implements $SnapStateCopyWith<$Res> {
  factory _$$SnapStateImplCopyWith(
          _$SnapStateImpl value, $Res Function(_$SnapStateImpl) then) =
      __$$SnapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SnapMode mode, double angleStep, List<SnapGuide> guides});
}

/// @nodoc
class __$$SnapStateImplCopyWithImpl<$Res>
    extends _$SnapStateCopyWithImpl<$Res, _$SnapStateImpl>
    implements _$$SnapStateImplCopyWith<$Res> {
  __$$SnapStateImplCopyWithImpl(
      _$SnapStateImpl _value, $Res Function(_$SnapStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? angleStep = null,
    Object? guides = null,
  }) {
    return _then(_$SnapStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SnapMode,
      angleStep: null == angleStep
          ? _value.angleStep
          : angleStep // ignore: cast_nullable_to_non_nullable
              as double,
      guides: null == guides
          ? _value._guides
          : guides // ignore: cast_nullable_to_non_nullable
              as List<SnapGuide>,
    ));
  }
}

/// @nodoc

class _$SnapStateImpl extends _SnapState {
  const _$SnapStateImpl(
      {this.mode = SnapMode.none,
      this.angleStep = 0.2617993877991494,
      final List<SnapGuide> guides = const []})
      : _guides = guides,
        super._();

  @override
  @JsonKey()
  final SnapMode mode;
  @override
  @JsonKey()
  final double angleStep;
  final List<SnapGuide> _guides;
  @override
  @JsonKey()
  List<SnapGuide> get guides {
    if (_guides is EqualUnmodifiableListView) return _guides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guides);
  }

  @override
  String toString() {
    return 'SnapState(mode: $mode, angleStep: $angleStep, guides: $guides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.angleStep, angleStep) ||
                other.angleStep == angleStep) &&
            const DeepCollectionEquality().equals(other._guides, _guides));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, angleStep,
      const DeepCollectionEquality().hash(_guides));

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapStateImplCopyWith<_$SnapStateImpl> get copyWith =>
      __$$SnapStateImplCopyWithImpl<_$SnapStateImpl>(this, _$identity);
}

abstract class _SnapState extends SnapState {
  const factory _SnapState(
      {final SnapMode mode,
      final double angleStep,
      final List<SnapGuide> guides}) = _$SnapStateImpl;
  const _SnapState._() : super._();

  @override
  SnapMode get mode;
  @override
  double get angleStep;
  @override
  List<SnapGuide> get guides;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnapStateImplCopyWith<_$SnapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$TextEditingState {
  String? get editingTextId => throw _privateConstructorUsedError;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TextEditingStateCopyWith<TextEditingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TextEditingStateCopyWith<$Res> {
  factory $TextEditingStateCopyWith(
          TextEditingState value, $Res Function(TextEditingState) then) =
      _$TextEditingStateCopyWithImpl<$Res, TextEditingState>;
  @useResult
  $Res call({String? editingTextId});
}

/// @nodoc
class _$TextEditingStateCopyWithImpl<$Res, $Val extends TextEditingState>
    implements $TextEditingStateCopyWith<$Res> {
  _$TextEditingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editingTextId = freezed,
  }) {
    return _then(_value.copyWith(
      editingTextId: freezed == editingTextId
          ? _value.editingTextId
          : editingTextId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TextEditingStateImplCopyWith<$Res>
    implements $TextEditingStateCopyWith<$Res> {
  factory _$$TextEditingStateImplCopyWith(_$TextEditingStateImpl value,
          $Res Function(_$TextEditingStateImpl) then) =
      __$$TextEditingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? editingTextId});
}

/// @nodoc
class __$$TextEditingStateImplCopyWithImpl<$Res>
    extends _$TextEditingStateCopyWithImpl<$Res, _$TextEditingStateImpl>
    implements _$$TextEditingStateImplCopyWith<$Res> {
  __$$TextEditingStateImplCopyWithImpl(_$TextEditingStateImpl _value,
      $Res Function(_$TextEditingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editingTextId = freezed,
  }) {
    return _then(_$TextEditingStateImpl(
      editingTextId: freezed == editingTextId
          ? _value.editingTextId
          : editingTextId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TextEditingStateImpl implements _TextEditingState {
  const _$TextEditingStateImpl({this.editingTextId});

  @override
  final String? editingTextId;

  @override
  String toString() {
    return 'TextEditingState(editingTextId: $editingTextId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextEditingStateImpl &&
            (identical(other.editingTextId, editingTextId) ||
                other.editingTextId == editingTextId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, editingTextId);

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TextEditingStateImplCopyWith<_$TextEditingStateImpl> get copyWith =>
      __$$TextEditingStateImplCopyWithImpl<_$TextEditingStateImpl>(
          this, _$identity);
}

abstract class _TextEditingState implements TextEditingState {
  const factory _TextEditingState({final String? editingTextId}) =
      _$TextEditingStateImpl;

  @override
  String? get editingTextId;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TextEditingStateImplCopyWith<_$TextEditingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InteractionState {
  CanvasElementType get selectedTool => throw _privateConstructorUsedError;
  List<String> get selectedElementIds => throw _privateConstructorUsedError;
  bool get isDrawing => throw _privateConstructorUsedError;
  String? get activeElementId => throw _privateConstructorUsedError;
  Offset? get gestureStartPosition => throw _privateConstructorUsedError;
  ElementStyle get currentStyle => throw _privateConstructorUsedError;
  String? get hoveredElementId => throw _privateConstructorUsedError;
  CanvasElement? get activeDrawingElement => throw _privateConstructorUsedError;
  EraserState get eraser => throw _privateConstructorUsedError;
  SnapState get snap => throw _privateConstructorUsedError;
  TextEditingState get textEditing => throw _privateConstructorUsedError;

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InteractionStateCopyWith<InteractionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InteractionStateCopyWith<$Res> {
  factory $InteractionStateCopyWith(
          InteractionState value, $Res Function(InteractionState) then) =
      _$InteractionStateCopyWithImpl<$Res, InteractionState>;
  @useResult
  $Res call(
      {CanvasElementType selectedTool,
      List<String> selectedElementIds,
      bool isDrawing,
      String? activeElementId,
      Offset? gestureStartPosition,
      ElementStyle currentStyle,
      String? hoveredElementId,
      CanvasElement? activeDrawingElement,
      EraserState eraser,
      SnapState snap,
      TextEditingState textEditing});

  $EraserStateCopyWith<$Res> get eraser;
  $SnapStateCopyWith<$Res> get snap;
  $TextEditingStateCopyWith<$Res> get textEditing;
}

/// @nodoc
class _$InteractionStateCopyWithImpl<$Res, $Val extends InteractionState>
    implements $InteractionStateCopyWith<$Res> {
  _$InteractionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTool = null,
    Object? selectedElementIds = null,
    Object? isDrawing = null,
    Object? activeElementId = freezed,
    Object? gestureStartPosition = freezed,
    Object? currentStyle = null,
    Object? hoveredElementId = freezed,
    Object? activeDrawingElement = freezed,
    Object? eraser = null,
    Object? snap = null,
    Object? textEditing = null,
  }) {
    return _then(_value.copyWith(
      selectedTool: null == selectedTool
          ? _value.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      selectedElementIds: null == selectedElementIds
          ? _value.selectedElementIds
          : selectedElementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDrawing: null == isDrawing
          ? _value.isDrawing
          : isDrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeElementId: freezed == activeElementId
          ? _value.activeElementId
          : activeElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      gestureStartPosition: freezed == gestureStartPosition
          ? _value.gestureStartPosition
          : gestureStartPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      currentStyle: null == currentStyle
          ? _value.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as ElementStyle,
      hoveredElementId: freezed == hoveredElementId
          ? _value.hoveredElementId
          : hoveredElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeDrawingElement: freezed == activeDrawingElement
          ? _value.activeDrawingElement
          : activeDrawingElement // ignore: cast_nullable_to_non_nullable
              as CanvasElement?,
      eraser: null == eraser
          ? _value.eraser
          : eraser // ignore: cast_nullable_to_non_nullable
              as EraserState,
      snap: null == snap
          ? _value.snap
          : snap // ignore: cast_nullable_to_non_nullable
              as SnapState,
      textEditing: null == textEditing
          ? _value.textEditing
          : textEditing // ignore: cast_nullable_to_non_nullable
              as TextEditingState,
    ) as $Val);
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EraserStateCopyWith<$Res> get eraser {
    return $EraserStateCopyWith<$Res>(_value.eraser, (value) {
      return _then(_value.copyWith(eraser: value) as $Val);
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SnapStateCopyWith<$Res> get snap {
    return $SnapStateCopyWith<$Res>(_value.snap, (value) {
      return _then(_value.copyWith(snap: value) as $Val);
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextEditingStateCopyWith<$Res> get textEditing {
    return $TextEditingStateCopyWith<$Res>(_value.textEditing, (value) {
      return _then(_value.copyWith(textEditing: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InteractionStateImplCopyWith<$Res>
    implements $InteractionStateCopyWith<$Res> {
  factory _$$InteractionStateImplCopyWith(_$InteractionStateImpl value,
          $Res Function(_$InteractionStateImpl) then) =
      __$$InteractionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CanvasElementType selectedTool,
      List<String> selectedElementIds,
      bool isDrawing,
      String? activeElementId,
      Offset? gestureStartPosition,
      ElementStyle currentStyle,
      String? hoveredElementId,
      CanvasElement? activeDrawingElement,
      EraserState eraser,
      SnapState snap,
      TextEditingState textEditing});

  @override
  $EraserStateCopyWith<$Res> get eraser;
  @override
  $SnapStateCopyWith<$Res> get snap;
  @override
  $TextEditingStateCopyWith<$Res> get textEditing;
}

/// @nodoc
class __$$InteractionStateImplCopyWithImpl<$Res>
    extends _$InteractionStateCopyWithImpl<$Res, _$InteractionStateImpl>
    implements _$$InteractionStateImplCopyWith<$Res> {
  __$$InteractionStateImplCopyWithImpl(_$InteractionStateImpl _value,
      $Res Function(_$InteractionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTool = null,
    Object? selectedElementIds = null,
    Object? isDrawing = null,
    Object? activeElementId = freezed,
    Object? gestureStartPosition = freezed,
    Object? currentStyle = null,
    Object? hoveredElementId = freezed,
    Object? activeDrawingElement = freezed,
    Object? eraser = null,
    Object? snap = null,
    Object? textEditing = null,
  }) {
    return _then(_$InteractionStateImpl(
      selectedTool: null == selectedTool
          ? _value.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      selectedElementIds: null == selectedElementIds
          ? _value._selectedElementIds
          : selectedElementIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDrawing: null == isDrawing
          ? _value.isDrawing
          : isDrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeElementId: freezed == activeElementId
          ? _value.activeElementId
          : activeElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      gestureStartPosition: freezed == gestureStartPosition
          ? _value.gestureStartPosition
          : gestureStartPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      currentStyle: null == currentStyle
          ? _value.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as ElementStyle,
      hoveredElementId: freezed == hoveredElementId
          ? _value.hoveredElementId
          : hoveredElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeDrawingElement: freezed == activeDrawingElement
          ? _value.activeDrawingElement
          : activeDrawingElement // ignore: cast_nullable_to_non_nullable
              as CanvasElement?,
      eraser: null == eraser
          ? _value.eraser
          : eraser // ignore: cast_nullable_to_non_nullable
              as EraserState,
      snap: null == snap
          ? _value.snap
          : snap // ignore: cast_nullable_to_non_nullable
              as SnapState,
      textEditing: null == textEditing
          ? _value.textEditing
          : textEditing // ignore: cast_nullable_to_non_nullable
              as TextEditingState,
    ));
  }
}

/// @nodoc

class _$InteractionStateImpl implements _InteractionState {
  const _$InteractionStateImpl(
      {this.selectedTool = CanvasElementType.rectangle,
      final List<String> selectedElementIds = const [],
      this.isDrawing = false,
      this.activeElementId,
      this.gestureStartPosition,
      this.currentStyle = const ElementStyle(),
      this.hoveredElementId,
      this.activeDrawingElement,
      this.eraser = const EraserState(),
      this.snap = const SnapState(),
      this.textEditing = const TextEditingState()})
      : _selectedElementIds = selectedElementIds;

  @override
  @JsonKey()
  final CanvasElementType selectedTool;
  final List<String> _selectedElementIds;
  @override
  @JsonKey()
  List<String> get selectedElementIds {
    if (_selectedElementIds is EqualUnmodifiableListView)
      return _selectedElementIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedElementIds);
  }

  @override
  @JsonKey()
  final bool isDrawing;
  @override
  final String? activeElementId;
  @override
  final Offset? gestureStartPosition;
  @override
  @JsonKey()
  final ElementStyle currentStyle;
  @override
  final String? hoveredElementId;
  @override
  final CanvasElement? activeDrawingElement;
  @override
  @JsonKey()
  final EraserState eraser;
  @override
  @JsonKey()
  final SnapState snap;
  @override
  @JsonKey()
  final TextEditingState textEditing;

  @override
  String toString() {
    return 'InteractionState(selectedTool: $selectedTool, selectedElementIds: $selectedElementIds, isDrawing: $isDrawing, activeElementId: $activeElementId, gestureStartPosition: $gestureStartPosition, currentStyle: $currentStyle, hoveredElementId: $hoveredElementId, activeDrawingElement: $activeDrawingElement, eraser: $eraser, snap: $snap, textEditing: $textEditing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InteractionStateImpl &&
            (identical(other.selectedTool, selectedTool) ||
                other.selectedTool == selectedTool) &&
            const DeepCollectionEquality()
                .equals(other._selectedElementIds, _selectedElementIds) &&
            (identical(other.isDrawing, isDrawing) ||
                other.isDrawing == isDrawing) &&
            (identical(other.activeElementId, activeElementId) ||
                other.activeElementId == activeElementId) &&
            (identical(other.gestureStartPosition, gestureStartPosition) ||
                other.gestureStartPosition == gestureStartPosition) &&
            (identical(other.currentStyle, currentStyle) ||
                other.currentStyle == currentStyle) &&
            (identical(other.hoveredElementId, hoveredElementId) ||
                other.hoveredElementId == hoveredElementId) &&
            (identical(other.activeDrawingElement, activeDrawingElement) ||
                other.activeDrawingElement == activeDrawingElement) &&
            (identical(other.eraser, eraser) || other.eraser == eraser) &&
            (identical(other.snap, snap) || other.snap == snap) &&
            (identical(other.textEditing, textEditing) ||
                other.textEditing == textEditing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedTool,
      const DeepCollectionEquality().hash(_selectedElementIds),
      isDrawing,
      activeElementId,
      gestureStartPosition,
      currentStyle,
      hoveredElementId,
      activeDrawingElement,
      eraser,
      snap,
      textEditing);

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InteractionStateImplCopyWith<_$InteractionStateImpl> get copyWith =>
      __$$InteractionStateImplCopyWithImpl<_$InteractionStateImpl>(
          this, _$identity);
}

abstract class _InteractionState implements InteractionState {
  const factory _InteractionState(
      {final CanvasElementType selectedTool,
      final List<String> selectedElementIds,
      final bool isDrawing,
      final String? activeElementId,
      final Offset? gestureStartPosition,
      final ElementStyle currentStyle,
      final String? hoveredElementId,
      final CanvasElement? activeDrawingElement,
      final EraserState eraser,
      final SnapState snap,
      final TextEditingState textEditing}) = _$InteractionStateImpl;

  @override
  CanvasElementType get selectedTool;
  @override
  List<String> get selectedElementIds;
  @override
  bool get isDrawing;
  @override
  String? get activeElementId;
  @override
  Offset? get gestureStartPosition;
  @override
  ElementStyle get currentStyle;
  @override
  String? get hoveredElementId;
  @override
  CanvasElement? get activeDrawingElement;
  @override
  EraserState get eraser;
  @override
  SnapState get snap;
  @override
  TextEditingState get textEditing;

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InteractionStateImplCopyWith<_$InteractionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CanvasState {
  DrawingDocument get document => throw _privateConstructorUsedError;
  CanvasTransform get transform => throw _privateConstructorUsedError;
  InteractionState get interaction => throw _privateConstructorUsedError;
  bool get isSkeletonMode => throw _privateConstructorUsedError;
  bool get isFullScreen => throw _privateConstructorUsedError;
  bool get isToolbarAtTop => throw _privateConstructorUsedError;
  bool get isZoomMode => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanvasStateCopyWith<CanvasState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanvasStateCopyWith<$Res> {
  factory $CanvasStateCopyWith(
          CanvasState value, $Res Function(CanvasState) then) =
      _$CanvasStateCopyWithImpl<$Res, CanvasState>;
  @useResult
  $Res call(
      {DrawingDocument document,
      CanvasTransform transform,
      InteractionState interaction,
      bool isSkeletonMode,
      bool isFullScreen,
      bool isToolbarAtTop,
      bool isZoomMode,
      String? error});

  $CanvasTransformCopyWith<$Res> get transform;
  $InteractionStateCopyWith<$Res> get interaction;
}

/// @nodoc
class _$CanvasStateCopyWithImpl<$Res, $Val extends CanvasState>
    implements $CanvasStateCopyWith<$Res> {
  _$CanvasStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? document = null,
    Object? transform = null,
    Object? interaction = null,
    Object? isSkeletonMode = null,
    Object? isFullScreen = null,
    Object? isToolbarAtTop = null,
    Object? isZoomMode = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as DrawingDocument,
      transform: null == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as CanvasTransform,
      interaction: null == interaction
          ? _value.interaction
          : interaction // ignore: cast_nullable_to_non_nullable
              as InteractionState,
      isSkeletonMode: null == isSkeletonMode
          ? _value.isSkeletonMode
          : isSkeletonMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isFullScreen: null == isFullScreen
          ? _value.isFullScreen
          : isFullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isToolbarAtTop: null == isToolbarAtTop
          ? _value.isToolbarAtTop
          : isToolbarAtTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isZoomMode: null == isZoomMode
          ? _value.isZoomMode
          : isZoomMode // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CanvasTransformCopyWith<$Res> get transform {
    return $CanvasTransformCopyWith<$Res>(_value.transform, (value) {
      return _then(_value.copyWith(transform: value) as $Val);
    });
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InteractionStateCopyWith<$Res> get interaction {
    return $InteractionStateCopyWith<$Res>(_value.interaction, (value) {
      return _then(_value.copyWith(interaction: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CanvasStateImplCopyWith<$Res>
    implements $CanvasStateCopyWith<$Res> {
  factory _$$CanvasStateImplCopyWith(
          _$CanvasStateImpl value, $Res Function(_$CanvasStateImpl) then) =
      __$$CanvasStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DrawingDocument document,
      CanvasTransform transform,
      InteractionState interaction,
      bool isSkeletonMode,
      bool isFullScreen,
      bool isToolbarAtTop,
      bool isZoomMode,
      String? error});

  @override
  $CanvasTransformCopyWith<$Res> get transform;
  @override
  $InteractionStateCopyWith<$Res> get interaction;
}

/// @nodoc
class __$$CanvasStateImplCopyWithImpl<$Res>
    extends _$CanvasStateCopyWithImpl<$Res, _$CanvasStateImpl>
    implements _$$CanvasStateImplCopyWith<$Res> {
  __$$CanvasStateImplCopyWithImpl(
      _$CanvasStateImpl _value, $Res Function(_$CanvasStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? document = null,
    Object? transform = null,
    Object? interaction = null,
    Object? isSkeletonMode = null,
    Object? isFullScreen = null,
    Object? isToolbarAtTop = null,
    Object? isZoomMode = null,
    Object? error = freezed,
  }) {
    return _then(_$CanvasStateImpl(
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as DrawingDocument,
      transform: null == transform
          ? _value.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as CanvasTransform,
      interaction: null == interaction
          ? _value.interaction
          : interaction // ignore: cast_nullable_to_non_nullable
              as InteractionState,
      isSkeletonMode: null == isSkeletonMode
          ? _value.isSkeletonMode
          : isSkeletonMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isFullScreen: null == isFullScreen
          ? _value.isFullScreen
          : isFullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isToolbarAtTop: null == isToolbarAtTop
          ? _value.isToolbarAtTop
          : isToolbarAtTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isZoomMode: null == isZoomMode
          ? _value.isZoomMode
          : isZoomMode // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CanvasStateImpl extends _CanvasState {
  const _$CanvasStateImpl(
      {required this.document,
      this.transform = const CanvasTransform(),
      this.interaction = const InteractionState(),
      this.isSkeletonMode = false,
      this.isFullScreen = false,
      this.isToolbarAtTop = false,
      this.isZoomMode = false,
      this.error})
      : super._();

  @override
  final DrawingDocument document;
  @override
  @JsonKey()
  final CanvasTransform transform;
  @override
  @JsonKey()
  final InteractionState interaction;
  @override
  @JsonKey()
  final bool isSkeletonMode;
  @override
  @JsonKey()
  final bool isFullScreen;
  @override
  @JsonKey()
  final bool isToolbarAtTop;
  @override
  @JsonKey()
  final bool isZoomMode;
  @override
  final String? error;

  @override
  String toString() {
    return 'CanvasState(document: $document, transform: $transform, interaction: $interaction, isSkeletonMode: $isSkeletonMode, isFullScreen: $isFullScreen, isToolbarAtTop: $isToolbarAtTop, isZoomMode: $isZoomMode, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanvasStateImpl &&
            (identical(other.document, document) ||
                other.document == document) &&
            (identical(other.transform, transform) ||
                other.transform == transform) &&
            (identical(other.interaction, interaction) ||
                other.interaction == interaction) &&
            (identical(other.isSkeletonMode, isSkeletonMode) ||
                other.isSkeletonMode == isSkeletonMode) &&
            (identical(other.isFullScreen, isFullScreen) ||
                other.isFullScreen == isFullScreen) &&
            (identical(other.isToolbarAtTop, isToolbarAtTop) ||
                other.isToolbarAtTop == isToolbarAtTop) &&
            (identical(other.isZoomMode, isZoomMode) ||
                other.isZoomMode == isZoomMode) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, document, transform, interaction,
      isSkeletonMode, isFullScreen, isToolbarAtTop, isZoomMode, error);

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      __$$CanvasStateImplCopyWithImpl<_$CanvasStateImpl>(this, _$identity);
}

abstract class _CanvasState extends CanvasState {
  const factory _CanvasState(
      {required final DrawingDocument document,
      final CanvasTransform transform,
      final InteractionState interaction,
      final bool isSkeletonMode,
      final bool isFullScreen,
      final bool isToolbarAtTop,
      final bool isZoomMode,
      final String? error}) = _$CanvasStateImpl;
  const _CanvasState._() : super._();

  @override
  DrawingDocument get document;
  @override
  CanvasTransform get transform;
  @override
  InteractionState get interaction;
  @override
  bool get isSkeletonMode;
  @override
  bool get isFullScreen;
  @override
  bool get isToolbarAtTop;
  @override
  bool get isZoomMode;
  @override
  String? get error;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanvasStateImplCopyWith<_$CanvasStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
