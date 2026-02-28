import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:notexia/src/features/drawing/domain/models/canvas_element.dart';

enum ResizeHandleType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  right,
  bottom,
  left,
}

class ResizeMathUtils {
  static Offset toLocalForElement(Offset worldPoint, CanvasElement element) {
    if (element.angle == 0) return worldPoint;
    final center = element.bounds.center;
    final dx = worldPoint.dx - center.dx;
    final dy = worldPoint.dy - center.dy;
    final cos = math.cos(-element.angle);
    final sin = math.sin(-element.angle);
    return Offset(
      center.dx + dx * cos - dy * sin,
      center.dy + dx * sin + dy * cos,
    );
  }

  static Rect resizeFromHandle(
    ResizeHandleType handle,
    Rect startRect,
    Offset point, {
    required bool keepAspect,
    required double minSize,
  }) {
    if (handle == ResizeHandleType.left ||
        handle == ResizeHandleType.right ||
        handle == ResizeHandleType.top ||
        handle == ResizeHandleType.bottom) {
      return resizeFromEdge(
        handle,
        startRect,
        point,
        keepAspect: keepAspect,
        minSize: minSize,
      );
    }

    Offset fixedCorner;
    switch (handle) {
      case ResizeHandleType.topLeft:
        fixedCorner = startRect.bottomRight;
        break;
      case ResizeHandleType.topRight:
        fixedCorner = startRect.bottomLeft;
        break;
      case ResizeHandleType.bottomLeft:
        fixedCorner = startRect.topRight;
        break;
      case ResizeHandleType.bottomRight:
        fixedCorner = startRect.topLeft;
        break;
      default:
        fixedCorner = startRect.topLeft;
    }

    var left = (handle == ResizeHandleType.topLeft ||
            handle == ResizeHandleType.bottomLeft)
        ? point.dx
        : fixedCorner.dx;
    var right = (handle == ResizeHandleType.topLeft ||
            handle == ResizeHandleType.bottomLeft)
        ? fixedCorner.dx
        : point.dx;
    var top = (handle == ResizeHandleType.topLeft ||
            handle == ResizeHandleType.topRight)
        ? point.dy
        : fixedCorner.dy;
    var bottom = (handle == ResizeHandleType.topLeft ||
            handle == ResizeHandleType.topRight)
        ? fixedCorner.dy
        : point.dy;

    final aspect = startRect.width == 0 || startRect.height == 0
        ? 1.0
        : startRect.width / startRect.height;

    final isLeft = handle == ResizeHandleType.topLeft ||
        handle == ResizeHandleType.bottomLeft;
    final isTop = handle == ResizeHandleType.topLeft ||
        handle == ResizeHandleType.topRight;

    if (keepAspect) {
      final rawWidth = (right - left).abs();
      final rawHeight = (bottom - top).abs();
      if (rawWidth > rawHeight * aspect) {
        final adjustedHeight = rawWidth / aspect;
        if (isTop) {
          top = bottom - adjustedHeight;
        } else {
          bottom = top + adjustedHeight;
        }
      } else {
        final adjustedWidth = rawHeight * aspect;
        if (isLeft) {
          left = right - adjustedWidth;
        } else {
          right = left + adjustedWidth;
        }
      }
    }

    final width = (right - left).abs();
    final height = (bottom - top).abs();
    if (width < minSize) {
      if (isLeft) {
        left = right - minSize;
      } else {
        right = left + minSize;
      }
    }
    if (height < minSize) {
      if (isTop) {
        top = bottom - minSize;
      } else {
        bottom = top + minSize;
      }
    }
    return Rect.fromLTRB(
      math.min(left, right),
      math.min(top, bottom),
      math.max(left, right),
      math.max(top, bottom),
    );
  }

  static Rect resizeFromEdge(
    ResizeHandleType handle,
    Rect startRect,
    Offset point, {
    required bool keepAspect,
    required double minSize,
  }) {
    var left = startRect.left;
    var right = startRect.right;
    var top = startRect.top;
    var bottom = startRect.bottom;

    switch (handle) {
      case ResizeHandleType.left:
        left = point.dx;
        if ((right - left).abs() < minSize) left = right - minSize;
        break;
      case ResizeHandleType.right:
        right = point.dx;
        if ((right - left).abs() < minSize) right = left + minSize;
        break;
      case ResizeHandleType.top:
        top = point.dy;
        if ((bottom - top).abs() < minSize) top = bottom - minSize;
        break;
      case ResizeHandleType.bottom:
        bottom = point.dy;
        if ((bottom - top).abs() < minSize) bottom = top + minSize;
        break;
      default:
        break;
    }

    if (keepAspect) {
      final aspect = startRect.width == 0 || startRect.height == 0
          ? 1.0
          : startRect.width / startRect.height;
      final center = startRect.center;
      if (handle == ResizeHandleType.left || handle == ResizeHandleType.right) {
        final width = (right - left).abs();
        final height = math.max(width / aspect, minSize);
        top = center.dy - height / 2;
        bottom = center.dy + height / 2;
      } else if (handle == ResizeHandleType.top ||
          handle == ResizeHandleType.bottom) {
        final height = (bottom - top).abs();
        final width = math.max(height * aspect, minSize);
        left = center.dx - width / 2;
        right = center.dx + width / 2;
      }
    }

    return Rect.fromLTRB(
      math.min(left, right),
      math.min(top, bottom),
      math.max(left, right),
      math.max(top, bottom),
    );
  }
}
