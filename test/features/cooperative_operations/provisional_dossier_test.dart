import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_pdf_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_provisional_dossier_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/provisional_dossier_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/state/provisional_dossier_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/provisional_dossier_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/provisional_dossier_view_model.dart';

/// The dossier of the mockup: La Yarada 02, with the thinning still pending.
ProvisionalDossier _dossier({
  double? fruits = 2.0,
  double? over = 42.9,
  double? removal = 30,
  double? areaHa = 2.5,
  String? variety = 'SEVILLANA',
  DateTime? thinnedOn,
}) =>
    ProvisionalDossier(
      plotId: 'p1',
      plotName: 'La Yarada 02',
      producerName: 'Teodoro Mamani',
      organizationName: 'Cooperativa Olivar del Sur',
      variety: variety,
      areaHa: areaHa,
      campaignYear: 2026,
      cutOffAt: DateTime(2026, 11, 10, 15, 40),
      fruitsPerShoot: fruits,
      targetFruitsPerShoot: 1.4,
      overTargetPercent: over,
      removalPercent: removal,
      windowOpensOn: DateTime(2026, 11, 3),
      windowClosesOn: DateTime(2026, 11, 30),
      sampledTrees: 5,
      lastSampledOn: DateTime(2026, 10, 29),
      thinnedOn: thinnedOn,
      linkedNodes: 2,
      daysWithReadings: 182,
    );

final _pdf = DossierFile(bytes: Uint8List.fromList([0x25, 0x50, 0x44, 0x46]), fileName: 'expediente.pdf');

class _FakeDossiers implements DossierRepository {
  CooperativeFailure? failure;
  CooperativeFailure? pdfFailure;
  Completer<DossierFile>? pendingPdf;
  int pdfRequests = 0;

  @override
  Future<ProvisionalDossier> provisional(String plotId) async {
    final failure = this.failure;
    if (failure != null) throw failure;
    return _dossier();
  }

  @override
  Future<DossierFile> provisionalPdf(String plotId) async {
    pdfRequests++;
    final failure = pdfFailure;
    if (failure != null) throw failure;
    return pendingPdf?.future ?? _pdf;
  }
}

class _FakeExporter implements DocumentExporter {
  bool saveAnswer = true;
  final saved = <DossierFile>[];
  final shared = <(DossierFile, String)>[];

  @override
  Future<bool> save(DossierFile file) async {
    saved.add(file);
    return saveAnswer;
  }

  @override
  Future<void> share(DossierFile file, {required String subject}) async => shared.add((file, subject));
}

ProvisionalDossierViewModel _viewModel(_FakeDossiers dossiers, _FakeExporter exporter) => ProvisionalDossierViewModel(
      getDossier: GetProvisionalDossierUseCase(repository: dossiers),
      getPdf: GetProvisionalDossierPdfUseCase(repository: dossiers),
      exporter: exporter,
    );

Widget _page(
  ProvisionalDossierUiState state, {
  VoidCallback? onDownload,
  VoidCallback? onShare,
  VoidCallback? onRetry,
}) =>
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProvisionalDossierContent(
        state: state,
        onBack: () {},
        onRetry: onRetry ?? () {},
        onDownload: onDownload ?? () {},
        onShare: onShare ?? () {},
      ),
    );

