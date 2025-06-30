import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/widgets/effects/auto_reroll_widget.dart';
import 'package:tower_modules/widgets/effects/manual_reroll_widget.dart';
import 'package:tower_modules/widgets/effects/reroll_cost_widget.dart';
import 'package:tower_modules/widgets/effects/slot_widget.dart';

class EffectsWidget extends StatelessWidget {
  const EffectsWidget({
    super.key,
    required this.module,
    required this.rarity,
    required this.currentLevel,
    required this.slots,
  });

  final ModuleType module;
  final Rarity rarity;
  final int currentLevel;
  final List<EffectState> slots;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24),
        Text('Effects'),
        SizedBox(height: 2),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < slots.length; i++) ...[
              SlotWidget(value: slots[i], index: i),
              Container(height: 2, color: Colors.black),
            ],
          ],
        ),
        SizedBox(height: 6),
        AutoRerollWidget(),
        RerollCostWidget(),
        ManualRerollWidget(),
      ],
    );
  }
}
