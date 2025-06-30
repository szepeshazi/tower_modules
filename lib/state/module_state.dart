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
  });

  final ModuleType module;
  final Rarity rarity;
  final int level;
  final List<EffectState> effects;
  final int rerollsSpent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleState &&
          runtimeType == other.runtimeType &&
          module == other.module &&
          rarity == other.rarity &&
          level == other.level &&
          listEquality.equals(effects, other.effects);

  @override
  int get hashCode => module.hashCode ^ rarity.hashCode ^ level.hashCode;

  static const listEquality = ListEquality<EffectState>();
}
