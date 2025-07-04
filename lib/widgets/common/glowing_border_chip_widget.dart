import 'package:flutter/material.dart';

class GlowingBorderChipWidget extends StatelessWidget {
  const GlowingBorderChipWidget({
    super.key,
    required this.baseColor,
    required this.accentColor,
    required this.borderRadius,
    required this.child,
  });

  final Color baseColor;
  final Color accentColor;
  final int borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GlowingBorderPainter(
        borderRadius: borderRadius,
        baseColor: baseColor,
        accentColor: accentColor,
      ),
      child: child,
    );
  }
}

class GlowingBorderPainter extends CustomPainter {
  GlowingBorderPainter({
    required this.borderRadius,
    required this.baseColor,
    required this.accentColor,
  });

  final int borderRadius;
  final Color baseColor;
  final Color accentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final colorWheel = [
      baseColor.withAlpha(100),
      baseColor,
      Colors.white,
      Colors.white,
      accentColor,
      baseColor,
      baseColor.withAlpha(100),
    ];
    final double minRadius = borderRadius - colorWheel.length / 2;
    for (int i = 0; i < colorWheel.length; i++) {
      final double inset = i / 2.0;
      final rect = Rect.fromLTWH(
        inset,
        inset,
        size.width - 2 * inset,
        size.height - 2 * inset,
      );
      final rRect = RRect.fromRectAndRadius(
        rect,
        Radius.circular(
          borderRadius -
              (borderRadius - minRadius) * (i / (colorWheel.length - 1)),
        ),
      );
      final paint =
          Paint()
            ..color = colorWheel[i]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1;
      canvas.drawRRect(rRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
