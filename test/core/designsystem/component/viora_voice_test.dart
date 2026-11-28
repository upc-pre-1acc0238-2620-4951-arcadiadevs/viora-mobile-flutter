import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:viora/core/designsystem/component/viora_icon.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/designsystem/component/viora_voice_animation.dart';

void main() {
  Widget app({bool enabled = true, bool disabled = false}) => MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(disableAnimations: disabled),
      child: VioraVoiceAnimation(
        enabled: enabled,
        child: const Scaffold(body: VioraVoice(text: 'Hello')),
      ),
    ),
  );

  bool hasIcon(WidgetTester tester, String asset) => tester
      .widgetList<SvgPicture>(find.byType(SvgPicture))
      .any((picture) => picture.bytesLoader.toString().contains(asset));

  testWidgets('writes one character at a time and settles', (tester) async {
    await tester.pumpWidget(app());
    var rich = tester.widget<Text>(find.byType(Text));
    expect(rich.textSpan!.toPlainText(), 'Hello');
    expect(((rich.textSpan! as TextSpan).children!.first as TextSpan).text, '');
    await tester.pump(const Duration(milliseconds: 22));
    rich = tester.widget<Text>(find.byType(Text));
    expect(
      ((rich.textSpan! as TextSpan).children!.first as TextSpan).text,
      'H',
    );
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 22));
    }
    await tester.pump(const Duration(milliseconds: 280));
    await tester.pump(const Duration(milliseconds: 240));
    expect(hasIcon(tester, VioraIcons.isotype), isTrue);
  });

  for (final system in [false, true]) {
    testWidgets('motion disabled (system: $system)', (tester) async {
      await tester.pumpWidget(app(enabled: system, disabled: system));
      expect(hasIcon(tester, VioraIcons.isotype), isTrue);
      expect(find.text('Hello', findRichText: true), findsOneWidget);
    });
  }

  testWidgets('tap completes the line', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.byType(VioraVoice));
    await tester.pump();
    expect(hasIcon(tester, VioraIcons.isotype), isTrue);
    expect(find.text('Hello', findRichText: true), findsOneWidget);
  });

  testWidgets('semantics always exposes the full text', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(app());
    expect(find.bySemanticsLabel('Hello'), findsOneWidget);
    handle.dispose();
  });
}
