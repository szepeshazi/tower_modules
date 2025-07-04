import 'package:flutter/material.dart';
import 'package:tower_modules/state/module_state_notifier.dart';
import 'package:tower_modules/widgets/overlay_widget.dart';

class UnlockedEffectWarningWidget extends StatelessWidget {
  const UnlockedEffectWarningWidget({super.key, required this.bloc});

  final ModuleStateNotifier bloc;

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reroll',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text('You have one or more effects of mythic or higher rarity that aren\'t locked.'),
                    const SizedBox(height: 16),
                    Text('Are you sure that you want to continue?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: bloc.dismissWarningDialog,
                          child: const Text('No'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: bloc.skipEffectCheck,
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 108),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
