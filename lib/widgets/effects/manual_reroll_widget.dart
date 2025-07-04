import 'package:flutter/material.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_button_widget.dart';

class ManualRerollWidget extends StatelessWidget {
  const ManualRerollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = VaultProvider.of(context).vault.get<ModuleStateNotifier>();
    final baseColor = ModuleColor.forRarity(Rarity.rare).base;
    final accentColor = ModuleColor.forRarity(Rarity.rare).accent;

    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return Row(
      children: [
        Spacer(),
        GlowingBorderButtonWidget(
          baseColor: baseColor,
          accentColor: accentColor,
          borderRadius: 4,
          onTap: bloc.rollUnlockedSlots,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 2),
            child: Text('Reroll', style: style),
          ),
        ),
      ],
    );
  }
}
