import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/state/effect_state.dart';

class RarityChipWidget extends StatelessWidget {
  const RarityChipWidget({super.key, required this.value});

  final EffectState value;

  @override
  Widget build(BuildContext context) {
    final rarity = value.slotValue.rarity;
    final baseColor = ModuleColor.forRarity(rarity).base;
    final accentColor = ModuleColor.forRarity(rarity).accent;
    final colorWheel = [
      baseColor.withAlpha(100),
      baseColor,
      Colors.white,
      Colors.white,
      accentColor,
      baseColor,
      baseColor.withAlpha(100),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      child: CustomPaint(
        painter: GlowingBorderPainter(colorWheel: colorWheel, borderRadius: 10),
        child: Container(
          decoration: BoxDecoration(
            color: baseColor.withAlpha(40),
            borderRadius: BorderRadius.circular(7),
          ),
          width: 80,
          height: 24,
          child: Center(
            child: Text(
              rarity.name,
              style: TextTheme.of(context).labelSmall?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlowingBorderPainter extends CustomPainter {
  final List<Color> colorWheel;

  GlowingBorderPainter({required this.colorWheel, required this.borderRadius});

  final int borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final double minRadius = borderRadius - colorWheel.length / 2;
    for (int i = 0; i < colorWheel.length; i++) {
      final double inset = i / 2.0;
      final rect = Rect.fromLTWH(
        inset,
        inset,
        size.width - 2 * inset,
        size.height - 2 * inset,
      );
      final rrect = RRect.fromRectAndRadius(
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
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
