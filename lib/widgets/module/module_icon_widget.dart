import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tower_modules/model/module_colors.dart';
import 'package:tower_modules/model/module_spec.dart';
import 'package:tower_modules/state/module_state.dart';

class ModuleIconWidget extends StatelessWidget {
  const ModuleIconWidget({super.key, required this.state});

  final ModuleState state;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: CustomPaint(
        painter: ModuleIconPainter(module: state.module, rarity: state.rarity),
      ),
    );
  }
}

class ModuleIconPainter extends CustomPainter {
  ModuleIconPainter({
    super.repaint,
    required this.module,
    required this.rarity,
  });

  final ModuleType module;
  final Rarity rarity;

  @override
  void paint(Canvas canvas, Size size) {
    final moduleColor = ModuleColor.forRarity(rarity);
    if (module == ModuleType.cannon) {
      drawCircularModule(canvas, size, moduleColor);
    } else {
      drawPolygonModule(canvas, size, moduleColor);
    }
  }

  void drawPolygonModule(Canvas canvas, Size size, ModuleColor moduleColor) {
    final pathPoints = modulePath(module);
    final strokeWidth = 0.06 * sqrt(size.width * size.height);
    final scaledOuter =
        pathPoints.map((e) => e.scale(size.width, size.height)).toList();
    final outerPath = Path()..addPolygon(scaledOuter, true);
    canvas.drawPath(
      outerPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = moduleColor.accent
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawShadow(outerPath, moduleColor.base, 2, false);

    final scaledInner =
        pathPoints
            .map(
              (e) => e
                  .scale(
                    size.width - strokeWidth * 2,
                    size.height - strokeWidth * 2,
                  )
                  .translate(strokeWidth, strokeWidth),
            )
            .toList();
    final innerPath = Path()..addPolygon(scaledInner, true);
    canvas.drawPath(
      innerPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black
        ..strokeWidth = 1,
    );
  }

  void drawCircularModule(Canvas canvas, Size size, ModuleColor moduleColor) {
    final strokeWidth = 0.06 * sqrt(size.width * size.height);
    final path =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: sqrt(size.width * size.height) * .4,
          ),
        );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = moduleColor.accent
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawShadow(path, moduleColor.base, 1, true);
    final innerPath =
        Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: sqrt(size.width * size.height) * .4 - strokeWidth,
          ),
        );
    canvas.drawPath(
      innerPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black
        ..strokeWidth = 1,
    );
  }

  List<Offset> modulePath(ModuleType module) {
    switch (module) {
      case ModuleType.cannon:
        throw UnimplementedError();
      case ModuleType.armor:
        return [
          Offset(.1, .2),
          Offset(.2, .1),
          Offset(.8, .10),
          Offset(.9, .2),
          Offset(.9, .8),
          Offset(.8, .9),
          Offset(.2, .9),
          Offset(.1, .8),
        ].toList();
      case ModuleType.generator:
        return [
          Offset(.475, .1),
          Offset(.525, .1),
          Offset(.9, .75),
          Offset(.85, .80),
          Offset(.15, .80),
          Offset(.1, .75),
        ].toList();
      case ModuleType.core:
        return [
          Offset(.45, .1),
          Offset(.55, .1),
          Offset(.9, .45),
          Offset(.9, .55),
          Offset(.55, .9),
          Offset(.45, .9),
          Offset(.1, .55),
          Offset(.1, .45),
        ].toList();
    }
  }

  @override
  bool shouldRepaint(ModuleIconPainter oldDelegate) =>
      module != oldDelegate.module || rarity != oldDelegate.rarity;
}
