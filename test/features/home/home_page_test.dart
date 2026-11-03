import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/designsystem/component/viora_voice.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/features/home/presentation/state/home_ui_state.dart';
import 'package:viora/features/home/presentation/ui/home_page.dart';

Widget _app(HomeUiState state, {List<Widget> sections = const []}) =>
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomePageContent(state: state, sections: sections),
    );

void main() {
  testWidgets('shows the greeting and the voice line of the state', (tester) async {
    await tester.pumpWidget(
      _app(
        const HomeUiState(
          displayName: 'Rubén Ticona',
          subtitle: 'Cooperativa Olivar del Sur · técnico',
          voiceMessage: 'La Yarada Baja necesita tu visita.',
        ),
      ),
    );

    expect(find.text('Hola, Rubén'), findsOneWidget);
    expect(find.text('Cooperativa Olivar del Sur · técnico'), findsOneWidget);
    expect(find.text('La Yarada Baja necesita tu visita.'), findsOneWidget);
    expect(find.text('Tu valle,'), findsOneWidget);
  });

  testWidgets('hides what the state does not know yet', (tester) async {
    await tester.pumpWidget(_app(const HomeUiState()));

    expect(find.text('Hola'), findsOneWidget);
    expect(find.byType(VioraVoice), findsNothing);
  });

  testWidgets('renders the sections of other features in order', (tester) async {
    await tester.pumpWidget(
      _app(const HomeUiState(), sections: const [Text('Primera'), Text('Segunda')]),
    );

    final first = tester.getTopLeft(find.text('Primera')).dy;
    final second = tester.getTopLeft(find.text('Segunda')).dy;
    expect(first, lessThan(second));
  });
}
