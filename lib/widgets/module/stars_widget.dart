import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';

class StarsWidget extends StatelessWidget {
  const StarsWidget({super.key, required this.starCount});

  final int starCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 18),
        for (var i = 0; i < starCount; i++)
          Icon(
            Icons.star,
            size: 18,
            color: ModuleColor.forRarity(Rarity.ancestral).accent,
          ),
      ],
    );
  }
}
