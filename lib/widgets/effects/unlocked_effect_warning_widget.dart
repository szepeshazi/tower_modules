import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/common/glowing_border_button_widget.dart';
import 'package:tower_modules/widgets/common/overlay_widget.dart';

class UnlockedEffectWarningWidget extends StatelessWidget {
  const UnlockedEffectWarningWidget({super.key, required this.bloc});

  final ModuleStateNotifier bloc;

  @override
  Widget build(BuildContext context) {
    final baseRejectColor = ModuleColor.forRarity(Rarity.mythic).base;
    final accentRejectColor = ModuleColor.forRarity(Rarity.mythic).accent;
    final baseAcceptColor = ModuleColor.forRarity(Rarity.ancestral).base;
    final accentAcceptColor = ModuleColor.forRarity(Rarity.ancestral).accent;
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade300,
    );

    return Positioned.fill(
      child: OverlayWidget(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          child: Center(
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: Color(0xff181838),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reroll',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'You have one or more effects of mythic or higher rarity that aren\'t locked.',
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Are you sure that you want to continue?',
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlowingBorderButtonWidget(
                        baseColor: baseRejectColor,
                        accentColor: accentRejectColor,
                        borderRadius: 4,
                        onTap: bloc.dismissWarningDialog,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              'No',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 26),
                      GlowingBorderButtonWidget(
                        baseColor: baseAcceptColor,
                        accentColor: accentAcceptColor,
                        borderRadius: 4,
                        onTap: bloc.skipEffectCheck,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 8,
                          ),
                          child: Center(
                            child: Text(
                              'Yes',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
