// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'canvas_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CanvasElement {
  String get id;
  CanvasElementType get type;
  double get x;
  double get y;
  double get width;
  double get height;
  double get angle;
  Color get strokeColor;
  Color? get fillColor;
  double get strokeWidth;
  StrokeStyle get strokeStyle;
  FillType get fillType;
  double get opacity;
  double get roughness;
  int get zIndex;
  bool get isDeleted;
  int get version;
  DateTime get updatedAt;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CanvasElementCopyWith<CanvasElement> get copyWith =>
      _$CanvasElementCopyWithImpl<CanvasElement>(
          this as CanvasElement, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CanvasElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      x,
      y,
      width,
      height,
      angle,
      strokeColor,
      fillColor,
      strokeWidth,
      strokeStyle,
      fillType,
      opacity,
      roughness,
      zIndex,
      isDeleted,
      version,
      updatedAt);

  @override
  String toString() {
    return 'CanvasElement(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CanvasElementCopyWith<$Res> {
  factory $CanvasElementCopyWith(
          CanvasElement value, $Res Function(CanvasElement) _then) =
      _$CanvasElementCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt});
}

/// @nodoc
class _$CanvasElementCopyWithImpl<$Res>
    implements $CanvasElementCopyWith<$Res> {
  _$CanvasElementCopyWithImpl(this._self, this._then);

  final CanvasElement _self;
  final $Res Function(CanvasElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [CanvasElement].
extension CanvasElementPatterns on CanvasElement {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RectangleElement value)? rectangle,
    TResult Function(DiamondElement value)? diamond,
    TResult Function(EllipseElement value)? ellipse,
    TResult Function(LineElement value)? line,
    TResult Function(ArrowElement value)? arrow,
    TResult Function(FreeDrawElement value)? freeDraw,
    TResult Function(TextElement value)? text,
    TResult Function(TriangleElement value)? triangle,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement() when rectangle != null:
        return rectangle(_that);
      case DiamondElement() when diamond != null:
        return diamond(_that);
      case EllipseElement() when ellipse != null:
        return ellipse(_that);
      case LineElement() when line != null:
        return line(_that);
      case ArrowElement() when arrow != null:
        return arrow(_that);
      case FreeDrawElement() when freeDraw != null:
        return freeDraw(_that);
      case TextElement() when text != null:
        return text(_that);
      case TriangleElement() when triangle != null:
        return triangle(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(RectangleElement value) rectangle,
    required TResult Function(DiamondElement value) diamond,
    required TResult Function(EllipseElement value) ellipse,
    required TResult Function(LineElement value) line,
    required TResult Function(ArrowElement value) arrow,
    required TResult Function(FreeDrawElement value) freeDraw,
    required TResult Function(TextElement value) text,
    required TResult Function(TriangleElement value) triangle,
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement():
        return rectangle(_that);
      case DiamondElement():
        return diamond(_that);
      case EllipseElement():
        return ellipse(_that);
      case LineElement():
        return line(_that);
      case ArrowElement():
        return arrow(_that);
      case FreeDrawElement():
        return freeDraw(_that);
      case TextElement():
        return text(_that);
      case TriangleElement():
        return triangle(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RectangleElement value)? rectangle,
    TResult? Function(DiamondElement value)? diamond,
    TResult? Function(EllipseElement value)? ellipse,
    TResult? Function(LineElement value)? line,
    TResult? Function(ArrowElement value)? arrow,
    TResult? Function(FreeDrawElement value)? freeDraw,
    TResult? Function(TextElement value)? text,
    TResult? Function(TriangleElement value)? triangle,
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement() when rectangle != null:
        return rectangle(_that);
      case DiamondElement() when diamond != null:
        return diamond(_that);
      case EllipseElement() when ellipse != null:
        return ellipse(_that);
      case LineElement() when line != null:
        return line(_that);
      case ArrowElement() when arrow != null:
        return arrow(_that);
      case FreeDrawElement() when freeDraw != null:
        return freeDraw(_that);
      case TextElement() when text != null:
        return text(_that);
      case TriangleElement() when triangle != null:
        return triangle(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        rectangle,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        diamond,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        ellipse,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        line,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        arrow,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        freeDraw,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            String text,
            String fontFamily,
            double fontSize,
            TextAlign textAlign,
            Color? backgroundColor,
            double backgroundRadius,
            bool isBold,
            bool isItalic,
            bool isUnderlined,
            bool isStrikethrough)?
        text,
    TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        triangle,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement() when rectangle != null:
        return rectangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case DiamondElement() when diamond != null:
        return diamond(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case EllipseElement() when ellipse != null:
        return ellipse(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case LineElement() when line != null:
        return line(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case ArrowElement() when arrow != null:
        return arrow(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case FreeDrawElement() when freeDraw != null:
        return freeDraw(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case TextElement() when text != null:
        return text(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.text,
            _that.fontFamily,
            _that.fontSize,
            _that.textAlign,
            _that.backgroundColor,
            _that.backgroundRadius,
            _that.isBold,
            _that.isItalic,
            _that.isUnderlined,
            _that.isStrikethrough);
      case TriangleElement() when triangle != null:
        return triangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)
        rectangle,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)
        diamond,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)
        ellipse,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)
        line,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)
        arrow,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)
        freeDraw,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            String text,
            String fontFamily,
            double fontSize,
            TextAlign textAlign,
            Color? backgroundColor,
            double backgroundRadius,
            bool isBold,
            bool isItalic,
            bool isUnderlined,
            bool isStrikethrough)
        text,
    required TResult Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)
        triangle,
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement():
        return rectangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case DiamondElement():
        return diamond(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case EllipseElement():
        return ellipse(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case LineElement():
        return line(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case ArrowElement():
        return arrow(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case FreeDrawElement():
        return freeDraw(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case TextElement():
        return text(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.text,
            _that.fontFamily,
            _that.fontSize,
            _that.textAlign,
            _that.backgroundColor,
            _that.backgroundRadius,
            _that.isBold,
            _that.isItalic,
            _that.isUnderlined,
            _that.isStrikethrough);
      case TriangleElement():
        return triangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        rectangle,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        diamond,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        ellipse,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        line,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        arrow,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            List<Offset> points)?
        freeDraw,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt,
            String text,
            String fontFamily,
            double fontSize,
            TextAlign textAlign,
            Color? backgroundColor,
            double backgroundRadius,
            bool isBold,
            bool isItalic,
            bool isUnderlined,
            bool isStrikethrough)?
        text,
    TResult? Function(
            String id,
            CanvasElementType type,
            double x,
            double y,
            double width,
            double height,
            double angle,
            Color strokeColor,
            Color? fillColor,
            double strokeWidth,
            StrokeStyle strokeStyle,
            FillType fillType,
            double opacity,
            double roughness,
            int zIndex,
            bool isDeleted,
            int version,
            DateTime updatedAt)?
        triangle,
  }) {
    final _that = this;
    switch (_that) {
      case RectangleElement() when rectangle != null:
        return rectangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case DiamondElement() when diamond != null:
        return diamond(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case EllipseElement() when ellipse != null:
        return ellipse(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case LineElement() when line != null:
        return line(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case ArrowElement() when arrow != null:
        return arrow(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case FreeDrawElement() when freeDraw != null:
        return freeDraw(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.points);
      case TextElement() when text != null:
        return text(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt,
            _that.text,
            _that.fontFamily,
            _that.fontSize,
            _that.textAlign,
            _that.backgroundColor,
            _that.backgroundRadius,
            _that.isBold,
            _that.isItalic,
            _that.isUnderlined,
            _that.isStrikethrough);
      case TriangleElement() when triangle != null:
        return triangle(
            _that.id,
            _that.type,
            _that.x,
            _that.y,
            _that.width,
            _that.height,
            _that.angle,
            _that.strokeColor,
            _that.fillColor,
            _that.strokeWidth,
            _that.strokeStyle,
            _that.fillType,
            _that.opacity,
            _that.roughness,
            _that.zIndex,
            _that.isDeleted,
            _that.version,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

@override
class RectangleElement extends CanvasElement {
  const RectangleElement(
      {required this.id,
      this.type = CanvasElementType.rectangle,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RectangleElementCopyWith<RectangleElement> get copyWith =>
      _$RectangleElementCopyWithImpl<RectangleElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RectangleElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      x,
      y,
      width,
      height,
      angle,
      strokeColor,
      fillColor,
      strokeWidth,
      strokeStyle,
      fillType,
      opacity,
      roughness,
      zIndex,
      isDeleted,
      version,
      updatedAt);

  @override
  String toString() {
    return 'CanvasElement.rectangle(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $RectangleElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $RectangleElementCopyWith(
          RectangleElement value, $Res Function(RectangleElement) _then) =
      _$RectangleElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt});
}

/// @nodoc
class _$RectangleElementCopyWithImpl<$Res>
    implements $RectangleElementCopyWith<$Res> {
  _$RectangleElementCopyWithImpl(this._self, this._then);

  final RectangleElement _self;
  final $Res Function(RectangleElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
  }) {
    return _then(RectangleElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class DiamondElement extends CanvasElement {
  const DiamondElement(
      {required this.id,
      this.type = CanvasElementType.diamond,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DiamondElementCopyWith<DiamondElement> get copyWith =>
      _$DiamondElementCopyWithImpl<DiamondElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DiamondElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      x,
      y,
      width,
      height,
      angle,
      strokeColor,
      fillColor,
      strokeWidth,
      strokeStyle,
      fillType,
      opacity,
      roughness,
      zIndex,
      isDeleted,
      version,
      updatedAt);

  @override
  String toString() {
    return 'CanvasElement.diamond(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $DiamondElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $DiamondElementCopyWith(
          DiamondElement value, $Res Function(DiamondElement) _then) =
      _$DiamondElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt});
}

/// @nodoc
class _$DiamondElementCopyWithImpl<$Res>
    implements $DiamondElementCopyWith<$Res> {
  _$DiamondElementCopyWithImpl(this._self, this._then);

  final DiamondElement _self;
  final $Res Function(DiamondElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
  }) {
    return _then(DiamondElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class EllipseElement extends CanvasElement {
  const EllipseElement(
      {required this.id,
      this.type = CanvasElementType.ellipse,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EllipseElementCopyWith<EllipseElement> get copyWith =>
      _$EllipseElementCopyWithImpl<EllipseElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EllipseElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      x,
      y,
      width,
      height,
      angle,
      strokeColor,
      fillColor,
      strokeWidth,
      strokeStyle,
      fillType,
      opacity,
      roughness,
      zIndex,
      isDeleted,
      version,
      updatedAt);

  @override
  String toString() {
    return 'CanvasElement.ellipse(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $EllipseElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $EllipseElementCopyWith(
          EllipseElement value, $Res Function(EllipseElement) _then) =
      _$EllipseElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt});
}

/// @nodoc
class _$EllipseElementCopyWithImpl<$Res>
    implements $EllipseElementCopyWith<$Res> {
  _$EllipseElementCopyWithImpl(this._self, this._then);

  final EllipseElement _self;
  final $Res Function(EllipseElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
  }) {
    return _then(EllipseElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class LineElement extends CanvasElement {
  const LineElement(
      {required this.id,
      this.type = CanvasElementType.line,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt,
      required final List<Offset> points})
      : _points = points,
        super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> _points;
  List<Offset> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LineElementCopyWith<LineElement> get copyWith =>
      _$LineElementCopyWithImpl<LineElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LineElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        const DeepCollectionEquality().hash(_points)
      ]);

  @override
  String toString() {
    return 'CanvasElement.line(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt, points: $points)';
  }
}

/// @nodoc
abstract mixin class $LineElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $LineElementCopyWith(
          LineElement value, $Res Function(LineElement) _then) =
      _$LineElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt,
      List<Offset> points});
}

/// @nodoc
class _$LineElementCopyWithImpl<$Res> implements $LineElementCopyWith<$Res> {
  _$LineElementCopyWithImpl(this._self, this._then);

  final LineElement _self;
  final $Res Function(LineElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? points = null,
  }) {
    return _then(LineElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ));
  }
}

/// @nodoc

class ArrowElement extends CanvasElement {
  const ArrowElement(
      {required this.id,
      this.type = CanvasElementType.arrow,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt,
      required final List<Offset> points})
      : _points = points,
        super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> _points;
  List<Offset> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ArrowElementCopyWith<ArrowElement> get copyWith =>
      _$ArrowElementCopyWithImpl<ArrowElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ArrowElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        const DeepCollectionEquality().hash(_points)
      ]);

  @override
  String toString() {
    return 'CanvasElement.arrow(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt, points: $points)';
  }
}

/// @nodoc
abstract mixin class $ArrowElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $ArrowElementCopyWith(
          ArrowElement value, $Res Function(ArrowElement) _then) =
      _$ArrowElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt,
      List<Offset> points});
}

