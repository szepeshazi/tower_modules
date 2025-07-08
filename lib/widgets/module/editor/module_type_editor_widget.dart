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
              NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
                resolver: vault.get<ModuleEditorStateNotifier>,
                selector: (state) => state.module,
                builder: (context, state, child) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...ModuleType.values.map((module) {
                        return ModuleTypeSelectWidget(
                          editorBloc: editorBloc,
                          module: module,
                          isSelected: state.module == module,
                        );
                      }),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              Text('Rarity', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 16),

              NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
                resolver: vault.get<ModuleEditorStateNotifier>,
                selector: (state) => state.rarity,
                builder: (context, state, child) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ...Rarity.values.map((rarity) {
                        return RaritySelectWidget(
                          editorBloc: editorBloc,
                          rarity: rarity,
                          isSelected: state.rarity == rarity,
                        );
                      }),
                    ],
                  );
                },
              ),

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

              NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
                resolver: vault.get<ModuleEditorStateNotifier>,
                selector:
                    (state) => state.level.hashCode ^ state.rarity.hashCode,
                builder: (context, state, child) {
                  return Center(
                    child: LevelSelectWidget(
                      level: state.level ?? 1,
                      maxLevel: state.rarity?.maxLevel ?? 20,
                      editorBloc: editorBloc,
                    ),
                  );
                },
              ),

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

class ModuleTypeSelectWidget extends StatelessWidget {
  const ModuleTypeSelectWidget({
    super.key,
    required this.editorBloc,
    required this.module,
    required this.isSelected,
  });

  final ModuleEditorStateNotifier editorBloc;
  final ModuleType module;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final rarity = isSelected ? Rarity.ancestral : Rarity.rare;
    final baseColor = ModuleColor.forRarity(rarity).base;
    final accentColor = ModuleColor.forRarity(rarity).accent;
    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return GlowingBorderChipWidget(
      baseColor: baseColor,
      accentColor: accentColor,
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
                    color: isSelected ? accentColor : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RaritySelectWidget extends StatelessWidget {
  const RaritySelectWidget({
    super.key,
    required this.editorBloc,
    required this.rarity,
    required this.isSelected,
  });

  final ModuleEditorStateNotifier editorBloc;
  final Rarity rarity;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final r = isSelected ? Rarity.ancestral : Rarity.rare;
    final baseColor = ModuleColor.forRarity(r).base;
    final accentColor = ModuleColor.forRarity(r).accent;
    final style = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900);

    return GlowingBorderChipWidget(
      baseColor: baseColor,
      accentColor: accentColor,
      borderRadius: 4,

      child: Padding(
        padding: EdgeInsets.all(4),
        child: Material(
          child: InkWell(
            onTap: () => editorBloc.setRarity(rarity),
            child: SizedBox(
              width: 80,
              height: 32,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      rarity.name,
                      style: style?.copyWith(
                        color: isSelected ? accentColor : Colors.white,
                      ),
                    ),
                    if (rarity.stars != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < (rarity.stars ?? 0); i++)
                            Icon(Icons.star, size: 16, color: accentColor),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelSelectWidget extends StatelessWidget {
  const LevelSelectWidget({
    super.key,
    required this.level,
    required this.maxLevel,
    required this.editorBloc,
  });

  final int level;
  final int maxLevel;
  final ModuleEditorStateNotifier editorBloc;

  @override
  Widget build(BuildContext context) {
    final color = ModuleColor.forRarity(Rarity.ancestral).accent;
    final thumbColor = ModuleColor.forRarity(Rarity.mythic).base;
    final thumbOutlineColor = ModuleColor.forRarity(Rarity.mythic).accent;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            activeTickMarkColor: color,
            thumbColor: thumbColor,
            valueIndicatorColor: thumbColor,
            valueIndicatorStrokeColor: thumbOutlineColor,
          ),
          child: Slider(
            value: level.toDouble(),
            min: 1,
            max: maxLevel.toDouble(),
            divisions: maxLevel,
            label: '$level',
            onChanged: (double value) {
              editorBloc.setLevel(value.toInt());
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(children: [Text('1'), Spacer(), Text('$maxLevel')]),
        ),
      ],
    );
  }
}
