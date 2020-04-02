import 'dart:ui';

import 'package:flutter/material.dart';

class CustomBorder extends ShapeBorder {

  final double borderWidth;
  final BorderRadius borderRadius;

  const CustomBorder({
    this.borderWidth: 1.0,
    this.borderRadius: BorderRadius.zero,
  })
      : assert(borderRadius != null);

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(left: borderWidth + 2, top: borderWidth, bottom: borderWidth);
  }

  @override
  ShapeBorder scale(double t) {
    return CustomBorder(
      borderWidth: borderWidth * (t),
      borderRadius: borderRadius * (t),
    );
  }

  @override
  ShapeBorder lerpFrom(ShapeBorder a, double t) {
    assert(t != null);
    if (a is CustomBorder) {
      return CustomBorder(
        borderWidth: lerpDouble(a.borderWidth, borderWidth, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder lerpTo(ShapeBorder b, double t) {
    assert(t != null);
    if (b is CustomBorder) {
      return CustomBorder(
        borderWidth: lerpDouble(borderWidth, b.borderWidth, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  Path getInnerPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..addRRect(borderRadius.resolve(textDirection).toRRect(rect).deflate(
          borderWidth));
  }

  @override
  Path getOuterPath(Rect rect, { TextDirection textDirection }) {
    return Path()
      ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paint(Canvas canvas, Rect rect, { TextDirection textDirection }) {
    rect = rect.deflate(borderWidth / 2.0);
    rect = Rect.fromLTWH(rect.left + 2, rect.top, rect.width , rect.height);
    RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);

    Paint paint;
    paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(borderRect, paint);
  }
}