import 'dart:math';

import 'package:collection/collection.dart';
import 'package:tower_modules/core/notifier.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/state/module_state.dart';

class ModuleStateNotifier extends Notifier<ModuleState> {
  ModuleStateNotifier(super.state) {
    _initialize();
  }

  final random = Random();
  var availableSubEffects = <Rarity, List<SlotValue>>{};

  void _initialize() {
    rollUnlockedSlots();
  }

  void removeFromAvailable(SlotValue slotValue) {
    for (final rarity in availableSubEffects.keys) {
      final currentEffects = availableSubEffects[rarity];
      if (currentEffects != null) {
        availableSubEffects[rarity] =
            currentEffects.where((e) => e.effect != slotValue.effect).toList();
      }
    }
  }

  void resetAvailableSubEffects() {
    availableSubEffects = Map.from(
      subEffectMatrix[state.module] ?? <Rarity, List<SlotValue>>{},
    );
    for (final effect in state.effects) {
      if (effect.locked) {
        removeFromAvailable(effect.slotValue);
      }
    }
  }

  int get slotCount =>
      moduleLevels[moduleLevels.keys.lastWhere((k) => k <= state.level)] ??
      moduleLevels.values.first;

  void rollUnlockedSlots() {
    resetAvailableSubEffects();
    final effects = <EffectState>[];
    final slots = slotCount;
    for (final effect in state.effects) {
      if (effect.locked) {
        effects.add(effect);
      } else {
        final slotValue = rollSingleSlot();
        removeFromAvailable(slotValue);
        effects.add(EffectState(slotValue: slotValue, locked: false));
      }
    }
    for (var i = effects.length; i < slots; i++) {
      final slotValue = rollSingleSlot();
      removeFromAvailable(slotValue);
      effects.add(EffectState(slotValue: slotValue, locked: false));
    }
    emit(
      ModuleState(
        module: state.module,
        rarity: state.rarity,
        level: state.level,
        effects: effects,
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
      emit(defaultState);
    }
  }

  void toggleLock(int index) {
    emit(
      ModuleState(
        module: state.module,
        rarity: state.rarity,
        level: state.level,
        effects: [
          for (var i = 0; i < state.effects.length; i++)
            EffectState(
              slotValue: state.effects[i].slotValue,
              locked:
                  index == i
                      ? !state.effects[i].locked
                      : state.effects[i].locked,
            ),
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
