import 'package:tower_modules/model/module_spec.dart';

class ModuleEditorState {
  const ModuleEditorState({
    this.module,
    this.rarity,
    this.level,
    this.visible = false,
  });

  final ModuleType? module;
  final Rarity? rarity;
  final int? level;
  final bool visible;

  ModuleEditorState copyWith({
    ModuleType? module,
    Rarity? rarity,
    int? level,
    bool? visible,
  }) => ModuleEditorState(
    module: module ?? this.module,
    rarity: rarity ?? this.rarity,
    level: level ?? this.level,
    visible: visible ?? this.visible,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleEditorState &&
          runtimeType == other.runtimeType &&
          module == other.module &&
          rarity == other.rarity &&
          level == other.level &&
          visible == other.visible;

  @override
  int get hashCode =>
      module.hashCode ^ rarity.hashCode ^ level.hashCode ^ visible.hashCode;
}
