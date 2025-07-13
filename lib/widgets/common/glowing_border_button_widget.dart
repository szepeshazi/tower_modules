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
    this.width,
  });

  final Color baseColor;
  final Color accentColor;
  final int borderRadius;
  final Widget child;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final requestedWidth = width;
    return GlowingBorderChipWidget(
      baseColor: baseColor,
      accentColor: accentColor,
      borderRadius: borderRadius,
      child: Padding(
        padding: EdgeInsets.all(borderRadius.toDouble()),
        child: Material(
          child: InkWell(
            onTap: onTap,
            child:
                requestedWidth == null
                    ? child
                    : SizedBox(
                      width: requestedWidth,
                      child: Center(child: child),
                    ),
          ),
        ),
      ),
    );
  }
}
