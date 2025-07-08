import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/effects/unlocked_effect_warning_widget.dart';
import 'package:tower_modules/widgets/module/module_widget.dart';

import 'widgets/effects/effects_widget.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            color: Colors.black,
            constraints: BoxConstraints(minWidth: 320, maxWidth: 360),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ModuleWidget(),
                NotifierBuilder<ModuleStateNotifier, ModuleState>(
                  selector: (state) => state.effects,
                  builder: (BuildContext context, state, Widget? child) {
                    return EffectsWidget(slots: state.effects);
                  },
                ),
              ],
            ),
          ),
          NotifierBuilder<ModuleStateNotifier, ModuleState>(
            selector: (state) => state.showWarning,
            builder: (BuildContext context, state, Widget? child) {
              if (!state.showWarning) {
                return SizedBox.shrink();
              }
              final bloc = context.get<ModuleStateNotifier>();
              return UnlockedEffectWarningWidget(bloc: bloc);
            },
          ),
        ],
      ),
    );
  }
}
