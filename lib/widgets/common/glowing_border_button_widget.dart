import 'package:flutter/material.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class GlowingBorderButtonWidget extends StatelessWidget {
  const GlowingBorderButtonWidget({
    super.key,
    required this.baseColor,
    required this.accentColor,
    required this.borderRadius,
    required this.child,
    required this.onTap,
  });

  final Color baseColor;
  final Color accentColor;
  final int borderRadius;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlowingBorderChipWidget(
      baseColor: baseColor,
      accentColor: accentColor,
      borderRadius: borderRadius,
      child: Padding(
        padding: EdgeInsets.all(borderRadius.toDouble()),
        child: Material(child: InkWell(onTap: onTap, child: child)),
      ),
    );
  }
}
