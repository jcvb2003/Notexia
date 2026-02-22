// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CanvasTransform {
  double get zoomLevel;
  Offset get panOffset;
  Rect? get selectionBox;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CanvasTransformCopyWith<CanvasTransform> get copyWith =>
      _$CanvasTransformCopyWithImpl<CanvasTransform>(
          this as CanvasTransform, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CanvasTransform &&
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

  @override
  String toString() {
    return 'CanvasTransform(zoomLevel: $zoomLevel, panOffset: $panOffset, selectionBox: $selectionBox)';
  }
}

/// @nodoc
abstract mixin class $CanvasTransformCopyWith<$Res> {
  factory $CanvasTransformCopyWith(
          CanvasTransform value, $Res Function(CanvasTransform) _then) =
      _$CanvasTransformCopyWithImpl;
  @useResult
  $Res call({double zoomLevel, Offset panOffset, Rect? selectionBox});
}

/// @nodoc
class _$CanvasTransformCopyWithImpl<$Res>
    implements $CanvasTransformCopyWith<$Res> {
  _$CanvasTransformCopyWithImpl(this._self, this._then);

  final CanvasTransform _self;
  final $Res Function(CanvasTransform) _then;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? zoomLevel = null,
    Object? panOffset = null,
    Object? selectionBox = freezed,
  }) {
    return _then(_self.copyWith(
      zoomLevel: null == zoomLevel
          ? _self.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _self.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      selectionBox: freezed == selectionBox
          ? _self.selectionBox
          : selectionBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CanvasTransform].
extension CanvasTransformPatterns on CanvasTransform {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CanvasTransform value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CanvasTransform value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CanvasTransform value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(double zoomLevel, Offset panOffset, Rect? selectionBox)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform() when $default != null:
        return $default(_that.zoomLevel, _that.panOffset, _that.selectionBox);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(double zoomLevel, Offset panOffset, Rect? selectionBox)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform():
        return $default(_that.zoomLevel, _that.panOffset, _that.selectionBox);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(double zoomLevel, Offset panOffset, Rect? selectionBox)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasTransform() when $default != null:
        return $default(_that.zoomLevel, _that.panOffset, _that.selectionBox);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CanvasTransform implements CanvasTransform {
  const _CanvasTransform(
      {this.zoomLevel = 1.0, this.panOffset = Offset.zero, this.selectionBox});

  @override
  @JsonKey()
  final double zoomLevel;
  @override
  @JsonKey()
  final Offset panOffset;
  @override
  final Rect? selectionBox;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CanvasTransformCopyWith<_CanvasTransform> get copyWith =>
      __$CanvasTransformCopyWithImpl<_CanvasTransform>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CanvasTransform &&
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

  @override
  String toString() {
    return 'CanvasTransform(zoomLevel: $zoomLevel, panOffset: $panOffset, selectionBox: $selectionBox)';
  }
}

/// @nodoc
abstract mixin class _$CanvasTransformCopyWith<$Res>
    implements $CanvasTransformCopyWith<$Res> {
  factory _$CanvasTransformCopyWith(
          _CanvasTransform value, $Res Function(_CanvasTransform) _then) =
      __$CanvasTransformCopyWithImpl;
  @override
  @useResult
  $Res call({double zoomLevel, Offset panOffset, Rect? selectionBox});
}

/// @nodoc
class __$CanvasTransformCopyWithImpl<$Res>
    implements _$CanvasTransformCopyWith<$Res> {
  __$CanvasTransformCopyWithImpl(this._self, this._then);

  final _CanvasTransform _self;
  final $Res Function(_CanvasTransform) _then;

  /// Create a copy of CanvasTransform
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? zoomLevel = null,
    Object? panOffset = null,
    Object? selectionBox = freezed,
  }) {
    return _then(_CanvasTransform(
      zoomLevel: null == zoomLevel
          ? _self.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _self.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
      selectionBox: freezed == selectionBox
          ? _self.selectionBox
          : selectionBox // ignore: cast_nullable_to_non_nullable
              as Rect?,
    ));
  }
}

/// @nodoc
mixin _$EraserState {
  EraserMode get mode;
  List<Offset> get trail;
  bool get isActive;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EraserStateCopyWith<EraserState> get copyWith =>
      _$EraserStateCopyWithImpl<EraserState>(this as EraserState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EraserState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other.trail, trail) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mode, const DeepCollectionEquality().hash(trail), isActive);

  @override
  String toString() {
    return 'EraserState(mode: $mode, trail: $trail, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class $EraserStateCopyWith<$Res> {
  factory $EraserStateCopyWith(
          EraserState value, $Res Function(EraserState) _then) =
      _$EraserStateCopyWithImpl;
  @useResult
  $Res call({EraserMode mode, List<Offset> trail, bool isActive});
}

/// @nodoc
class _$EraserStateCopyWithImpl<$Res> implements $EraserStateCopyWith<$Res> {
  _$EraserStateCopyWithImpl(this._self, this._then);

  final EraserState _self;
  final $Res Function(EraserState) _then;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? trail = null,
    Object? isActive = null,
  }) {
    return _then(_self.copyWith(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as EraserMode,
      trail: null == trail
          ? _self.trail
          : trail // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [EraserState].
extension EraserStatePatterns on EraserState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_EraserState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EraserState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_EraserState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EraserState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_EraserState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EraserState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(EraserMode mode, List<Offset> trail, bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EraserState() when $default != null:
        return $default(_that.mode, _that.trail, _that.isActive);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(EraserMode mode, List<Offset> trail, bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EraserState():
        return $default(_that.mode, _that.trail, _that.isActive);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(EraserMode mode, List<Offset> trail, bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EraserState() when $default != null:
        return $default(_that.mode, _that.trail, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _EraserState implements EraserState {
  const _EraserState(
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

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EraserStateCopyWith<_EraserState> get copyWith =>
      __$EraserStateCopyWithImpl<_EraserState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EraserState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            const DeepCollectionEquality().equals(other._trail, _trail) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mode, const DeepCollectionEquality().hash(_trail), isActive);

  @override
  String toString() {
    return 'EraserState(mode: $mode, trail: $trail, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$EraserStateCopyWith<$Res>
    implements $EraserStateCopyWith<$Res> {
  factory _$EraserStateCopyWith(
          _EraserState value, $Res Function(_EraserState) _then) =
      __$EraserStateCopyWithImpl;
  @override
  @useResult
  $Res call({EraserMode mode, List<Offset> trail, bool isActive});
}

/// @nodoc
class __$EraserStateCopyWithImpl<$Res> implements _$EraserStateCopyWith<$Res> {
  __$EraserStateCopyWithImpl(this._self, this._then);

  final _EraserState _self;
  final $Res Function(_EraserState) _then;

  /// Create a copy of EraserState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mode = null,
    Object? trail = null,
    Object? isActive = null,
  }) {
    return _then(_EraserState(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as EraserMode,
      trail: null == trail
          ? _self._trail
          : trail // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$SnapState {
  SnapMode get mode;
  double get angleStep;
  List<SnapGuide> get guides;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SnapStateCopyWith<SnapState> get copyWith =>
      _$SnapStateCopyWithImpl<SnapState>(this as SnapState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SnapState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.angleStep, angleStep) ||
                other.angleStep == angleStep) &&
            const DeepCollectionEquality().equals(other.guides, guides));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, angleStep,
      const DeepCollectionEquality().hash(guides));

  @override
  String toString() {
    return 'SnapState(mode: $mode, angleStep: $angleStep, guides: $guides)';
  }
}

/// @nodoc
abstract mixin class $SnapStateCopyWith<$Res> {
  factory $SnapStateCopyWith(SnapState value, $Res Function(SnapState) _then) =
      _$SnapStateCopyWithImpl;
  @useResult
  $Res call({SnapMode mode, double angleStep, List<SnapGuide> guides});
}

/// @nodoc
class _$SnapStateCopyWithImpl<$Res> implements $SnapStateCopyWith<$Res> {
  _$SnapStateCopyWithImpl(this._self, this._then);

  final SnapState _self;
  final $Res Function(SnapState) _then;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? angleStep = null,
    Object? guides = null,
  }) {
    return _then(_self.copyWith(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SnapMode,
      angleStep: null == angleStep
          ? _self.angleStep
          : angleStep // ignore: cast_nullable_to_non_nullable
              as double,
      guides: null == guides
          ? _self.guides
          : guides // ignore: cast_nullable_to_non_nullable
              as List<SnapGuide>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SnapState].
extension SnapStatePatterns on SnapState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SnapState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SnapState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SnapState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SnapState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SnapState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SnapState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(SnapMode mode, double angleStep, List<SnapGuide> guides)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SnapState() when $default != null:
        return $default(_that.mode, _that.angleStep, _that.guides);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(SnapMode mode, double angleStep, List<SnapGuide> guides)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SnapState():
        return $default(_that.mode, _that.angleStep, _that.guides);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(SnapMode mode, double angleStep, List<SnapGuide> guides)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SnapState() when $default != null:
        return $default(_that.mode, _that.angleStep, _that.guides);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SnapState extends SnapState {
  const _SnapState(
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

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SnapStateCopyWith<_SnapState> get copyWith =>
      __$SnapStateCopyWithImpl<_SnapState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SnapState &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.angleStep, angleStep) ||
                other.angleStep == angleStep) &&
            const DeepCollectionEquality().equals(other._guides, _guides));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, angleStep,
      const DeepCollectionEquality().hash(_guides));

  @override
  String toString() {
    return 'SnapState(mode: $mode, angleStep: $angleStep, guides: $guides)';
  }
}

/// @nodoc
abstract mixin class _$SnapStateCopyWith<$Res>
    implements $SnapStateCopyWith<$Res> {
  factory _$SnapStateCopyWith(
          _SnapState value, $Res Function(_SnapState) _then) =
      __$SnapStateCopyWithImpl;
  @override
  @useResult
  $Res call({SnapMode mode, double angleStep, List<SnapGuide> guides});
}

/// @nodoc
class __$SnapStateCopyWithImpl<$Res> implements _$SnapStateCopyWith<$Res> {
  __$SnapStateCopyWithImpl(this._self, this._then);

  final _SnapState _self;
  final $Res Function(_SnapState) _then;

  /// Create a copy of SnapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mode = null,
    Object? angleStep = null,
    Object? guides = null,
  }) {
    return _then(_SnapState(
      mode: null == mode
          ? _self.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SnapMode,
      angleStep: null == angleStep
          ? _self.angleStep
          : angleStep // ignore: cast_nullable_to_non_nullable
              as double,
      guides: null == guides
          ? _self._guides
          : guides // ignore: cast_nullable_to_non_nullable
              as List<SnapGuide>,
    ));
  }
}

/// @nodoc
mixin _$TextEditingState {
  String? get editingTextId;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextEditingStateCopyWith<TextEditingState> get copyWith =>
      _$TextEditingStateCopyWithImpl<TextEditingState>(
          this as TextEditingState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextEditingState &&
            (identical(other.editingTextId, editingTextId) ||
                other.editingTextId == editingTextId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, editingTextId);

  @override
  String toString() {
    return 'TextEditingState(editingTextId: $editingTextId)';
  }
}

/// @nodoc
abstract mixin class $TextEditingStateCopyWith<$Res> {
  factory $TextEditingStateCopyWith(
          TextEditingState value, $Res Function(TextEditingState) _then) =
      _$TextEditingStateCopyWithImpl;
  @useResult
  $Res call({String? editingTextId});
}

/// @nodoc
class _$TextEditingStateCopyWithImpl<$Res>
    implements $TextEditingStateCopyWith<$Res> {
  _$TextEditingStateCopyWithImpl(this._self, this._then);

  final TextEditingState _self;
  final $Res Function(TextEditingState) _then;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editingTextId = freezed,
  }) {
    return _then(_self.copyWith(
      editingTextId: freezed == editingTextId
          ? _self.editingTextId
          : editingTextId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TextEditingState].
extension TextEditingStatePatterns on TextEditingState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TextEditingState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextEditingState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TextEditingState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextEditingState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TextEditingState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextEditingState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? editingTextId)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TextEditingState() when $default != null:
        return $default(_that.editingTextId);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? editingTextId) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextEditingState():
        return $default(_that.editingTextId);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? editingTextId)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TextEditingState() when $default != null:
        return $default(_that.editingTextId);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TextEditingState implements TextEditingState {
  const _TextEditingState({this.editingTextId});

  @override
  final String? editingTextId;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TextEditingStateCopyWith<_TextEditingState> get copyWith =>
      __$TextEditingStateCopyWithImpl<_TextEditingState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TextEditingState &&
            (identical(other.editingTextId, editingTextId) ||
                other.editingTextId == editingTextId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, editingTextId);

  @override
  String toString() {
    return 'TextEditingState(editingTextId: $editingTextId)';
  }
}

/// @nodoc
abstract mixin class _$TextEditingStateCopyWith<$Res>
    implements $TextEditingStateCopyWith<$Res> {
  factory _$TextEditingStateCopyWith(
          _TextEditingState value, $Res Function(_TextEditingState) _then) =
      __$TextEditingStateCopyWithImpl;
  @override
  @useResult
  $Res call({String? editingTextId});
}

/// @nodoc
class __$TextEditingStateCopyWithImpl<$Res>
    implements _$TextEditingStateCopyWith<$Res> {
  __$TextEditingStateCopyWithImpl(this._self, this._then);

  final _TextEditingState _self;
  final $Res Function(_TextEditingState) _then;

  /// Create a copy of TextEditingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? editingTextId = freezed,
  }) {
    return _then(_TextEditingState(
      editingTextId: freezed == editingTextId
          ? _self.editingTextId
          : editingTextId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$InteractionState {
  CanvasElementType get selectedTool;
  Set<String> get selectedElementIds;
  bool get isDrawing;
  String? get activeElementId;
  Offset? get gestureStartPosition;
  ElementStyle get currentStyle;
  String? get hoveredElementId;
  CanvasElement? get activeDrawingElement;
  EraserState get eraser;
  SnapState get snap;
  TextEditingState get textEditing;

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InteractionStateCopyWith<InteractionState> get copyWith =>
      _$InteractionStateCopyWithImpl<InteractionState>(
          this as InteractionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InteractionState &&
            (identical(other.selectedTool, selectedTool) ||
                other.selectedTool == selectedTool) &&
            const DeepCollectionEquality()
                .equals(other.selectedElementIds, selectedElementIds) &&
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
      const DeepCollectionEquality().hash(selectedElementIds),
      isDrawing,
      activeElementId,
      gestureStartPosition,
      currentStyle,
      hoveredElementId,
      activeDrawingElement,
      eraser,
      snap,
      textEditing);

  @override
  String toString() {
    return 'InteractionState(selectedTool: $selectedTool, selectedElementIds: $selectedElementIds, isDrawing: $isDrawing, activeElementId: $activeElementId, gestureStartPosition: $gestureStartPosition, currentStyle: $currentStyle, hoveredElementId: $hoveredElementId, activeDrawingElement: $activeDrawingElement, eraser: $eraser, snap: $snap, textEditing: $textEditing)';
  }
}

/// @nodoc
abstract mixin class $InteractionStateCopyWith<$Res> {
  factory $InteractionStateCopyWith(
          InteractionState value, $Res Function(InteractionState) _then) =
      _$InteractionStateCopyWithImpl;
  @useResult
  $Res call(
      {CanvasElementType selectedTool,
      Set<String> selectedElementIds,
      bool isDrawing,
      String? activeElementId,
      Offset? gestureStartPosition,
      ElementStyle currentStyle,
      String? hoveredElementId,
      CanvasElement? activeDrawingElement,
      EraserState eraser,
      SnapState snap,
      TextEditingState textEditing});

  $CanvasElementCopyWith<$Res>? get activeDrawingElement;
  $EraserStateCopyWith<$Res> get eraser;
  $SnapStateCopyWith<$Res> get snap;
  $TextEditingStateCopyWith<$Res> get textEditing;
}

/// @nodoc
class _$InteractionStateCopyWithImpl<$Res>
    implements $InteractionStateCopyWith<$Res> {
  _$InteractionStateCopyWithImpl(this._self, this._then);

  final InteractionState _self;
  final $Res Function(InteractionState) _then;

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
    return _then(_self.copyWith(
      selectedTool: null == selectedTool
          ? _self.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      selectedElementIds: null == selectedElementIds
          ? _self.selectedElementIds
          : selectedElementIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isDrawing: null == isDrawing
          ? _self.isDrawing
          : isDrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeElementId: freezed == activeElementId
          ? _self.activeElementId
          : activeElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      gestureStartPosition: freezed == gestureStartPosition
          ? _self.gestureStartPosition
          : gestureStartPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      currentStyle: null == currentStyle
          ? _self.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as ElementStyle,
      hoveredElementId: freezed == hoveredElementId
          ? _self.hoveredElementId
          : hoveredElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeDrawingElement: freezed == activeDrawingElement
          ? _self.activeDrawingElement
          : activeDrawingElement // ignore: cast_nullable_to_non_nullable
              as CanvasElement?,
      eraser: null == eraser
          ? _self.eraser
          : eraser // ignore: cast_nullable_to_non_nullable
              as EraserState,
      snap: null == snap
          ? _self.snap
          : snap // ignore: cast_nullable_to_non_nullable
              as SnapState,
      textEditing: null == textEditing
          ? _self.textEditing
          : textEditing // ignore: cast_nullable_to_non_nullable
              as TextEditingState,
    ));
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CanvasElementCopyWith<$Res>? get activeDrawingElement {
    if (_self.activeDrawingElement == null) {
      return null;
    }

    return $CanvasElementCopyWith<$Res>(_self.activeDrawingElement!, (value) {
      return _then(_self.copyWith(activeDrawingElement: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EraserStateCopyWith<$Res> get eraser {
    return $EraserStateCopyWith<$Res>(_self.eraser, (value) {
      return _then(_self.copyWith(eraser: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SnapStateCopyWith<$Res> get snap {
    return $SnapStateCopyWith<$Res>(_self.snap, (value) {
      return _then(_self.copyWith(snap: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextEditingStateCopyWith<$Res> get textEditing {
    return $TextEditingStateCopyWith<$Res>(_self.textEditing, (value) {
      return _then(_self.copyWith(textEditing: value));
    });
  }
}

/// Adds pattern-matching-related methods to [InteractionState].
extension InteractionStatePatterns on InteractionState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_InteractionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InteractionState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_InteractionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InteractionState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_InteractionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InteractionState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            CanvasElementType selectedTool,
            Set<String> selectedElementIds,
            bool isDrawing,
            String? activeElementId,
            Offset? gestureStartPosition,
            ElementStyle currentStyle,
            String? hoveredElementId,
            CanvasElement? activeDrawingElement,
            EraserState eraser,
            SnapState snap,
            TextEditingState textEditing)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InteractionState() when $default != null:
        return $default(
            _that.selectedTool,
            _that.selectedElementIds,
            _that.isDrawing,
            _that.activeElementId,
            _that.gestureStartPosition,
            _that.currentStyle,
            _that.hoveredElementId,
            _that.activeDrawingElement,
            _that.eraser,
            _that.snap,
            _that.textEditing);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            CanvasElementType selectedTool,
            Set<String> selectedElementIds,
            bool isDrawing,
            String? activeElementId,
            Offset? gestureStartPosition,
            ElementStyle currentStyle,
            String? hoveredElementId,
            CanvasElement? activeDrawingElement,
            EraserState eraser,
            SnapState snap,
            TextEditingState textEditing)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InteractionState():
        return $default(
            _that.selectedTool,
            _that.selectedElementIds,
            _that.isDrawing,
            _that.activeElementId,
            _that.gestureStartPosition,
            _that.currentStyle,
            _that.hoveredElementId,
            _that.activeDrawingElement,
            _that.eraser,
            _that.snap,
            _that.textEditing);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            CanvasElementType selectedTool,
            Set<String> selectedElementIds,
            bool isDrawing,
            String? activeElementId,
            Offset? gestureStartPosition,
            ElementStyle currentStyle,
            String? hoveredElementId,
            CanvasElement? activeDrawingElement,
            EraserState eraser,
            SnapState snap,
            TextEditingState textEditing)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InteractionState() when $default != null:
        return $default(
            _that.selectedTool,
            _that.selectedElementIds,
            _that.isDrawing,
            _that.activeElementId,
            _that.gestureStartPosition,
            _that.currentStyle,
            _that.hoveredElementId,
            _that.activeDrawingElement,
            _that.eraser,
            _that.snap,
            _that.textEditing);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InteractionState implements InteractionState {
  const _InteractionState(
      {this.selectedTool = CanvasElementType.rectangle,
      final Set<String> selectedElementIds = const {},
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
  final Set<String> _selectedElementIds;
  @override
  @JsonKey()
  Set<String> get selectedElementIds {
    if (_selectedElementIds is EqualUnmodifiableSetView)
      return _selectedElementIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedElementIds);
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

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InteractionStateCopyWith<_InteractionState> get copyWith =>
      __$InteractionStateCopyWithImpl<_InteractionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InteractionState &&
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

  @override
  String toString() {
    return 'InteractionState(selectedTool: $selectedTool, selectedElementIds: $selectedElementIds, isDrawing: $isDrawing, activeElementId: $activeElementId, gestureStartPosition: $gestureStartPosition, currentStyle: $currentStyle, hoveredElementId: $hoveredElementId, activeDrawingElement: $activeDrawingElement, eraser: $eraser, snap: $snap, textEditing: $textEditing)';
  }
}

/// @nodoc
abstract mixin class _$InteractionStateCopyWith<$Res>
    implements $InteractionStateCopyWith<$Res> {
  factory _$InteractionStateCopyWith(
          _InteractionState value, $Res Function(_InteractionState) _then) =
      __$InteractionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CanvasElementType selectedTool,
      Set<String> selectedElementIds,
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
  $CanvasElementCopyWith<$Res>? get activeDrawingElement;
  @override
  $EraserStateCopyWith<$Res> get eraser;
  @override
  $SnapStateCopyWith<$Res> get snap;
  @override
  $TextEditingStateCopyWith<$Res> get textEditing;
}

/// @nodoc
class __$InteractionStateCopyWithImpl<$Res>
    implements _$InteractionStateCopyWith<$Res> {
  __$InteractionStateCopyWithImpl(this._self, this._then);

  final _InteractionState _self;
  final $Res Function(_InteractionState) _then;

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_InteractionState(
      selectedTool: null == selectedTool
          ? _self.selectedTool
          : selectedTool // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      selectedElementIds: null == selectedElementIds
          ? _self._selectedElementIds
          : selectedElementIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isDrawing: null == isDrawing
          ? _self.isDrawing
          : isDrawing // ignore: cast_nullable_to_non_nullable
              as bool,
      activeElementId: freezed == activeElementId
          ? _self.activeElementId
          : activeElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      gestureStartPosition: freezed == gestureStartPosition
          ? _self.gestureStartPosition
          : gestureStartPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
      currentStyle: null == currentStyle
          ? _self.currentStyle
          : currentStyle // ignore: cast_nullable_to_non_nullable
              as ElementStyle,
      hoveredElementId: freezed == hoveredElementId
          ? _self.hoveredElementId
          : hoveredElementId // ignore: cast_nullable_to_non_nullable
              as String?,
      activeDrawingElement: freezed == activeDrawingElement
          ? _self.activeDrawingElement
          : activeDrawingElement // ignore: cast_nullable_to_non_nullable
              as CanvasElement?,
      eraser: null == eraser
          ? _self.eraser
          : eraser // ignore: cast_nullable_to_non_nullable
              as EraserState,
      snap: null == snap
          ? _self.snap
          : snap // ignore: cast_nullable_to_non_nullable
              as SnapState,
      textEditing: null == textEditing
          ? _self.textEditing
          : textEditing // ignore: cast_nullable_to_non_nullable
              as TextEditingState,
    ));
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CanvasElementCopyWith<$Res>? get activeDrawingElement {
    if (_self.activeDrawingElement == null) {
      return null;
    }

    return $CanvasElementCopyWith<$Res>(_self.activeDrawingElement!, (value) {
      return _then(_self.copyWith(activeDrawingElement: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EraserStateCopyWith<$Res> get eraser {
    return $EraserStateCopyWith<$Res>(_self.eraser, (value) {
      return _then(_self.copyWith(eraser: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SnapStateCopyWith<$Res> get snap {
    return $SnapStateCopyWith<$Res>(_self.snap, (value) {
      return _then(_self.copyWith(snap: value));
    });
  }

  /// Create a copy of InteractionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TextEditingStateCopyWith<$Res> get textEditing {
    return $TextEditingStateCopyWith<$Res>(_self.textEditing, (value) {
      return _then(_self.copyWith(textEditing: value));
    });
  }
}

/// @nodoc
mixin _$CanvasState {
  DrawingDocument get document;
  CanvasTransform get transform;
  InteractionState get interaction;
  bool get isSkeletonMode;
  bool get isFullScreen;
  bool get isToolbarAtTop;
  bool get isZoomMode;
  bool get isDrawWithFingerEnabled;
  bool get hasShownStylusPrompt;
  String? get error;
  Failure? get lastFailure;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CanvasStateCopyWith<CanvasState> get copyWith =>
      _$CanvasStateCopyWithImpl<CanvasState>(this as CanvasState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CanvasState &&
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
            (identical(
                    other.isDrawWithFingerEnabled, isDrawWithFingerEnabled) ||
                other.isDrawWithFingerEnabled == isDrawWithFingerEnabled) &&
            (identical(other.hasShownStylusPrompt, hasShownStylusPrompt) ||
                other.hasShownStylusPrompt == hasShownStylusPrompt) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lastFailure, lastFailure) ||
                other.lastFailure == lastFailure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      lastFailure);

  @override
  String toString() {
    return 'CanvasState(document: $document, transform: $transform, interaction: $interaction, isSkeletonMode: $isSkeletonMode, isFullScreen: $isFullScreen, isToolbarAtTop: $isToolbarAtTop, isZoomMode: $isZoomMode, isDrawWithFingerEnabled: $isDrawWithFingerEnabled, hasShownStylusPrompt: $hasShownStylusPrompt, error: $error, lastFailure: $lastFailure)';
  }
}

/// @nodoc
abstract mixin class $CanvasStateCopyWith<$Res> {
  factory $CanvasStateCopyWith(
          CanvasState value, $Res Function(CanvasState) _then) =
      _$CanvasStateCopyWithImpl;
  @useResult
  $Res call(
      {DrawingDocument document,
      CanvasTransform transform,
      InteractionState interaction,
      bool isSkeletonMode,
      bool isFullScreen,
      bool isToolbarAtTop,
      bool isZoomMode,
      bool isDrawWithFingerEnabled,
      bool hasShownStylusPrompt,
      String? error,
      Failure? lastFailure});

  $CanvasTransformCopyWith<$Res> get transform;
  $InteractionStateCopyWith<$Res> get interaction;
}

/// @nodoc
class _$CanvasStateCopyWithImpl<$Res> implements $CanvasStateCopyWith<$Res> {
  _$CanvasStateCopyWithImpl(this._self, this._then);

  final CanvasState _self;
  final $Res Function(CanvasState) _then;

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
    Object? isDrawWithFingerEnabled = null,
    Object? hasShownStylusPrompt = null,
    Object? error = freezed,
    Object? lastFailure = freezed,
  }) {
    return _then(_self.copyWith(
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as DrawingDocument,
      transform: null == transform
          ? _self.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as CanvasTransform,
      interaction: null == interaction
          ? _self.interaction
          : interaction // ignore: cast_nullable_to_non_nullable
              as InteractionState,
      isSkeletonMode: null == isSkeletonMode
          ? _self.isSkeletonMode
          : isSkeletonMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isFullScreen: null == isFullScreen
          ? _self.isFullScreen
          : isFullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isToolbarAtTop: null == isToolbarAtTop
          ? _self.isToolbarAtTop
          : isToolbarAtTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isZoomMode: null == isZoomMode
          ? _self.isZoomMode
          : isZoomMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrawWithFingerEnabled: null == isDrawWithFingerEnabled
          ? _self.isDrawWithFingerEnabled
          : isDrawWithFingerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShownStylusPrompt: null == hasShownStylusPrompt
          ? _self.hasShownStylusPrompt
          : hasShownStylusPrompt // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFailure: freezed == lastFailure
          ? _self.lastFailure
          : lastFailure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ));
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CanvasTransformCopyWith<$Res> get transform {
    return $CanvasTransformCopyWith<$Res>(_self.transform, (value) {
      return _then(_self.copyWith(transform: value));
    });
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InteractionStateCopyWith<$Res> get interaction {
    return $InteractionStateCopyWith<$Res>(_self.interaction, (value) {
      return _then(_self.copyWith(interaction: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CanvasState].
extension CanvasStatePatterns on CanvasState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CanvasState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CanvasState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CanvasState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CanvasState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            DrawingDocument document,
            CanvasTransform transform,
            InteractionState interaction,
            bool isSkeletonMode,
            bool isFullScreen,
            bool isToolbarAtTop,
            bool isZoomMode,
            bool isDrawWithFingerEnabled,
            bool hasShownStylusPrompt,
            String? error,
            Failure? lastFailure)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CanvasState() when $default != null:
        return $default(
            _that.document,
            _that.transform,
            _that.interaction,
            _that.isSkeletonMode,
            _that.isFullScreen,
            _that.isToolbarAtTop,
            _that.isZoomMode,
            _that.isDrawWithFingerEnabled,
            _that.hasShownStylusPrompt,
            _that.error,
            _that.lastFailure);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            DrawingDocument document,
            CanvasTransform transform,
            InteractionState interaction,
            bool isSkeletonMode,
            bool isFullScreen,
            bool isToolbarAtTop,
            bool isZoomMode,
            bool isDrawWithFingerEnabled,
            bool hasShownStylusPrompt,
            String? error,
            Failure? lastFailure)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasState():
        return $default(
            _that.document,
            _that.transform,
            _that.interaction,
            _that.isSkeletonMode,
            _that.isFullScreen,
            _that.isToolbarAtTop,
            _that.isZoomMode,
            _that.isDrawWithFingerEnabled,
            _that.hasShownStylusPrompt,
            _that.error,
            _that.lastFailure);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            DrawingDocument document,
            CanvasTransform transform,
            InteractionState interaction,
            bool isSkeletonMode,
            bool isFullScreen,
            bool isToolbarAtTop,
            bool isZoomMode,
            bool isDrawWithFingerEnabled,
            bool hasShownStylusPrompt,
            String? error,
            Failure? lastFailure)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CanvasState() when $default != null:
        return $default(
            _that.document,
            _that.transform,
            _that.interaction,
            _that.isSkeletonMode,
            _that.isFullScreen,
            _that.isToolbarAtTop,
            _that.isZoomMode,
            _that.isDrawWithFingerEnabled,
            _that.hasShownStylusPrompt,
            _that.error,
            _that.lastFailure);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CanvasState extends CanvasState {
  const _CanvasState(
      {required this.document,
      this.transform = const CanvasTransform(),
      this.interaction = const InteractionState(),
      this.isSkeletonMode = false,
      this.isFullScreen = false,
      this.isToolbarAtTop = false,
      this.isZoomMode = false,
      this.isDrawWithFingerEnabled = true,
      this.hasShownStylusPrompt = false,
      this.error,
      this.lastFailure})
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
  @JsonKey()
  final bool isDrawWithFingerEnabled;
  @override
  @JsonKey()
  final bool hasShownStylusPrompt;
  @override
  final String? error;
  @override
  final Failure? lastFailure;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CanvasStateCopyWith<_CanvasState> get copyWith =>
      __$CanvasStateCopyWithImpl<_CanvasState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CanvasState &&
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
            (identical(
                    other.isDrawWithFingerEnabled, isDrawWithFingerEnabled) ||
                other.isDrawWithFingerEnabled == isDrawWithFingerEnabled) &&
            (identical(other.hasShownStylusPrompt, hasShownStylusPrompt) ||
                other.hasShownStylusPrompt == hasShownStylusPrompt) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lastFailure, lastFailure) ||
                other.lastFailure == lastFailure));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      lastFailure);

  @override
  String toString() {
    return 'CanvasState(document: $document, transform: $transform, interaction: $interaction, isSkeletonMode: $isSkeletonMode, isFullScreen: $isFullScreen, isToolbarAtTop: $isToolbarAtTop, isZoomMode: $isZoomMode, isDrawWithFingerEnabled: $isDrawWithFingerEnabled, hasShownStylusPrompt: $hasShownStylusPrompt, error: $error, lastFailure: $lastFailure)';
  }
}

/// @nodoc
abstract mixin class _$CanvasStateCopyWith<$Res>
    implements $CanvasStateCopyWith<$Res> {
  factory _$CanvasStateCopyWith(
          _CanvasState value, $Res Function(_CanvasState) _then) =
      __$CanvasStateCopyWithImpl;
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
      bool isDrawWithFingerEnabled,
      bool hasShownStylusPrompt,
      String? error,
      Failure? lastFailure});

  @override
  $CanvasTransformCopyWith<$Res> get transform;
  @override
  $InteractionStateCopyWith<$Res> get interaction;
}

/// @nodoc
class __$CanvasStateCopyWithImpl<$Res> implements _$CanvasStateCopyWith<$Res> {
  __$CanvasStateCopyWithImpl(this._self, this._then);

  final _CanvasState _self;
  final $Res Function(_CanvasState) _then;

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? document = null,
    Object? transform = null,
    Object? interaction = null,
    Object? isSkeletonMode = null,
    Object? isFullScreen = null,
    Object? isToolbarAtTop = null,
    Object? isZoomMode = null,
    Object? isDrawWithFingerEnabled = null,
    Object? hasShownStylusPrompt = null,
    Object? error = freezed,
    Object? lastFailure = freezed,
  }) {
    return _then(_CanvasState(
      document: null == document
          ? _self.document
          : document // ignore: cast_nullable_to_non_nullable
              as DrawingDocument,
      transform: null == transform
          ? _self.transform
          : transform // ignore: cast_nullable_to_non_nullable
              as CanvasTransform,
      interaction: null == interaction
          ? _self.interaction
          : interaction // ignore: cast_nullable_to_non_nullable
              as InteractionState,
      isSkeletonMode: null == isSkeletonMode
          ? _self.isSkeletonMode
          : isSkeletonMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isFullScreen: null == isFullScreen
          ? _self.isFullScreen
          : isFullScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      isToolbarAtTop: null == isToolbarAtTop
          ? _self.isToolbarAtTop
          : isToolbarAtTop // ignore: cast_nullable_to_non_nullable
              as bool,
      isZoomMode: null == isZoomMode
          ? _self.isZoomMode
          : isZoomMode // ignore: cast_nullable_to_non_nullable
              as bool,
      isDrawWithFingerEnabled: null == isDrawWithFingerEnabled
          ? _self.isDrawWithFingerEnabled
          : isDrawWithFingerEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      hasShownStylusPrompt: null == hasShownStylusPrompt
          ? _self.hasShownStylusPrompt
          : hasShownStylusPrompt // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFailure: freezed == lastFailure
          ? _self.lastFailure
          : lastFailure // ignore: cast_nullable_to_non_nullable
              as Failure?,
    ));
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CanvasTransformCopyWith<$Res> get transform {
    return $CanvasTransformCopyWith<$Res>(_self.transform, (value) {
      return _then(_self.copyWith(transform: value));
    });
  }

  /// Create a copy of CanvasState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InteractionStateCopyWith<$Res> get interaction {
    return $InteractionStateCopyWith<$Res>(_self.interaction, (value) {
      return _then(_self.copyWith(interaction: value));
    });
  }
}

// dart format on
