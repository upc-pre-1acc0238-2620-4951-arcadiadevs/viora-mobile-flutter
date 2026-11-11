import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/application/usecase/sector_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/entity/sector_zone.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/sector_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/presentation/state/sectors_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/sectors_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/sectors_view_model.dart';
import 'package:viora/navigation/app_router.dart';

const _magollo = SectorZone(id: 's1', name: 'Magollo', plotCount: 12);
const _sama = SectorZone(id: 's2', name: 'Sama', plotCount: 4);
const _cerroBlanco = PendingSector(plotId: 'p3', plotName: 'Parcela 3', producerName: 'Julio Quispe', proposedName: 'Cerro Blanco');

class _FakeSectors implements SectorRepository {
  List<SectorZone> list = [_magollo, _sama];
  List<PendingSector> waiting = [_cerroBlanco];
  CooperativeFailure? saveFailure;
  CooperativeFailure? resolveFailure;
  final calls = <String>[];

  @override
  Future<List<SectorZone>> sectors() async => list;

  @override
  Future<List<PendingSector>> pending() async => waiting;

  @override
  Future<SectorZone> add(String name) async {
    calls.add('add $name');
    final failure = saveFailure;
    if (failure != null) throw failure;
    final added = SectorZone(id: 'new', name: name, plotCount: 0);
    list = [...list, added];
    return added;
  }

  @override
  Future<SectorZone> rename(String sectorId, String name) async {
    calls.add('rename $sectorId $name');
    final failure = saveFailure;
    if (failure != null) throw failure;
    return SectorZone(id: sectorId, name: name, plotCount: 0);
  }

  @override
  Future<void> resolve(String plotId, {String? sectorId}) async {
    calls.add('resolve $plotId ${sectorId ?? '-'}');
    final failure = resolveFailure;
    if (failure != null) throw failure;
    waiting = [];
  }
}

Widget _app(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  late _FakeSectors repository;

  SectorsViewModel viewModel() => SectorsViewModel(
        getSectors: GetSectorsUseCase(repository: repository),
        saveSector: SaveSectorUseCase(repository: repository),
        resolvePending: ResolvePendingSectorUseCase(repository: repository),
      );

  setUp(() => repository = _FakeSectors());

  group('SectorsViewModel', () {
    test('reads the list and the plots «Por confirmar»', () async {
      final vm = viewModel();
      await vm.load();

      expect(vm.state.loading, isFalse);
      expect(vm.state.sectors.map((s) => s.name), ['Magollo', 'Sama']);
      expect(vm.state.pending.single.proposedName, 'Cerro Blanco');
    });

    test('adding a sector closes the sheet and reads the list again', () async {
      final vm = viewModel();
      await vm.load();

      expect(await vm.save('  Cerro Blanco '), isTrue);
      expect(repository.calls, ['add Cerro Blanco']);
      expect(vm.state.sectors.last.name, 'Cerro Blanco');
      expect(vm.state.saving, isFalse);
    });

    test('a name taken keeps the sheet open and says why', () async {
      repository.saveFailure = const SectorNameTaken();
      final vm = viewModel();

      expect(await vm.save('magollo', sectorId: 's2'), isFalse);
      expect(vm.state.sheetFailure, isA<SectorNameTaken>());

      vm.clearSheetFailure();
      expect(vm.state.sheetFailure, isNull);
    });

    test('a name outside 2 to 60 letters is refused before sending', () async {
      final vm = viewModel();

      expect(await vm.save(' a '), isFalse);
      expect(vm.state.sheetFailure, isA<SectorNameInvalid>());
      expect(repository.calls, isEmpty);
    });

    test('«Es el mismo que…» resolves the plot with the sector chosen', () async {
      final vm = viewModel();
      await vm.load();

      expect(await vm.resolve('p3', sectorId: 's1'), isTrue);
      expect(repository.calls, ['resolve p3 s1']);
      expect(vm.state.pending, isEmpty);
    });

    test('a plot someone already resolved closes the sheet and reads the list again', () async {
      repository.resolveFailure = const SectorAlreadyResolved();
      final vm = viewModel();

      expect(await vm.resolve('p3'), isTrue);
      expect(vm.state.sheetFailure, isNull);
    });
  });

  test('the server errors of the sectors mean what the sheets say', () {
    expect(
      CooperativeErrorMapper.sector(const ApiException(409, {'reason': 'territory.sector_zone.name_taken'}, null)),
      isA<SectorNameTaken>(),
    );
    expect(
      CooperativeErrorMapper.sector(const ApiException(409, {'reason': 'territory.plot_sector.not_pending'}, null)),
      isA<SectorAlreadyResolved>(),
    );
    expect(CooperativeErrorMapper.sector(const ApiException(400, {}, null)), isA<SectorNameInvalid>());
  });

  group('G45 · Sectores', () {
    Widget page(SectorsUiState state, {List<String>? opened}) => _app(SectorsPageContent(
          state: state,
          onBack: () {},
          onRetry: () {},
          onReview: (pending) => opened?.add('review ${pending.plotId}'),
          onRename: (sector) => opened?.add('rename ${sector.id}'),
          onAdd: () => opened?.add('add'),
        ));

    testWidgets('shows what waits for review and the list, each with its action', (tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final opened = <String>[];

      await tester.pumpWidget(page(
        const SectorsUiState(loading: false, sectors: [_magollo, _sama], pending: [_cerroBlanco]),
        opened: opened,
      ));

      expect(find.text('Por confirmar'), findsOneWidget);
      expect(find.text('1 por revisar'), findsOneWidget);
      expect(find.text('Julio Quispe · Parcela 3'), findsOneWidget);
      expect(find.text('2 sectores'), findsOneWidget);
      expect(find.text('12 parcelas'), findsOneWidget);

      await tester.tap(find.text('Cerro Blanco'));
      await tester.tap(find.text('Sama'));
      await tester.tap(find.text('Añadir sector'));
      expect(opened, ['review p3', 'rename s2', 'add']);
    });

    testWidgets('without plots to review the first card is left out', (tester) async {
      await tester.pumpWidget(page(const SectorsUiState(loading: false, sectors: [_magollo])));

      expect(find.text('Por confirmar'), findsNothing);
      expect(find.text('1 sector'), findsOneWidget);
    });
  });

  test('G45 opens from Socios and from the «Por confirmar» row of the map', () {
    for (final tab in ['/members', '/risk']) {
      final match = appRouter.configuration.findMatch(Uri.parse('$tab/${SectorsPage.path}'));
      expect(match.matches.last.matchedLocation, '$tab/sector-list');
    }
  });
}