/// @nodoc
class _$ArrowElementCopyWithImpl<$Res> implements $ArrowElementCopyWith<$Res> {
  _$ArrowElementCopyWithImpl(this._self, this._then);

  final ArrowElement _self;
  final $Res Function(ArrowElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? points = null,
  }) {
    return _then(ArrowElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ));
  }
}

/// @nodoc

class FreeDrawElement extends CanvasElement {
  const FreeDrawElement(
      {required this.id,
      this.type = CanvasElementType.freeDraw,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt,
      required final List<Offset> points})
      : _points = points,
        super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;
  final List<Offset> _points;
  List<Offset> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FreeDrawElementCopyWith<FreeDrawElement> get copyWith =>
      _$FreeDrawElementCopyWithImpl<FreeDrawElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FreeDrawElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        const DeepCollectionEquality().hash(_points)
      ]);

  @override
  String toString() {
    return 'CanvasElement.freeDraw(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt, points: $points)';
  }
}

/// @nodoc
abstract mixin class $FreeDrawElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $FreeDrawElementCopyWith(
          FreeDrawElement value, $Res Function(FreeDrawElement) _then) =
      _$FreeDrawElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt,
      List<Offset> points});
}

/// @nodoc
class _$FreeDrawElementCopyWithImpl<$Res>
    implements $FreeDrawElementCopyWith<$Res> {
  _$FreeDrawElementCopyWithImpl(this._self, this._then);

  final FreeDrawElement _self;
  final $Res Function(FreeDrawElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? points = null,
  }) {
    return _then(FreeDrawElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Offset>,
    ));
  }
}

