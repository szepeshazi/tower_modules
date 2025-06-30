import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tower_modules/core/notifier.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/state/module_state.dart';

class ModuleStateNotifier extends Notifier<ModuleState> {
  ModuleStateNotifier(super.state) {
    scheduleMicrotask(() {
      final effects = createSlots();
      emit(
        ModuleState(
          module: state.module,
          rarity: state.rarity,
          level: state.level,
          effects: effects,
        ),
      );
    });
  }

  final random = Random();
  var availableSubEffects = <Rarity, List<SlotValue>>{};

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
      subEffectMatrix[state.module] ?? <Rarity, List<SlotValue>>{},
    );
    for (final effect in state.effects) {
      if (effect.locked) {
        _removeFromEffectPool(effect.slotValue);
      }
    }
  }

  int get slotCount =>
      moduleLevels[moduleLevels.keys.lastWhere((k) => k <= state.level)] ??
      moduleLevels.values.first;

  List<EffectState> createSlots() {
    _resetAvailableSubEffects();
    final effects = <EffectState>[];
    final slots = slotCount;

    for (var i = 0; i < slots; i++) {
      final slotValue = rollSingleSlot();
      _removeFromEffectPool(slotValue);
      effects.add(EffectState(slotValue: slotValue, locked: false));
    }
    return effects;
  }

  int get currentRollCost {
    final lockCount  = state.effects.where((e) => e.locked).length;
    return lockCost[lockCount] ?? 10;
  }

  void rollUnlockedSlots() {
    _resetAvailableSubEffects();
    final effects = <EffectState>[];
    for (final effect in state.effects) {
      if (effect.locked) {
        effects.add(effect);
      } else {
        final slotValue = rollSingleSlot();
        _removeFromEffectPool(slotValue);
        effects.add(EffectState(slotValue: slotValue, locked: false));
      }
    }

    emit(
      ModuleState(
        module: state.module,
        rarity: state.rarity,
        level: state.level,
        effects: effects,
        rerollsSpent: state.rerollsSpent + currentRollCost,
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
      final effects = createSlots();
      emit(
        ModuleState(
          module: module,
          rarity: rarity,
          level: level,
          effects: effects,
        ),
      );
    }
  }

  void toggleLock(int index) {
    emit(
      ModuleState(
        module: state.module,
        rarity: state.rarity,
        level: state.level,
        rerollsSpent: state.rerollsSpent,
        effects: [
          for (var i = 0; i < state.effects.length; i++) ...[
            if (i == index)
              EffectState(
                slotValue: state.effects[i].slotValue,
                locked: !state.effects[i].locked,
              ),
            if (i != index) state.effects[i],
          ],
        ],
      ),
    );
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

  static const defaultState = ModuleState(
    module: ModuleType.core,
    rarity: Rarity.ancestral3s,
    level: 250,
    effects: [
      EffectState(
        slotValue: SlotValue(
          effect: SubEffect.dwq,
          rarity: Rarity.ancestral,
          bonus: '3',
        ),
        locked: false,
      ),
    ],
  );
}
