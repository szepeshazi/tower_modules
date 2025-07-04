import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class RarityChipWidget extends StatelessWidget {
  const RarityChipWidget({super.key, required this.value});

  final EffectState value;

  @override
  Widget build(BuildContext context) {
    final rarity = value.slotValue.rarity;
    final baseColor = ModuleColor.forRarity(rarity).base;
    final accentColor = ModuleColor.forRarity(rarity).accent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      child: GlowingBorderChipWidget(
        borderRadius: 10,
        baseColor: baseColor,
        accentColor: accentColor,
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
