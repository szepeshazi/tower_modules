import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';

class RerollCostWidget extends StatelessWidget {
  const RerollCostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: NotifierBuilder<ModuleStateNotifier, ModuleState>(
            selector: (state) => state.rerollsSpent,
            builder: (BuildContext context, state, Widget? child) {
              final bloc = context.get<ModuleStateNotifier>();
              return Text('${state.rerollsSpent}/${bloc.currentRollCost}');
            },
          ),
        ),
      ],
    );
  }
}
