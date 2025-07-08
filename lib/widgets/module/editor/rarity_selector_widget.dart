import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class RaritySelectorWidget extends StatelessWidget {
  const RaritySelectorWidget({
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
      selector: (state) => state.rarity,
      builder: (context, state, child) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...Rarity.values.map((rarity) {
              return _RaritySelectWidget(
                editorBloc: editorBloc,
                rarity: rarity,
                isSelected: state.rarity == rarity,
              );
            }),
          ],
        );
      },
    );
  }
}

class _RaritySelectWidget extends StatelessWidget {
  const _RaritySelectWidget({
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
