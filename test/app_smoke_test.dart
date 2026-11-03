import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/database/app_database.dart';
import 'package:viora/core/di/dependency_injection.dart';
import 'package:viora/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:viora/main.dart';

void main() {
  setUp(setupDependencies);
  tearDown(() => getIt.reset());

  test('get_it provides a new ViewModel every time and a single database', () {
    expect(getIt<HomeViewModel>(), isNot(same(getIt<HomeViewModel>())));
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
  });

  testWidgets('the app opens on Home with the Cubit state', (tester) async {
    await tester.pumpWidget(const VioraApp());
    await tester.pumpAndSettle();

    expect(find.text('Tu campo,'), findsOneWidget);
    expect(find.text('hoy.'), findsOneWidget);
  });
}
