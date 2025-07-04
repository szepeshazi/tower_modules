import 'package:collection/collection.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';

class ModuleState {
  const ModuleState({
    required this.module,
    required this.rarity,
    required this.level,
    this.effects = const [],
    this.rerollsSpent = 0,
    this.showWarning = false,
  });

  final ModuleType module;
  final Rarity rarity;
  final int level;
  final List<EffectState> effects;
  final int rerollsSpent;
  final bool showWarning;

  ModuleState copyWith({
    ModuleType? module,
    Rarity? rarity,
    int? level,
    List<EffectState>? effects,
    int? rerollsSpent,
    bool? showWarning,
  }) => ModuleState(
    module: module ?? this.module,
    rarity: rarity ?? this.rarity,
    level: level ?? this.level,
    effects: effects ?? this.effects,
    rerollsSpent: rerollsSpent ?? this.rerollsSpent,
    showWarning: showWarning ?? this.showWarning,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleState &&
          runtimeType == other.runtimeType &&
          module == other.module &&
          rarity == other.rarity &&
          level == other.level &&
          effects == other.effects &&
          rerollsSpent == other.rerollsSpent &&
          showWarning == other.showWarning;

  @override
  int get hashCode =>
      module.hashCode ^
      rarity.hashCode ^
      level.hashCode ^
      effects.hashCode ^
      rerollsSpent.hashCode ^
      showWarning.hashCode;

  static const listEquality = ListEquality<EffectState>();
}
