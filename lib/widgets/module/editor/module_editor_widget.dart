import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/module/editor/level_selector_widget.dart';
import 'package:tower_modules/widgets/module/editor/module_editor_actions_widget.dart';
import 'package:tower_modules/widgets/module/editor/module_type_selector_widget.dart';

import 'rarity_selector_widget.dart';

class ModuleTypeEditorWidget extends StatelessWidget {
  const ModuleTypeEditorWidget({required this.vault, super.key});

  final Vault vault;

  @override
  Widget build(BuildContext context) {
    final editorBloc = vault.get<ModuleEditorStateNotifier>();
    final moduleBloc = vault.get<ModuleStateNotifier>();

    return Material(
      child: Center(
        child: Container(
          width: 540,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Configure your module',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              ModuleTypeSelectorWidget(vault: vault, editorBloc: editorBloc),
              const SizedBox(height: 32),
              Text('Rarity', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 16),
              RaritySelectorWidget(vault: vault, editorBloc: editorBloc),
              const SizedBox(height: 32),
              NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
                resolver: vault.get<ModuleEditorStateNotifier>,
                selector:
                    (state) => state.level.hashCode ^ state.rarity.hashCode,
                builder: (context, state, child) {
                  return Text(
                    'Level - ${state.level}',
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                },
              ),
              const SizedBox(height: 24),
              LevelSelectorWidget(vault: vault, editorBloc: editorBloc),
              const SizedBox(height: 24),
              ModuleEditorActionsWidget(
                editorBloc: editorBloc,
                moduleBloc: moduleBloc,
              ),
              const SizedBox(height: 108),
            ],
          ),
        ),
      ),
    );
  }
}
