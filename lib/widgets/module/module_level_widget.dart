import 'package:flutter/material.dart';

class ModuleLevelWidget extends StatelessWidget {
  const ModuleLevelWidget({
    super.key,
    required this.currentLevel,
    required this.maxLevel,
  });

  final int currentLevel;
  final int maxLevel;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextTheme.of(context).bodySmall ?? TextStyle();
    final style = textStyle.copyWith(color: Colors.grey.shade50, letterSpacing: 0);
    return Text('Lv. $currentLevel / $maxLevel', style: style);
  }
}
