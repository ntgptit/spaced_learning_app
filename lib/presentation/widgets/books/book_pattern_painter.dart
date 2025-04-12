import 'package:flutter/material.dart';

class BookPatternPainter extends CustomPainter {
  final Color patternColor;
  final int lineCount;

  BookPatternPainter({required this.patternColor, this.lineCount = 5});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = patternColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;

    final spacingY = size.height / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final y = spacingY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
