import 'package:tower_modules/model/module_spec.dart';

class EffectState {
  const EffectState({required this.slotValue, required this.locked});

  final SlotValue slotValue;
  final bool locked;
}
