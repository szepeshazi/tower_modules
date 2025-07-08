import 'package:flutter/material.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/state/module_state_notifier.dart';

class ModuleEditorActionsWidget extends StatelessWidget {
  const ModuleEditorActionsWidget({
    super.key,
    required this.editorBloc,
    required this.moduleBloc,
  });

  final ModuleEditorStateNotifier editorBloc;
  final ModuleStateNotifier moduleBloc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: editorBloc.hide, child: const Text('Cancel')),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            final module = editorBloc.state.module;
            final rarity = editorBloc.state.rarity;
            final level = editorBloc.state.level;
            final valid = module != null && rarity != null && level != null;
            if (valid) {
              moduleBloc.updateModule(
                module: module,
                rarity: rarity,
                level: level,
              );
            }
            editorBloc.hide();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
