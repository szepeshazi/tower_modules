import 'package:tower_modules/model/module_spec.dart';

class EffectState {
  const EffectState({required this.slotValue, required this.locked});

  final SlotValue slotValue;
  final bool locked;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EffectState &&
          runtimeType == other.runtimeType &&
          slotValue == other.slotValue &&
          locked == other.locked;

  @override
  int get hashCode => slotValue.hashCode ^ locked.hashCode;
}
