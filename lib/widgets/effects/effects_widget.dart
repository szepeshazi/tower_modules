import 'package:flutter/material.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/effects/auto_reroll_widget.dart';
import 'package:tower_modules/widgets/effects/manual_reroll_widget.dart';
import 'package:tower_modules/widgets/effects/rarity_chip_widget.dart';

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
        SizedBox(height: 6,),
        AutoRerollWidget(),
        ManualRerollWidget(),
      ],
    );
  }
}

class SlotWidget extends StatelessWidget {
  const SlotWidget({super.key, required this.value, required this.index});

  final EffectState value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sign = value.slotValue.negative ? '-' : '+';
    final bloc = VaultProvider.of(context).vault.get<ModuleStateNotifier>();
    final color = ModuleColor.forRarity(value.slotValue.rarity).accent;
    final labelStyle = TextTheme.of(
      context,
    ).labelSmall?.copyWith(fontWeight: FontWeight.w900, color: color);
    return Container(
      color: Color(0xff353264),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Opacity(
            opacity: value.locked ? 0.33 : 1.0,
            child: Row(
              children: [
                SizedBox(width: 2),
                RarityChipWidget(value: value),
                SizedBox(width: 5),
                Text('$sign${value.slotValue.bonus}', style: labelStyle),
                Text(value.slotValue.effect.unit.symbol, style: labelStyle),
                SizedBox(width: 2),
                Text(value.slotValue.effect.name, style: labelStyle),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Opacity(
              opacity: value.locked ? 1.0 : 0.33,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  value.locked ? Icons.lock : Icons.lock_open,
                  size: 20,
                ),
                onPressed: () {
                  bloc.toggleLock(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
