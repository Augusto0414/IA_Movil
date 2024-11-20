import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashedLength;
  final double emptyLength;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashedLength,
    required this.emptyLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;
    double startY = 0;

    // Dibujar la parte superior
    while (startX < size.width) {
      final endX = (startX + dashedLength).clamp(0.0, size.width);
      canvas.drawLine(
        Offset(startX, 0),
        Offset(endX, 0),
        paint,
      );
      startX += dashedLength + emptyLength;
    }

    // Dibujar el lado derecho
    startY = 0;
    while (startY < size.height) {
      final endY = (startY + dashedLength).clamp(0.0, size.height);
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, endY),
        paint,
      );
      startY += dashedLength + emptyLength;
    }

    // Dibujar la parte inferior
    startX = size.width;
    while (startX > 0) {
      final endX = (startX - dashedLength).clamp(0.0, size.width);
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(endX, size.height),
        paint,
      );
      startX -= dashedLength + emptyLength;
    }

    // Dibujar el lado izquierdo
    startY = size.height;
    while (startY > 0) {
      final endY = (startY - dashedLength).clamp(0.0, size.height);
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, endY),
        paint,
      );
      startY -= dashedLength + emptyLength;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
