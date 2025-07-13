import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_button_widget.dart';
import 'package:tower_modules/widgets/effects/dice_icon_widget.dart';

class AutoRerollWidget extends StatelessWidget {
  const AutoRerollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = ModuleColor.forRarity(Rarity.ancestral).base;
    final accentColor = ModuleColor.forRarity(Rarity.ancestral).accent;

    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return Row(
      children: [
        SizedBox(width: 2),
        DiceIconWidget(),
        SizedBox(width: 12),
        NotifierBuilder<ModuleStateNotifier, ModuleState>(
          selector: (s) => s.isAutoRollActive,
          builder: (BuildContext context, state, Widget? child) {
            final bloc = context.get<ModuleStateNotifier>();
            final text = state.isAutoRollActive ? 'Stop' : 'Auto Reroll';
            final action = state.isAutoRollActive ? bloc.stopAutoRoll : bloc.startAutoRoll;
            return GlowingBorderButtonWidget(
              baseColor: baseColor,
              accentColor: accentColor,
              borderRadius: 4,
              width: 160,
              onTap: action,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                child: Text(text, style: style),
              ),
            );
          },
        ),
      ],
    );
  }
}
