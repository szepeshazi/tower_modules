import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class ModuleTypeSelectorWidget extends StatelessWidget {
  const ModuleTypeSelectorWidget({
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
      selector: (state) => state.module,
      builder: (context, state, child) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...ModuleType.values.map((module) {
              return _ModuleTypeSelectWidget(
                editorBloc: editorBloc,
                module: module,
                isSelected: state.module == module,
              );
            }),
          ],
        );
      },
    );
  }
}

class _ModuleTypeSelectWidget extends StatelessWidget {
  const _ModuleTypeSelectWidget({
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
