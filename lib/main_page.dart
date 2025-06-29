import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/module/module_level_widget.dart';
import 'package:tower_modules/widgets/module/module_widget.dart';

import 'widgets/effects/effects_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        constraints: BoxConstraints(minWidth: 320, maxWidth: 360),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ModuleWidget(),

            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: NotifierBuilder<ModuleStateNotifier, ModuleState>(
                selector: (state) => state.level,
                builder: (BuildContext context, state, Widget? child) {
                  return ModuleLevelWidget(
                    currentLevel: state.level,
                    maxLevel: state.level,
                  );
                },
              ),
            ),

            NotifierBuilder<ModuleStateNotifier, ModuleState>(
              builder: (BuildContext context, state, Widget? child) {
                return EffectsWidget(
                  module: state.module,
                  rarity: state.rarity,
                  currentLevel: state.level,
                  slots: state.effects,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