/// @nodoc

class TextElement extends CanvasElement {
  const TextElement(
      {required this.id,
      this.type = CanvasElementType.text,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt,
      required this.text,
      this.fontFamily = 'Virgil',
      this.fontSize = 20,
      this.textAlign = TextAlign.left,
      this.backgroundColor,
      this.backgroundRadius = 4.0,
      this.isBold = false,
      this.isItalic = false,
      this.isUnderlined = false,
      this.isStrikethrough = false})
      : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;
  final String text;
  @JsonKey()
  final String fontFamily;
  @JsonKey()
  final double fontSize;
  @JsonKey()
  final TextAlign textAlign;
  final Color? backgroundColor;
  @JsonKey()
  final double backgroundRadius;
  @JsonKey()
  final bool isBold;
  @JsonKey()
  final bool isItalic;
  @JsonKey()
  final bool isUnderlined;
  @JsonKey()
  final bool isStrikethrough;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TextElementCopyWith<TextElement> get copyWith =>
      _$TextElementCopyWithImpl<TextElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TextElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.textAlign, textAlign) ||
                other.textAlign == textAlign) &&
            (identical(other.backgroundColor, backgroundColor) ||
                other.backgroundColor == backgroundColor) &&
            (identical(other.backgroundRadius, backgroundRadius) ||
                other.backgroundRadius == backgroundRadius) &&
            (identical(other.isBold, isBold) || other.isBold == isBold) &&
            (identical(other.isItalic, isItalic) ||
                other.isItalic == isItalic) &&
            (identical(other.isUnderlined, isUnderlined) ||
                other.isUnderlined == isUnderlined) &&
            (identical(other.isStrikethrough, isStrikethrough) ||
                other.isStrikethrough == isStrikethrough));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        x,
        y,
        width,
        height,
        angle,
        strokeColor,
        fillColor,
        strokeWidth,
        strokeStyle,
        fillType,
        opacity,
        roughness,
        zIndex,
        isDeleted,
        version,
        updatedAt,
        text,
        fontFamily,
        fontSize,
        textAlign,
        backgroundColor,
        backgroundRadius,
        isBold,
        isItalic,
        isUnderlined,
        isStrikethrough
      ]);

  @override
  String toString() {
    return 'CanvasElement.text(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt, text: $text, fontFamily: $fontFamily, fontSize: $fontSize, textAlign: $textAlign, backgroundColor: $backgroundColor, backgroundRadius: $backgroundRadius, isBold: $isBold, isItalic: $isItalic, isUnderlined: $isUnderlined, isStrikethrough: $isStrikethrough)';
  }
}

