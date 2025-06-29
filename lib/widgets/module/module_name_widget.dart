import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_spec.dart';

class ModuleNameWidget extends StatelessWidget {
  const ModuleNameWidget({super.key, required this.module});

  final ModuleType module;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextTheme.of(context).bodyLarge ?? TextStyle();
    final style = textStyle.copyWith(color: Colors.grey.shade50, fontWeight: FontWeight.w800);
    return Text(module.moduleName, style: style);
  }

  static final defaultTextTheme = TextTheme();
}
