import 'package:tower_modules/core/notifier.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_editor_state.dart';

class ModuleEditorStateNotifier extends Notifier<ModuleEditorState> {
  ModuleEditorStateNotifier(super.state);

  void hide() {
    emit(state.copyWith(visible: false));
  }

  void show({
    required ModuleType module,
    required Rarity rarity,
    required int level,
  }) {
    emit(
      ModuleEditorState(
        module: module,
        rarity: rarity,
        level: level,
        visible: true,
      ),
    );
  }

  void setModule(ModuleType module) {
    emit(state.copyWith(module: module));
  }

  void setRarity(Rarity rarity) {
    final level = state.level?.clamp(1, rarity.maxLevel);
    emit(state.copyWith(rarity: rarity, level: level));
  }

  void setLevel(int level) {
    emit(state.copyWith(level: level));
  }
}
