import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToolShapePopup extends ShapeBorder {
  ToolShapePopup({
    this.trianglePosition = TooltipTrianglePosition.left,
    this.borderColor = Colors.black,
  });

  final TooltipTrianglePosition trianglePosition;
  final Color borderColor;
  final BorderSide _side = BorderSide(color: Colors.black, width: 1.0); // Initial value, corrected later
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
      Rect rect, {
        TextDirection? textDirection,
      }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);
    final double triangleHeight = 10.0;
    final double triangleWidth = 20.0;

    double startX;
    if (trianglePosition == TooltipTrianglePosition.center) {
      startX = rrect.width / 2 - triangleWidth / 2;
    } else if (trianglePosition == TooltipTrianglePosition.right) {
      startX = rrect.width - 30.0;
    } else {
      startX = 0;
    }

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(startX, 0);
    path.lineTo(startX + triangleWidth / 2, -triangleHeight);
    path.lineTo(startX + triangleWidth, 0);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _side.width;
    final Path path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
    side: _side.scale(t),
    borderRadius: _borderRadius * t,
  );
}

enum TooltipTrianglePosition {
  left,
  center,
  right,
}
