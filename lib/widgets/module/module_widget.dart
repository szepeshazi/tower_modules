import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier_builder.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/state/module_editor_state.dart';
import 'package:tower_modules/state/module_editor_state_notifier.dart';
import 'package:tower_modules/state/module_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/common/overlay_widget.dart';
import 'package:tower_modules/widgets/module/module_icon_widget.dart';
import 'package:tower_modules/widgets/module/module_level_widget.dart';
import 'package:tower_modules/widgets/module/module_name_widget.dart';
import 'package:tower_modules/widgets/module/editor/module_editor_widget.dart';
import 'package:tower_modules/widgets/module/rarity_widget.dart';
import 'package:tower_modules/widgets/module/stars_widget.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final editorBloc = context.get<ModuleEditorStateNotifier>();
    final moduleStateBloc = context.get<ModuleStateNotifier>();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.edit, color: Colors.white, size: 24),
              padding: EdgeInsets.all(4),
              constraints: BoxConstraints(),
              onPressed: () {
                final state = moduleStateBloc.state;
                editorBloc.show(
                  module: state.module,
                  rarity: state.rarity,
                  level: state.level,
                );
              },
            ),
          ),
        ),
        NotifierBuilder<ModuleStateNotifier, ModuleState>(
          builder: (BuildContext context, state, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    ModuleIconWidget(state: state),

                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: ModuleLevelWidget(
                        currentLevel: state.level,
                        maxLevel: state.level,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RarityWidget(rarity: state.rarity),
                    StarsWidget(starCount: state.rarity.stars ?? 0),
                    ModuleNameWidget(module: state.module),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            );
          },
        ),

        NotifierBuilder<ModuleEditorStateNotifier, ModuleEditorState>(
          selector: (state) => state.visible,
          builder: (BuildContext context, state, Widget? child) {
            final module = state.module;
            final rarity = state.rarity;
            final level = state.level;
            final hasValues = module != null && rarity != null && level != null;
            if (!state.visible || !hasValues) {
              return SizedBox.shrink();
            }
            return OverlayWidget(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: ModuleTypeEditorWidget(
                vault: VaultProvider.of(context).vault,
              ),
            );
          },
        ),
      ],
    );
  }
}
