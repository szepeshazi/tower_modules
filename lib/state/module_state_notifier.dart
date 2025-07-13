import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tower_modules/core/notifier.dart';
import 'package:tower_modules/model/autoroll_selection.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/state/module_state.dart';

class ModuleStateNotifier extends Notifier<ModuleState> {
  ModuleStateNotifier() {
    _module = ModuleType.core;
    _rarity = Rarity.ancestral3s;
    _level = 250;
    _effects = createSlots();
    _autoRollSelection = AutoRollSelection(
      rarities: [Rarity.ancestral],
      effects:
          (subEffectMatrix[_module]?[Rarity.ancestral] ?? [])
              .map((sub) => sub.effect)
              .toList(),
    );
    setInitialState(
      ModuleState(
        module: _module,
        rarity: _rarity,
        level: _level,
        effects: _effects,
      ),
    );
  }

  final random = Random();
  var availableSubEffects = <Rarity, List<SlotValue>>{};
  int effectsHash = 0;

  late ModuleType _module;
  late Rarity _rarity;
  late int _level;
  late List<EffectState> _effects = [];
  late AutoRollSelection _autoRollSelection;
  int _autoRollDelayIndex = 0;

  AutoRollSelection get autoRollSelection => _autoRollSelection;

  @override
  void emit(ModuleState newValue) {
    _module = newValue.module;
    _rarity = newValue.rarity;
    _level = newValue.level;
    _effects = newValue.effects;
    super.emit(newValue);
  }

  void _removeFromEffectPool(SlotValue slotValue) {
    for (final rarity in availableSubEffects.keys) {
      final currentEffects = availableSubEffects[rarity];
      if (currentEffects != null) {
        availableSubEffects[rarity] =
            currentEffects.where((e) => e.effect != slotValue.effect).toList();
      }
    }
  }

  void _resetAvailableSubEffects() {
    availableSubEffects = Map.from(
      subEffectMatrix[_module] ?? <Rarity, List<SlotValue>>{},
    );
    for (final effect in _effects) {
      if (effect.locked) {
        _removeFromEffectPool(effect.slotValue);
      }
    }
    final unavailableRarities = Rarity.values.where(
      (r) => r.index > _rarity.index,
    );
    unavailableRarities.forEach(availableSubEffects.remove);
  }

  bool _hasValuableEffect() {
    final unlocked = _effects.firstWhereOrNull(
      (e) => !e.locked && e.slotValue.rarity.index >= Rarity.mythic.index,
    );
    return unlocked != null;
  }

  int get slotCount =>
      moduleLevels[moduleLevels.keys.lastWhere((k) => k <= _level)] ??
      moduleLevels.values.first;

  List<EffectState> createSlots() {
    _effects = <EffectState>[];
    _resetAvailableSubEffects();
    final slots = slotCount;

    for (var i = 0; i < slots; i++) {
      final slotValue = rollSingleSlot();
      _removeFromEffectPool(slotValue);
      _effects.add(EffectState(slotValue: slotValue, locked: false));
    }
    return _effects;
  }

  int get currentRollCost {
    final lockCount = _effects.where((e) => e.locked).length;
    return lockCost[lockCount] ?? 10;
  }

  void skipEffectCheck() {
    effectsHash = _effects.hashCode;
    rollUnlockedSlots();
  }

  void dismissWarningDialog() {
    emit(state.copyWith(showWarning: false));
  }

  void rollUnlockedSlots() {
    if (!state.isAutoRollActive &&
        effectsHash != _effects.hashCode &&
        _hasValuableEffect()) {
      emit(state.copyWith(showWarning: true));
      return;
    }
    effectsHash = 0;
    _resetAvailableSubEffects();
    final newEffects = <EffectState>[];
    for (final effect in _effects) {
      if (effect.locked) {
        newEffects.add(effect);
      } else {
        final slotValue = rollSingleSlot();
        _removeFromEffectPool(slotValue);
        newEffects.add(EffectState(slotValue: slotValue, locked: false));
      }
    }

    _effects = newEffects;
    emit(
      state.copyWith(
        effects: _effects,
        rerollsSpent: state.rerollsSpent + currentRollCost,
        showWarning: false,
      ),
    );
  }

  void updateModule({
    required ModuleType module,
    required Rarity rarity,
    required int level,
  }) {
    if (module != state.module ||
        rarity != state.rarity ||
        level != state.level) {
      _module = module;
      _rarity = rarity;
      _level = level;
      _effects = createSlots();
      _autoRollSelection = AutoRollSelection(
        rarities: [Rarity.ancestral],
        effects:
        (subEffectMatrix[_module]?[Rarity.ancestral] ?? [])
            .map((sub) => sub.effect)
            .toList(),
      );
      emit(
        ModuleState(
          module: _module,
          rarity: _rarity,
          level: _level,
          effects: _effects,
        ),
      );
    }
  }

  void toggleLock(int index) {
    _effects = [
      for (var i = 0; i < _effects.length; i++) ...[
        if (i == index)
          EffectState(
            slotValue: _effects[i].slotValue,
            locked: !_effects[i].locked,
          ),
        if (i != index) _effects[i],
      ],
    ];
    emit(state.copyWith(effects: _effects));
  }

  Future<void> startAutoRoll() async {
    emit(state.copyWith(isAutoRollActive: true));
    while (state.isAutoRollActive) {
      await Future<void>.delayed(_autoRollDelays[_autoRollDelayIndex]);
      if (_autoRollDelayIndex < _autoRollDelays.length - 1) {
        _autoRollDelayIndex++;
      }
      rollUnlockedSlots();
      if (shouldStopAutoRoll()) {
        stopAutoRoll();
      }
    }
  }

  void stopAutoRoll() {
    emit(state.copyWith(isAutoRollActive: false));
  }

  bool shouldStopAutoRoll() {
    final rarityMet = _effects
        .where((e) => !e.locked)
        .map((e) => e.slotValue.rarity)
        .any((r) => _autoRollSelection.rarities.contains(r));
    final effectMet = _effects
        .where((e) => !e.locked)
        .map((e) => e.slotValue.effect)
        .any((se) => _autoRollSelection.effects.contains(se));

    return rarityMet && effectMet;
  }

  SlotValue rollSingleSlot() {
    var effectList = <SlotValue>[];
    while (effectList.isEmpty) {
      final rand = random.nextInt(1000) + 1;
      final rarityRoll =
          RollChance.values.lastWhereOrNull(
            (rc) => rc.runningChance - rc.chance < rand,
          ) ??
          RollChance.values.first;
      effectList = availableSubEffects[rarityRoll.rarity] ?? <SlotValue>[];
    }
    final index = random.nextInt(effectList.length);
    return effectList[index];
  }

  static const _autoRollDelays = [
    Duration(milliseconds: 800),
    Duration(milliseconds: 650),
    Duration(milliseconds: 400),
    Duration(milliseconds: 300),
    Duration(milliseconds: 200),
  ];
}