/// @nodoc
abstract mixin class $TextElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $TextElementCopyWith(
          TextElement value, $Res Function(TextElement) _then) =
      _$TextElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt,
      String text,
      String fontFamily,
      double fontSize,
      TextAlign textAlign,
      Color? backgroundColor,
      double backgroundRadius,
      bool isBold,
      bool isItalic,
      bool isUnderlined,
      bool isStrikethrough});
}

/// @nodoc
class _$TextElementCopyWithImpl<$Res> implements $TextElementCopyWith<$Res> {
  _$TextElementCopyWithImpl(this._self, this._then);

  final TextElement _self;
  final $Res Function(TextElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
    Object? text = null,
    Object? fontFamily = null,
    Object? fontSize = null,
    Object? textAlign = null,
    Object? backgroundColor = freezed,
    Object? backgroundRadius = null,
    Object? isBold = null,
    Object? isItalic = null,
    Object? isUnderlined = null,
    Object? isStrikethrough = null,
  }) {
    return _then(TextElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: null == fontFamily
          ? _self.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _self.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      textAlign: null == textAlign
          ? _self.textAlign
          : textAlign // ignore: cast_nullable_to_non_nullable
              as TextAlign,
      backgroundColor: freezed == backgroundColor
          ? _self.backgroundColor
          : backgroundColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      backgroundRadius: null == backgroundRadius
          ? _self.backgroundRadius
          : backgroundRadius // ignore: cast_nullable_to_non_nullable
              as double,
      isBold: null == isBold
          ? _self.isBold
          : isBold // ignore: cast_nullable_to_non_nullable
              as bool,
      isItalic: null == isItalic
          ? _self.isItalic
          : isItalic // ignore: cast_nullable_to_non_nullable
              as bool,
      isUnderlined: null == isUnderlined
          ? _self.isUnderlined
          : isUnderlined // ignore: cast_nullable_to_non_nullable
              as bool,
      isStrikethrough: null == isStrikethrough
          ? _self.isStrikethrough
          : isStrikethrough // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class TriangleElement extends CanvasElement {
  const TriangleElement(
      {required this.id,
      this.type = CanvasElementType.triangle,
      required this.x,
      required this.y,
      required this.width,
      required this.height,
      this.angle = 0,
      required this.strokeColor,
      this.fillColor,
      this.strokeWidth = 2.0,
      this.strokeStyle = StrokeStyle.solid,
      this.fillType = FillType.transparent,
      this.opacity = 1.0,
      this.roughness = 0.0,
      this.zIndex = 0,
      this.isDeleted = false,
      this.version = 1,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  @JsonKey()
  final CanvasElementType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double width;
  @override
  final double height;
  @override
  @JsonKey()
  final double angle;
  @override
  final Color strokeColor;
  @override
  final Color? fillColor;
  @override
  @JsonKey()
  final double strokeWidth;
  @override
  @JsonKey()
  final StrokeStyle strokeStyle;
  @override
  @JsonKey()
  final FillType fillType;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double roughness;
  @override
  @JsonKey()
  final int zIndex;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey()
  final int version;
  @override
  final DateTime updatedAt;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TriangleElementCopyWith<TriangleElement> get copyWith =>
      _$TriangleElementCopyWithImpl<TriangleElement>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TriangleElement &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.angle, angle) || other.angle == angle) &&
            (identical(other.strokeColor, strokeColor) ||
                other.strokeColor == strokeColor) &&
            (identical(other.fillColor, fillColor) ||
                other.fillColor == fillColor) &&
            (identical(other.strokeWidth, strokeWidth) ||
                other.strokeWidth == strokeWidth) &&
            (identical(other.strokeStyle, strokeStyle) ||
                other.strokeStyle == strokeStyle) &&
            (identical(other.fillType, fillType) ||
                other.fillType == fillType) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.roughness, roughness) ||
                other.roughness == roughness) &&
            (identical(other.zIndex, zIndex) || other.zIndex == zIndex) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      x,
      y,
      width,
      height,
      angle,
      strokeColor,
      fillColor,
      strokeWidth,
      strokeStyle,
      fillType,
      opacity,
      roughness,
      zIndex,
      isDeleted,
      version,
      updatedAt);

  @override
  String toString() {
    return 'CanvasElement.triangle(id: $id, type: $type, x: $x, y: $y, width: $width, height: $height, angle: $angle, strokeColor: $strokeColor, fillColor: $fillColor, strokeWidth: $strokeWidth, strokeStyle: $strokeStyle, fillType: $fillType, opacity: $opacity, roughness: $roughness, zIndex: $zIndex, isDeleted: $isDeleted, version: $version, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $TriangleElementCopyWith<$Res>
    implements $CanvasElementCopyWith<$Res> {
  factory $TriangleElementCopyWith(
          TriangleElement value, $Res Function(TriangleElement) _then) =
      _$TriangleElementCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      CanvasElementType type,
      double x,
      double y,
      double width,
      double height,
      double angle,
      Color strokeColor,
      Color? fillColor,
      double strokeWidth,
      StrokeStyle strokeStyle,
      FillType fillType,
      double opacity,
      double roughness,
      int zIndex,
      bool isDeleted,
      int version,
      DateTime updatedAt});
}

