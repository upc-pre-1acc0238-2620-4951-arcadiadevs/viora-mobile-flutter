import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/designsystem/component/viora_morphing_shape_indicator.dart';
import 'package:viora/core/designsystem/component/viora_wavy_progress_indicator.dart';

void main() {
  Widget sized(Widget child) => MaterialApp(
        home: Center(child: SizedBox.square(dimension: 64, child: child)),
      );

  group('VioraMorphingShapeIndicator', () {
    testWidgets('keeps morphing while it is not told to settle', (tester) async {
      var settled = false;
      await tester.pumpWidget(
        sized(VioraMorphingShapeIndicator(color: Colors.black, onSettled: () => settled = true)),
      );

      for (var i = 0; i < 300; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(settled, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('reports once when it settles into the circle', (tester) async {
      var settled = 0;
      Widget indicator(bool settle) => sized(
            VioraMorphingShapeIndicator(
              color: Colors.black,
              settle: settle,
              onSettled: () => settled++,
            ),
          );

      await tester.pumpWidget(indicator(false));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(indicator(true));
      for (var i = 0; i < 300; i++) {
        await tester.pump(const Duration(milliseconds: 16));
      }

      expect(settled, 1);
    });

    test('every shape fits in the unit square', () {
      for (final shape in [...VioraMorphingShapes.loading, VioraMorphingShapes.circle]) {
        for (final cubic in shape.cubics) {
          expect(cubic.anchor0X, inInclusiveRange(-0.001, 1.001));
          expect(cubic.anchor0Y, inInclusiveRange(-0.001, 1.001));
        }
      }
    });
  });

  testWidgets('VioraWavyProgressIndicator paints a full loop', (tester) async {
    await tester.pumpWidget(
      sized(const VioraWavyProgressIndicator(color: Colors.white, trackColor: Colors.grey)),
    );

    for (var i = 0; i < 400; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    expect(tester.takeException(), isNull);
  });
}