void _phone(WidgetTester tester, {double height = 1400}) {
  tester.view.physicalSize = Size(360 * 3, height * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  group('reading the server', () {
    test('the dossier keeps its figures and the instant it was cut off', () {
      final dossier = ProvisionalDossierDto.fromJson({
        'documentType': 'PROVISIONAL',
        'plotId': 'p1',
        'plotName': 'La Yarada 02',
        'producerName': 'Teodoro Mamani',
        'organizationName': 'Cooperativa Olivar del Sur',
        'variety': 'SEVILLANA',
        'areaHa': 2.5,
        'campaignYear': 2026,
        'cutOffAt': '2026-11-10T20:40:00Z',
        'preThinningFruitsPerShoot': 2.0,
        'targetFruitsPerShoot': 1.4,
        'overTargetPercentage': 42.9,
        'prescribedRemovalPercentage': 30.0,
        'windowOpensOn': '2026-11-03',
        'windowClosesOn': '2026-11-30',
        'sampledTrees': 5,
        'lastSampledOn': '2026-10-29',
        'thinnedOn': null,
        'linkedNodes': 2,
        'daysWithReadings': 182,
      }).toDomain();

      expect(dossier.plotName, 'La Yarada 02');
      expect(dossier.campaignYear, 2026);
      expect(dossier.cutOffAt, DateTime.utc(2026, 11, 10, 20, 40));
      expect(dossier.fruitsPerShoot, 2.0);
      expect(dossier.overTargetPercent, 42.9);
      expect(dossier.removalPercent, 30);
      expect(dossier.windowClosesOn, DateTime(2026, 11, 30));
      expect(dossier.thinnedOn, isNull);
      expect((dossier.linkedNodes, dossier.daysWithReadings), (2, 182));
    });

    test('a plot without records keeps its missing figures empty, never zero', () {
      final dossier = ProvisionalDossierDto.fromJson({
        'plotId': 'p2',
        'plotName': 'Magollo 01',
        'campaignYear': 2026,
        'sampledTrees': 0,
        'linkedNodes': 0,
        'daysWithReadings': 0,
      }).toDomain();

      expect(dossier.fruitsPerShoot, isNull);
      expect(dossier.removalPercent, isNull);
      expect(dossier.areaHa, isNull);
      expect(dossier.variety, isNull);
      expect(dossier.cutOffAt, isNull);
    });

    test('a plot the member no longer shares and a manager without a license read apart', () {
      expect(CooperativeErrorMapper.dossier(const ApiException(404, {}, null)), isA<PlotNotShared>());
      expect(CooperativeErrorMapper.dossier(const ApiException(403, {}, null)), isA<CooperativeNoLicense>());
      expect(CooperativeErrorMapper.dossier(const ApiException(500, {}, null)), isA<CooperativeUnexpected>());
    });
  });

  group('T16 · the view model', () {
    test('it loads the dossier of the plot', () async {
      final viewModel = _viewModel(_FakeDossiers(), _FakeExporter());

      await viewModel.load('p1');

      expect(viewModel.state.loading, isFalse);
      expect(viewModel.state.dossier?.plotName, 'La Yarada 02');
    });

    test('downloading keeps the PDF and says so; cancelling the dialog says nothing', () async {
      final dossiers = _FakeDossiers();
      final exporter = _FakeExporter();
      final viewModel = _viewModel(dossiers, exporter);
      await viewModel.load('p1');

      await viewModel.download();
      expect(exporter.saved.single.fileName, 'expediente.pdf');
      expect(viewModel.state.notice?.failure, isNull);
      expect(viewModel.state.notice, isNotNull);
      expect(viewModel.state.exporting, isNull);

      exporter.saveAnswer = false;
      await viewModel.download();
      expect(viewModel.state.notice, isNull);
      expect(dossiers.pdfRequests, 2);
    });

    test('sharing sends the PDF with its subject', () async {
      final exporter = _FakeExporter();
      final viewModel = _viewModel(_FakeDossiers(), exporter);
      await viewModel.load('p1');

      await viewModel.share(subject: 'Expediente provisional · La Yarada 02');

      expect(exporter.shared.single.$2, 'Expediente provisional · La Yarada 02');
      expect(viewModel.state.notice, isNull);
    });

    test('a PDF that cannot be fetched keeps the dossier on screen and tells why', () async {
      final dossiers = _FakeDossiers()..pdfFailure = const CooperativeOffline();
      final viewModel = _viewModel(dossiers, _FakeExporter());
      await viewModel.load('p1');

      await viewModel.download();

      expect(viewModel.state.dossier, isNotNull);
      expect(viewModel.state.notice?.failure, isA<CooperativeOffline>());
      expect(viewModel.state.exporting, isNull);
    });

    test('a second tap while the PDF arrives asks for it only once', () async {
      final dossiers = _FakeDossiers()..pendingPdf = Completer<DossierFile>();
      final exporter = _FakeExporter();
      final viewModel = _viewModel(dossiers, exporter);
      await viewModel.load('p1');

      final first = viewModel.download();
      expect(viewModel.state.exporting, DossierExport.download);
      await viewModel.share(subject: 'x');
      dossiers.pendingPdf!.complete(_pdf);
      await first;

      expect(dossiers.pdfRequests, 1);
      expect(exporter.saved, hasLength(1));
      expect(exporter.shared, isEmpty);
    });
  });

  group('T16 · the screen', () {
    testWidgets('it shows the dossier of the mockup as provisional, without a verification code', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(ProvisionalDossierUiState(loading: false, dossier: _dossier())));

      expect(find.text('Expediente técnico'), findsOneWidget);
      expect(find.text('La Yarada 02 · Campaña 2026'), findsOneWidget);
      expect(find.text('EXPEDIENTE AGRONÓMICO · PROVISIONAL'), findsOneWidget);
      expect(find.text('La Yarada 02'), findsOneWidget);
      expect(find.text('Teodoro Mamani · Cooperativa Olivar del Sur'), findsOneWidget);
      expect(find.text('2026 · en curso'), findsOneWidget);
      expect(find.text('Sevillana · 2,5 ha'), findsOneWidget);
      expect(find.text('2,00 frutos/brote · +42,9 %'), findsOneWidget);
      expect(find.text('Aclareo 30 % · 3–30 nov'), findsOneWidget);
      expect(find.text('Aún no'), findsOneWidget);
      expect(find.text('2 nodos · 182 días de datos'), findsOneWidget);
      expect(find.text('PROVISIONAL · NO CERTIFICADO'), findsOneWidget);
      expect(find.text('Corte 10 nov 2026, 15:40'), findsOneWidget);
      expect(find.textContaining('SHA-256'), findsNothing);
      expect(find.text('Descargar PDF'), findsOneWidget);
      expect(find.text('Compartir'), findsOneWidget);
    });

    testWidgets('a field without records reads «No disponible»', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(ProvisionalDossierUiState(
        loading: false,
        dossier: _dossier(fruits: null, over: null, removal: null, areaHa: null, variety: null),
      )));

      expect(find.text('No disponible'), findsNWidgets(3));
    });

    testWidgets('a registered thinning shows its day', (tester) async {
      _phone(tester);
      await tester.pumpWidget(_page(ProvisionalDossierUiState(loading: false, dossier: _dossier(thinnedOn: DateTime(2026, 11, 8)))));

      expect(find.text('8 nov'), findsOneWidget);
      expect(find.text('Aún no'), findsNothing);
    });

    testWidgets('the buttons download and share; while a PDF arrives both wait', (tester) async {
      _phone(tester);
      var downloads = 0;
      var shares = 0;
      await tester.pumpWidget(_page(
        ProvisionalDossierUiState(loading: false, dossier: _dossier()),
        onDownload: () => downloads++,
        onShare: () => shares++,
      ));
      await tester.tap(find.text('Descargar PDF'));
      await tester.tap(find.text('Compartir'));
      expect((downloads, shares), (1, 1));

      await tester.pumpWidget(_page(
        ProvisionalDossierUiState(loading: false, dossier: _dossier()).exportingAs(DossierExport.download),
        onDownload: () => downloads++,
        onShare: () => shares++,
      ));
      await tester.tap(find.text('Descargar PDF'));
      await tester.tap(find.text('Compartir'));
      expect((downloads, shares), (1, 1));
    });

    testWidgets('a plot the member stopped sharing says so and offers to retry', (tester) async {
      _phone(tester);
      var retries = 0;
      await tester.pumpWidget(_page(
        const ProvisionalDossierUiState(loading: false, failure: PlotNotShared()),
        onRetry: () => retries++,
      ));

      expect(find.text('Este socio ya no comparte la parcela.'), findsOneWidget);
      await tester.tap(find.text('Reintentar'));
      expect(retries, 1);
    });
  });
}
