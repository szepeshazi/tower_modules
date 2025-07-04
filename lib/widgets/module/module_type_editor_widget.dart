import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/widgets/common/glowing_border_chip_widget.dart';

class ModuleTypeEditorWidget extends StatefulWidget {
  final ModuleType initialType;
  final void Function(ModuleType?) onConfirm;
  final VoidCallback onCancel;

  const ModuleTypeEditorWidget({
    super.key,
    required this.initialType,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<ModuleTypeEditorWidget> createState() => _ModuleTypeEditorWidgetState();
}

class _ModuleTypeEditorWidgetState extends State<ModuleTypeEditorWidget> {
  ModuleType? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = ModuleColor.forRarity(Rarity.rare).base;
    final accentColor = ModuleColor.forRarity(Rarity.rare).accent;
    final selectedBaseColor = ModuleColor.forRarity(Rarity.ancestral).base;
    final selectedAccentColor = ModuleColor.forRarity(Rarity.ancestral).accent;

    final style = Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900);

    return Material(
      child: Center(
        child: Container(
          width: 320,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Configure your module',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...ModuleType.values.map((type) {
                    return GlowingBorderChipWidget(
                      baseColor:
                          _selectedType == type ? selectedBaseColor : baseColor,
                      accentColor:
                          _selectedType == type
                              ? selectedAccentColor
                              : accentColor,
                      borderRadius: 4,

                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedType = type;
                              });
                            },
                            child: SizedBox(
                              width: 100,
                              height: 32,
                              child: Center(
                                child: Text(
                                  type.shortName,
                                  style: style?.copyWith(
                                    color:
                                        _selectedType == type
                                            ? selectedAccentColor
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => widget.onConfirm(_selectedType),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
              const SizedBox(height: 108),
            ],
          ),
        ),
      ),
    );
  }
}
