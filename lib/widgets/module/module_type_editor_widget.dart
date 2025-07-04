import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class ModuleTypeEditorWidget extends StatelessWidget {
  const ModuleTypeEditorWidget({required this.vault, super.key});

  final Vault vault;

  @override
  Widget build(BuildContext context) {
    final baseColor = ModuleColor.forRarity(Rarity.rare).base;
    final accentColor = ModuleColor.forRarity(Rarity.rare).accent;
    final selectedBaseColor = ModuleColor.forRarity(Rarity.ancestral).base;
    final selectedAccentColor = ModuleColor.forRarity(Rarity.ancestral).accent;

    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    final editorBloc = vault.get<ModuleEditorStateNotifier>();
    final moduleBloc = vault.get<ModuleStateNotifier>();

    return Material(
      child: Center(
        child: Container(
          width: 320,
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
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
                resolver: vault.get<ModuleEditorStateNotifier>,
                selector: (state) => state.module,
                builder: (context, state, child) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...ModuleType.values.map((module) {
                        return GlowingBorderChipWidget(
                          baseColor:
                              state.module == module
                                  ? selectedBaseColor
                                  : baseColor,
                          accentColor:
                              state.module == module
                                  ? selectedAccentColor
                                  : accentColor,
                          borderRadius: 4,

                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Material(
                              child: InkWell(
                                onTap: () => editorBloc.setModule(module),
                                child: SizedBox(
                                  width: 100,
                                  height: 32,
                                  child: Center(
                                    child: Text(
                                      module.shortName,
                                      style: style?.copyWith(
                                        color:
                                            module == state.module
                                                ? selectedAccentColor
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: editorBloc.hide,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final module = editorBloc.state.module;
                      final rarity = editorBloc.state.rarity;
                      final level = editorBloc.state.level;
                      final valid =
                          module != null && rarity != null && level != null;
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
              ),
              const SizedBox(height: 108),
            ],
          ),
        ),
      ),
    );
  }
}
