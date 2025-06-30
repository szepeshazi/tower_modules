import 'package:flutter/material.dart';
import 'package:tower_modules/core/vault_provider.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/state/effect_state.dart';
import 'package:tower_modules/state/module_state_notifier.dart';

import 'rarity_chip_widget.dart';

class SlotWidget extends StatelessWidget {
  const SlotWidget({super.key, required this.value, required this.index});

  final EffectState value;
  final int index;

  @override
  Widget build(BuildContext context) {
    final sign = value.slotValue.negative ? '-' : '+';
    final bloc = VaultProvider.of(context).vault.get<ModuleStateNotifier>();
    final color = ModuleColor.forRarity(value.slotValue.rarity).accent;
    final labelStyle = TextTheme.of(
      context,
    ).labelSmall?.copyWith(fontWeight: FontWeight.w900, color: color);

    return Stack(
      children: [
        Container(
          color: Color(0xff353264),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Opacity(
                opacity: value.locked ? 0.33 : 1.0,
                child: Row(
                  children: [
                    SizedBox(width: 2),
                    RarityChipWidget(value: value),
                    SizedBox(width: 5),
                    Text('$sign${value.slotValue.bonus}', style: labelStyle),
                    Text(value.slotValue.effect.unit.symbol, style: labelStyle),
                    SizedBox(width: 2),
                    Text(value.slotValue.effect.name, style: labelStyle),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 4),
                child: Opacity(
                  opacity: value.locked ? 1.0 : 0.33,
                  child: IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      value.locked ? Icons.lock : Icons.lock_open,
                      size: 20,
                    ),
                    onPressed: () {
                      bloc.toggleLock(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: GradientFlashWidget(value: value)),
      ],
    );
  }
}

class GradientFlashWidget extends StatefulWidget {
  const GradientFlashWidget({super.key, required this.value});

  final EffectState value;

  @override
  State<GradientFlashWidget> createState() => _GradientFlashWidgetState();
}

class _GradientFlashWidgetState extends State<GradientFlashWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0 + trailLength,
    ).animate(controller);
    controller
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..forward();
  }

  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final head = animation.value.clamp(0.0, 1.0);
    final tail = (animation.value - trailLength).clamp(0.0, 1.0);
    final color = ModuleColor.forRarity(widget.value.slotValue.rarity).accent;

    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0x00000000),
              Color(0x00000000),
              color.withAlpha(0),
              color,
              Color(0x00000000),
              Color(0x00000000),
            ],
            stops: [0, tail, tail, head, head, 1.0],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  @override
  void didUpdateWidget(GradientFlashWidget oldWidget) {
    if (oldWidget.value.slotValue != widget.value.slotValue) {
      if(mounted) {
        controller.reset();
        controller.forward();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.stop(canceled: true);
    super.dispose();
  }

  static const trailLength = 0.5;
}
