import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';

class LevelSelectorWidget extends StatelessWidget {
  const LevelSelectorWidget({
    super.key,
    required this.vault,
    required this.editorBloc,
  });

  final Vault vault;
  final ModuleEditorStateNotifier editorBloc;

  @override
  Widget build(BuildContext context) {
    return NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
      resolver: vault.get<ModuleEditorStateNotifier>,
      selector: (state) => state.level.hashCode ^ state.rarity.hashCode,
      builder: (context, state, child) {
        return Center(
          child: _LevelSelectWidget(
            level: state.level ?? 1,
            maxLevel: state.rarity?.maxLevel ?? 20,
            editorBloc: editorBloc,
          ),
        );
      },
    );
  }
}

class _LevelSelectWidget extends StatelessWidget {
  const _LevelSelectWidget({
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
