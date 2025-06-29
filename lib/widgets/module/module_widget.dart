

import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/module/module_icon_widget.dart';
import 'package:tower_modules/widgets/module/module_name_widget.dart';
import 'package:tower_modules/widgets/module/rarity_widget.dart';
import 'package:tower_modules/widgets/module/stars_widget.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        NotifierBuilder<ModuleStateNotifier, ModuleState>(
          selector: (m) => m.module.hashCode ^ m.rarity.hashCode,
          builder: (BuildContext context, state, Widget? child) {
            return ModuleIconWidget(state: state);
          },
        ),
        SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotifierBuilder<ModuleStateNotifier, ModuleState>(
              selector: (m) => m.rarity,
              builder: (BuildContext context, state, Widget? child) {
                return RarityWidget(rarity: state.rarity);
              },
            ),
            NotifierBuilder<ModuleStateNotifier, ModuleState>(
              selector: (m) => m.rarity.stars ?? 0,
              builder: (BuildContext context, state, Widget? child) {
                return StarsWidget(starCount: state.rarity.stars ?? 0,);
              },
            ),
            NotifierBuilder<ModuleStateNotifier, ModuleState>(
              selector: (m) => m.module,
              builder: (BuildContext context, state, Widget? child) {
                return ModuleNameWidget(module: state.module);
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ],
    );
  }
}
