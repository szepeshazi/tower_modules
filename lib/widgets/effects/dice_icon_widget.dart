import 'package:flutter/material.dart';
import 'dart:math';

class DiceIconWidget extends StatelessWidget {
  const DiceIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
      child: CustomPaint(
        size: const Size(32, 32),
        painter: _HexagonPainter(),
      ),
    );
  }
}

class _HexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final double w = size.width;
    final double h = size.height;
    final double r = w * 0.38; // radius of hexagon
    final Offset center = Offset(w / 2, h / 2);
    // Calculate hexagon vertices
    final List<Offset> hex = List.generate(6, (i) {
      final angle = (i * 60 - 30) * pi / 180;
      return Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
    });
    // Draw hexagon
    final hexPath = Path()..moveTo(hex[0].dx, hex[0].dy);
    for (int i = 1; i < 6; i++) {
      hexPath.lineTo(hex[i].dx, hex[i].dy);
    }
    hexPath.close();
    canvas.drawPath(hexPath, paint);

    // Connect every second vertex to the center
    for (int i = 0; i < 6; i += 2) {
      canvas.drawLine(center, hex[i], paint);
    }

    // Draw 1 dot in the middle of the first polygon (center, hex[0], hex[1], hex[2])
    final Offset polyCenter = (center + hex[0] + hex[1] + hex[2]) / 4;
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(polyCenter, 1.3, dotPaint);

    // Draw 3 straight-line dots in the middle of the second polygon (center, hex[2], hex[3], hex[4])
    // We'll interpolate between hex[2] and hex[4] for a straight line
    for (int i = 1; i <= 3; i++) {
      final t = i / 4.0;
      final pos = Offset.lerp(hex[2], hex[4], t)! * 0.85 + center * 0.15;
      canvas.drawCircle(pos, 1.3, dotPaint);
    }

    // Draw 4 dots in the middle of the third polygon (center, hex[4], hex[5], hex[0])
    // Arrange them in a square, equidistant from each other and the edges
    final Offset a = center;
    final Offset b = hex[4];
    final Offset c = hex[5];
    final Offset d = hex[0];
    // Find the centroid of the polygon
    final Offset centroid = (a + b + c + d) / 4;
    // Define offsets for a square centered at the centroid
    final double offset = r * 0.18;
    final Offset up = Offset(0, -offset);
    final Offset down = Offset(0, offset);
    final Offset left = Offset(-offset, 0);
    final Offset right = Offset(offset, 0);
    // Rotate the square to align with the polygon orientation, then add 45 degrees (pi/4)
    double angle = atan2((d - b).dy, (d - b).dx) / 2 + pi / 4;
    List<Offset> squareOffsets = [
      up + left,
      up + right,
      down + left,
      down + right,
    ];
    for (final o in squareOffsets) {
      final rotated = Offset(
        o.dx * cos(angle) - o.dy * sin(angle),
        o.dx * sin(angle) + o.dy * cos(angle),
      );
      canvas.drawCircle(centroid + rotated, 1.3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