/// @nodoc
class _$TriangleElementCopyWithImpl<$Res>
    implements $TriangleElementCopyWith<$Res> {
  _$TriangleElementCopyWithImpl(this._self, this._then);

  final TriangleElement _self;
  final $Res Function(TriangleElement) _then;

  /// Create a copy of CanvasElement
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
    Object? angle = null,
    Object? strokeColor = null,
    Object? fillColor = freezed,
    Object? strokeWidth = null,
    Object? strokeStyle = null,
    Object? fillType = null,
    Object? opacity = null,
    Object? roughness = null,
    Object? zIndex = null,
    Object? isDeleted = null,
    Object? version = null,
    Object? updatedAt = null,
  }) {
    return _then(TriangleElement(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as CanvasElementType,
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      angle: null == angle
          ? _self.angle
          : angle // ignore: cast_nullable_to_non_nullable
              as double,
      strokeColor: null == strokeColor
          ? _self.strokeColor
          : strokeColor // ignore: cast_nullable_to_non_nullable
              as Color,
      fillColor: freezed == fillColor
          ? _self.fillColor
          : fillColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      strokeWidth: null == strokeWidth
          ? _self.strokeWidth
          : strokeWidth // ignore: cast_nullable_to_non_nullable
              as double,
      strokeStyle: null == strokeStyle
          ? _self.strokeStyle
          : strokeStyle // ignore: cast_nullable_to_non_nullable
              as StrokeStyle,
      fillType: null == fillType
          ? _self.fillType
          : fillType // ignore: cast_nullable_to_non_nullable
              as FillType,
      opacity: null == opacity
          ? _self.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      roughness: null == roughness
          ? _self.roughness
          : roughness // ignore: cast_nullable_to_non_nullable
              as double,
      zIndex: null == zIndex
          ? _self.zIndex
          : zIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _self.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
