import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/widgets/effects/dice_icon_widget.dart';
import 'package:tower_modules/widgets/effects/rarity_chip_widget.dart';

class AutoRerollWidget extends StatelessWidget {
  const AutoRerollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = ModuleColor.forRarity(Rarity.ancestral).base;
    final accentColor = ModuleColor.forRarity(Rarity.ancestral).accent;
    final colorWheel = [
      baseColor.withAlpha(100),
      baseColor,
      Colors.white,
      Colors.white,
      accentColor,
      baseColor,
      baseColor.withAlpha(100),
    ];

    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return Row(
      children: [
        SizedBox(width: 2),
        DiceIconWidget(),
        SizedBox(width: 12),
        CustomPaint(
          painter: GlowingBorderPainter(
            colorWheel: colorWheel,
            borderRadius: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Material(
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                  child: Text('Auto Reroll', style: style),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
