import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/designsystem/component/viora_avatar.dart';
import 'package:viora/core/designsystem/component/viora_capsule_bar.dart';
import 'package:viora/core/designsystem/component/viora_card.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_section_header.dart';
import 'package:viora/core/designsystem/component/viora_tab_bar.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('VioraTabBar', () {
    const items = [
      TabBarItem(iconAsset: VioraIcons.home, label: 'Inicio'),
      TabBarItem(iconAsset: VioraIcons.locationOn, label: 'Riesgo'),
      TabBarItem(iconAsset: VioraIcons.inventory2, label: 'Acopio'),
      TabBarItem(iconAsset: VioraIcons.groups, label: 'Socios'),
    ];

    testWidgets('reports the tapped destination', (tester) async {
      int? selected;
      await tester.pumpWidget(
        _app(
          Center(
            child: VioraTabBar(
              items: items,
              selectedIndex: 0,
              onItemSelected: (index) => selected = index,
            ),
          ),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Socios'));
      expect(selected, 3);
    });

    testWidgets('takes only its own height, so the shell can anchor it', (tester) async {
      await tester.pumpWidget(
        _app(
          Align(
            alignment: Alignment.bottomCenter,
            child: VioraTabBar(items: items, selectedIndex: 0, onItemSelected: (_) {}),
          ),
        ),
      );

      expect(tester.getSize(find.byType(VioraTabBar)).height, VioraTabBarDefaults.barHeight);
      expect(tester.getBottomLeft(find.byType(VioraTabBar)).dy, 600);
    });

    testWidgets('shows one icon per destination and no action button', (tester) async {
      await tester.pumpWidget(
        _app(
          Center(
            child: VioraTabBar(items: items, selectedIndex: 2, onItemSelected: (_) {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VioraIcon), findsNWidgets(items.length));
      expect(find.bySemanticsLabel('¿Qué vas a registrar?'), findsNothing);
    });
  });

  group('VioraSectionHeader', () {
    testWidgets('shows the count and runs the action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _app(
          VioraSectionHeader(
            title: 'Visitas',
            count: 3,
            actionLabel: 'Ver todas',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('3'), findsOneWidget);
      await tester.tap(find.text('Ver todas'));
      expect(tapped, isTrue);
      expect(tester.getSize(find.byType(InkWell)).height, greaterThanOrEqualTo(48));
    });

    testWidgets('gives the title all the space the action leaves free', (tester) async {
      await tester.pumpWidget(
        _app(
          Center(
            child: SizedBox(
              // The test font is wide: this title fits in the free space, but not in half.
              width: 600,
              child: VioraSectionHeader(
                title: 'Tu cooperativa',
                actionLabel: 'Ver',
                onAction: () {},
              ),
            ),
          ),
        ),
      );

      final title = tester.renderObject<RenderParagraph>(find.text('Tu cooperativa'));
      expect(title.didExceedMaxLines, isFalse);
    });

    testWidgets('hides the count and the action when they are not given', (tester) async {
      await tester.pumpWidget(_app(const VioraSectionHeader(title: 'Socios')));

      expect(find.byType(InkWell), findsNothing);
      expect(find.byType(Text), findsOneWidget);
    });
  });

  group('VioraAvatar', () {
    testWidgets('uses the first two initials', (tester) async {
      await tester.pumpWidget(_app(const VioraAvatar(name: 'rubén ticona flores')));
      expect(find.text('RT'), findsOneWidget);
    });

    testWidgets('falls back to the isotype without a name', (tester) async {
      await tester.pumpWidget(_app(const VioraAvatar(name: '')));
      expect(find.byType(VioraIcon), findsOneWidget);
    });
  });

  testWidgets('VioraVoice limits the line to two rows', (tester) async {
    await tester.pumpWidget(_app(const VioraVoice(text: 'Hola')));
    expect(tester.widget<Text>(find.text('Hola')).maxLines, 2);
  });

  testWidgets('VioraSegmentedBar skips empty segments', (tester) async {
    await tester.pumpWidget(
      _app(
        const VioraSegmentedBar(
          segments: [
            VioraBarSegment(value: 9, color: Colors.red),
            VioraBarSegment(value: 0, color: Colors.blue),
            VioraBarSegment(value: 31, color: Colors.green),
          ],
        ),
      ),
    );
    expect(find.byType(Expanded), findsNWidgets(2));
    expect(tester.getSize(find.byType(Expanded).first).height, 14);
  });

  testWidgets('VioraSegmentedBar divides its width by proportions', (tester) async {
    const values = [9, 14, 31, 6];
    await tester.pumpWidget(
      _app(
        Center(
          child: SizedBox(
            width: 310,
            child: VioraSegmentedBar(
              height: 18,
              segments: [
                for (final value in values) VioraBarSegment(value: value, color: Colors.red),
              ],
            ),
          ),
        ),
      ),
    );

    // Space left after the three gaps, shared by 9 : 14 : 31 : 6 out of 60.
    for (var i = 0; i < values.length; i++) {
      final width = tester.getSize(find.byType(Expanded).at(i)).width;
      expect(width, moreOrLessEquals((310 - 3 * 4) * values[i] / 60, epsilon: 0.5));
    }
  });

  testWidgets('VioraProgressBar clamps the value', (tester) async {
    await tester.pumpWidget(_app(const VioraProgressBar(value: 1.8)));
    expect(tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox)).widthFactor, 1);
  });

  testWidgets('VioraCard only reacts when it has onTap', (tester) async {
    await tester.pumpWidget(_app(const VioraCard(child: Text('Dato'))));
    expect(find.byType(InkWell), findsNothing);

    var tapped = false;
    await tester.pumpWidget(_app(VioraCard(onTap: () => tapped = true, child: const Text('Dato'))));
    await tester.tap(find.text('Dato'));
    expect(tapped, isTrue);
  });
}
