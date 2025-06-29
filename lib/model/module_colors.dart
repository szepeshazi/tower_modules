import 'package:flutter/animation.dart';
import 'package:tower_modules/model/module_spec.dart';

class ModuleColor {
  const ModuleColor({required this.base, required this.accent});

  final Color base;
  final Color accent;

  static ModuleColor forRarity(Rarity rarity) {
    return _colorMap[rarity] ?? _default;
  }

  static const _default = ModuleColor(
    accent: Color(0xff98f972),
    base: Color(0xff94f088),
  );
  static const _colorMap = {
    Rarity.common: ModuleColor(
      base: Color(0xffe0d0d0),
      accent: Color(0xffe0d0d0),
    ),
    Rarity.rare: ModuleColor(
      base: Color(0xff68abbe),
      accent: Color(0xff6dd6f3),
    ),
    Rarity.rarePlus: ModuleColor(
      base: Color(0xff68abbe),
      accent: Color(0xff6dd6f3),
    ),
    Rarity.epic: ModuleColor(
      base: Color(0xffe039dd),
      accent: Color(0xfff45bf1),
    ),
    Rarity.epicPlus: ModuleColor(
      base: Color(0xffe039dd),
      accent: Color(0xfff45bf1),
    ),
    Rarity.legendary: ModuleColor(
      base: Color(0xffe98226),
      accent: Color(0xfff49b33),
    ),
    Rarity.legendaryPlus: ModuleColor(
      base: Color(0xffe98226),
      accent: Color(0xfff49b33),
    ),
    Rarity.mythic: ModuleColor(
      base: Color(0xfff65554),
      accent: Color(0xfff9726f),
    ),
    Rarity.mythicPlus: ModuleColor(
      base: Color(0xfff65554),
      accent: Color(0xffe85049),
    ),
    Rarity.ancestral: ModuleColor(
      accent: Color(0xff98f972),
      base: Color(0xff94f088),
    ),
  };
}
