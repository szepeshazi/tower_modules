import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';

class RarityWidget extends StatelessWidget {
  const RarityWidget({super.key, required this.rarity});

  final Rarity rarity;

  @override
  Widget build(BuildContext context) {
    final moduleColor = ModuleColor.forRarity(rarity);
    final textStyle = TextTheme.of(context).titleLarge ?? TextStyle();
    return Text(
      rarity.name.toUpperCase(),
      style: textStyle.copyWith(color: moduleColor.accent, fontWeight: FontWeight.w900),
    );
  }
}
