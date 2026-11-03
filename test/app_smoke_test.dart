import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/main.dart';

void main() {
  setUp(setupDependencies);
  tearDown(() => getIt.reset());

  test('get_it entrega un ViewModel nuevo cada vez y una sola base de datos', () {
    expect(getIt<HomeViewModel>(), isNot(same(getIt<HomeViewModel>())));
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
  });

  testWidgets('la app abre en Inicio con el estado del Cubit', (tester) async {
    await tester.pumpWidget(const VioraApp());
    await tester.pumpAndSettle();

    expect(find.text('Tu campo,'), findsOneWidget);
    expect(find.text('hoy.'), findsOneWidget);
  });
}
