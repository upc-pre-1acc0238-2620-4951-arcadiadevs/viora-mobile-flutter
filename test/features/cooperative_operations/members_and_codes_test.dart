import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/core/l10n/app_localizations.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_members_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/issue_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/revoke_invitation_code_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/cooperative_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/cooperative_member_dto.dart';
import 'package:viora/features/cooperative_operations/presentation/state/codes_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/state/issue_codes_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/state/member_detail_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/state/members_ui_state.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/codes_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/issue_codes_sheet.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/member_detail_page.dart';
import 'package:viora/features/cooperative_operations/presentation/ui/members_page.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/codes_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/issue_codes_view_model.dart';
import 'package:viora/features/cooperative_operations/presentation/viewmodel/members_view_model.dart';

final _capacity = LicenseCapacity(
  organizationName: 'Olivar del Sur',
  seats: 60,
  contractedAreaHa: 200,
  seatsUsed: 48,
  seatsFree: 12,
  reservedAreaHa: 138,
  freeAreaHa: 62,
  suggestedHectaresPerCode: 5,
  startsAt: DateTime.utc(2026, 1, 10),
  endsAt: DateTime.utc(2027, 1, 10),
);

InvitationCode _code(
  String id, {
  InvitationCodeStatus status = InvitationCodeStatus.available,
  String batch = 'b1',
  DateTime? expiresAt,
  String? redeemedBy,
}) =>
    InvitationCode(
      id: id,
      batchId: batch,
      issuedAt: DateTime.utc(2026, 11, 15),
      expiresAt: expiresAt ?? DateTime.utc(2026, 11, 30),
      hectares: 5,
      status: status,
      code: status == InvitationCodeStatus.available ? 'COOP-$id' : null,
      maskedCode: 'COOP-••${id.substring(id.length - 2)}',
      redeemedBy: redeemedBy,
      redeemedAt: redeemedBy == null ? null : DateTime.utc(2026, 11, 16, 15, 12),
    );

const _teodoro = CooperativeMember(
  id: 'm1',
  fullName: 'Teodoro Mamani',
  sharing: MemberSharing.sharing,
  withdrawnAt: null,
  plotCount: 2,
  registeredAreaHa: 4,
  sectorNames: ['La Yarada Baja'],
  worstRisk: PlotRisk.critical,
);

const _julio = CooperativeMember(
  id: 'm3',
  fullName: 'Julio Quispe',
  sharing: MemberSharing.sharing,
  withdrawnAt: null,
  plotCount: 3,
  registeredAreaHa: 5.1,
  sectorNames: ['Magollo'],
  worstRisk: PlotRisk.noData,
  unsampledPlots: 2,
);

final _hilda = CooperativeMember(
  id: 'm2',
  fullName: 'Hilda Poma',
  sharing: MemberSharing.withdrawn,
  withdrawnAt: DateTime.utc(2026, 11, 12, 15),
  plotCount: 0,
  registeredAreaHa: 0,
  sectorNames: const [],
  worstRisk: PlotRisk.noData,
);

class _FakeRepository implements CooperativeRepository {
  LicenseCapacity capacityAnswer = _capacity;
  List<CooperativeMember> membersAnswer = [_teodoro, _hilda];
  Map<InvitationCodeFilter, List<InvitationCode>> codesAnswer = {
    InvitationCodeFilter.available: [_code('4F9T'), _code('9HX3')],
    InvitationCodeFilter.redeemed: [],
    InvitationCodeFilter.closed: [],
  };
  Object? revokeError;
  Object? issueError;
  final revoked = <String>[];
  final issued = <(int, double, int)>[];

  @override
  Future<LicenseCapacity> capacity() async => capacityAnswer;

  @override
  Future<List<CooperativeMember>> members() async => membersAnswer;

  @override
  Future<MemberDetail> member(String id) => throw UnimplementedError();

  @override
  Future<List<InvitationCode>> codes(InvitationCodeFilter filter) async => codesAnswer[filter] ?? const [];

  @override
  Future<IssuedCodes> issue({required int quantity, required double hectaresPerCode, required int validityDays}) async {
    issued.add((quantity, hectaresPerCode, validityDays));
    if (issueError != null) throw issueError!;
    return IssuedCodes(
      batchId: 'b9',
      issuedAt: DateTime.utc(2026, 11, 27),
      expiresAt: DateTime.utc(2026, 12, 27),
      hectaresPerCode: hectaresPerCode,
      codes: List.generate(quantity, (i) => 'COOP-NEW$i'),
    );
  }

  @override
  Future<void> revoke(String codeId) async {
    revoked.add(codeId);
    if (revokeError != null) throw revokeError!;
  }
}

Widget _app(Widget home) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

void main() {
  late _FakeRepository repository;

  setUp(() => repository = _FakeRepository());

  group('G40 · Socios', () {
    test('reads the capacity, the roster and the codes to redeem', () async {
      final viewModel = MembersViewModel(
        getCapacity: GetLicenseCapacityUseCase(repository: repository),
        getMembers: GetMembersUseCase(repository: repository),
        getCodes: GetInvitationCodesUseCase(repository: repository),
      );

      await viewModel.load();

      expect(viewModel.state.loading, isFalse);
      expect(viewModel.state.capacity, same(repository.capacityAnswer));
      expect(viewModel.state.members, hasLength(2));
      expect(viewModel.state.availableCodes, hasLength(2));
      await viewModel.close();
    });

    testWidgets('the Sectores card counts the list and what waits «Por confirmar»', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      var opened = false;
      await tester.pumpWidget(_app(MembersPageContent(
        state: MembersUiState(loading: false, capacity: _capacity, sectorCount: 5, pendingSectors: 2),
        header: const SizedBox.shrink(),
        onRetry: () {},
        onSearch: (_) {},
        onFilter: (_) {},
        onOpenMember: (_) {},
        onOpenCodes: () {},
        onIssueCodes: (_) {},
        onOpenSectors: () => opened = true,
      )));

      expect(find.text('5 sectores en tu lista'), findsOneWidget);
      expect(find.text('2 por confirmar'), findsOneWidget);
      await tester.tap(find.text('Sectores'));
      expect(opened, isTrue);
    });

    test('the chips and the search narrow the roster, by name or sector', () {
      final state = MembersUiState(members: [_teodoro, _hilda]);

      expect(state.copyWith(filter: MembersFilter.withdrawn).visibleMembers, [_hilda]);
      expect(state.copyWith(query: 'yarada').visibleMembers, [_teodoro]);
      expect(state.copyWith(query: 'HILDA').visibleMembers, [_hilda]);
      expect(state.sharingCount, 1);
      expect(state.withdrawnCount, 1);
    });

    test('«Sin muestreo» keeps who has a plot without sampling, and the intake can open it by name', () {
      final state = MembersUiState(members: [_teodoro, _julio, _hilda]);

      expect(state.copyWith(filter: MembersFilter.unsampled).visibleMembers, [_julio]);
      expect(state.unsampledCount, 1);
      expect(MembersFilter.parse('unsampled'), MembersFilter.unsampled);
      expect(MembersFilter.parse('anything'), MembersFilter.all);
      expect(MembersFilter.parse(null), MembersFilter.all);
    });

    test('reads the unsampled plots of a member, none when the server does not send them', () {
      final member = CooperativeMemberDto.fromJson({'id': 'm3', 'sharing': 'SHARING', 'unsampledPlots': 2}).toDomain();
      final older = CooperativeMemberDto.fromJson({'id': 'm1', 'sharing': 'SHARING'}).toDomain();

      expect(member.unsampledPlots, 2);
      expect(older.unsampledPlots, 0);
    });

    testWidgets('the «Sin muestreo» chip shows only while someone is missing a sampling', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      Widget roster(List<CooperativeMember> members) => _app(MembersPageContent(
            state: MembersUiState(loading: false, capacity: _capacity, members: members),
            header: const SizedBox.shrink(),
            onRetry: () {},
            onSearch: (_) {},
            onFilter: (_) {},
            onOpenMember: (_) {},
            onOpenCodes: () {},
            onIssueCodes: (_) {},
          ));

      await tester.pumpWidget(roster([_teodoro, _hilda]));
      expect(find.textContaining('Sin muestreo'), findsNothing);

      await tester.pumpWidget(roster([_teodoro, _julio, _hilda]));
      expect(find.text('Sin muestreo · 1'), findsOneWidget);
    });

    test('the codes card counts the codes that expire first', () {
      final state = MembersUiState(availableCodes: [
        _code('A1', expiresAt: DateTime.utc(2026, 11, 30, 15)),
        _code('A2', expiresAt: DateTime.utc(2026, 11, 30, 16)),
        _code('A3', expiresAt: DateTime.utc(2026, 12, 20, 15)),
      ]);

      expect(state.soonestExpiry?.count, 2);
    });

    testWidgets('shows the license, the codes card and every member with its state', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(MembersPageContent(
        state: MembersUiState(
          loading: false,
          capacity: _capacity,
          members: [_teodoro, _hilda],
          availableCodes: [_code('4F9T'), _code('9HX3')],
        ),
        header: const SizedBox.shrink(),
        onRetry: () {},
        onSearch: (_) {},
        onFilter: (_) {},
        onOpenMember: (_) {},
        onOpenCodes: () {},
        onIssueCodes: (_) {},
      )));

      expect(find.text('48'), findsOneWidget);
      expect(find.text('de 60 plazas'), findsOneWidget);
      expect(find.text('Te quedan 12 plazas y 62 ha libres para invitar a más socios.'), findsOneWidget);
      expect(find.text('Teodoro Mamani'), findsOneWidget);
      expect(find.text('Vinculado'), findsOneWidget);
      expect(find.text('Sin datos compartidos'), findsOneWidget);
      expect(find.textContaining('Retiró el acceso'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('G42 · Códigos', () {
    CodesViewModel viewModelOf() => CodesViewModel(
          getCodes: GetInvitationCodesUseCase(repository: repository),
          getCapacity: GetLicenseCapacityUseCase(repository: repository),
          revokeCode: RevokeInvitationCodeUseCase(repository: repository),
          noticeDuration: const Duration(milliseconds: 10),
        );

    test('revoking reloads the lists and shows the notice for a moment', () async {
      final viewModel = viewModelOf();
      await viewModel.load();
      repository.codesAnswer[InvitationCodeFilter.available] = [_code('9HX3')];

      await viewModel.revoke(_code('4F9T'));

      expect(repository.revoked, ['4F9T']);
      expect(viewModel.state.of(InvitationCodeFilter.available), hasLength(1));
      expect(viewModel.state.revokedNotice, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(viewModel.state.revokedNotice, isFalse);
      await viewModel.close();
    });

    test('a code redeemed meanwhile says who used it', () async {
      final viewModel = viewModelOf();
      await viewModel.load();
      repository.revokeError = CodeAlreadyRedeemed(DateTime.utc(2026, 11, 27, 15, 12));
      repository.codesAnswer[InvitationCodeFilter.redeemed] = [
        _code('4F9T', status: InvitationCodeStatus.redeemed, redeemedBy: 'Marleni Flores'),
      ];

      await viewModel.revoke(_code('4F9T'));

      expect(viewModel.state.redeemed?.redeemedBy, 'Marleni Flores');
      expect(viewModel.state.redeemed?.code, 'COOP-4F9T');
      expect(viewModel.state.revoking, isFalse);
      await viewModel.close();
    });

    test('codes are grouped by batch, newest first', () {
      final state = CodesUiState(codes: {
        InvitationCodeFilter.available: [
          _code('A1'),
          InvitationCode(
            id: 'B1',
            batchId: 'b2',
            issuedAt: DateTime.utc(2026, 11, 20),
            expiresAt: DateTime.utc(2026, 12, 20),
            hectares: 8,
            status: InvitationCodeStatus.available,
            code: 'COOP-B1B1',
            maskedCode: 'COOP-••B1',
            redeemedBy: null,
            redeemedAt: null,
          ),
          _code('A2'),
        ],
      });

      expect(state.batches.map((batch) => batch.length), [1, 2]);
      expect(state.batches.first.first.batchId, 'b2');
    });

    testWidgets('lists the codes to redeem with share and revoke', (tester) async {
      await tester.pumpWidget(_app(CodesPageContent(
        state: CodesUiState(
          loading: false,
          capacity: _capacity,
          codes: {
            InvitationCodeFilter.available: [_code('4F9T'), _code('9HX3')],
            InvitationCodeFilter.redeemed: [_code('XX9T', status: InvitationCodeStatus.redeemed, redeemedBy: 'Rosa')],
            InvitationCodeFilter.closed: const [],
          },
        ),
        now: DateTime.utc(2026, 11, 27),
        onBack: () {},
        onRetry: () {},
        onTab: (_) {},
        onShare: (_) {},
        onRevoke: (_) {},
        onIssueCodes: (_) {},
      )));

      expect(find.text('COOP-4F9T'), findsOneWidget);
      expect(find.text('Revocar'), findsNWidgets(2));
      expect(find.text('Por canjear · 2'), findsOneWidget);
      expect(find.text('Canjeados · 1'), findsOneWidget);
      expect(find.text('Vence en 3 días'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('G43 · Generar códigos', () {
    IssueCodesViewModel viewModelOf([LicenseCapacity? capacity]) => IssueCodesViewModel(
          capacity: capacity ?? _capacity,
          issueCodes: IssueInvitationCodesUseCase(repository: repository),
          getCapacity: GetLicenseCapacityUseCase(repository: repository),
        );

    test('starts with five codes of the suggested hectares, for thirty days', () {
      final state = viewModelOf().state;

      expect(state.quantity, 5);
      expect(state.hectaresPerCode, 5);
      expect(state.validityDays, 30);
      expect(state.hectaresSuggested, isTrue);
      expect(state.canIssue, isTrue);
    });

    test('more codes than free seats cannot be issued', () {
      final viewModel = viewModelOf();
      for (var i = 0; i < 8; i++) {
        viewModel.increaseQuantity();
      }

      expect(viewModel.state.quantity, 13);
      expect(viewModel.state.exceedsSeats, isTrue);
      expect(viewModel.state.canIssue, isFalse);
    });

    test('more hectares than free cannot be issued', () {
      final viewModel = viewModelOf();
      for (var i = 0; i < 8; i++) {
        viewModel.increaseHectares();
      }

      expect(viewModel.state.totalHectares, 65);
      expect(viewModel.state.exceedsArea, isTrue);
      expect(viewModel.state.canIssue, isFalse);
    });

    test('issuing sends what was chosen and hands over the codes', () async {
      final viewModel = viewModelOf();
      viewModel.selectValidity(15);

      await viewModel.issue();

      expect(repository.issued.single, (5, 5.0, 15));
      expect(viewModel.state.issued?.codes, hasLength(5));
    });

    test('seats taken meanwhile show what is free now', () async {
      repository.issueError = const NotEnoughSeats(2);
      repository.capacityAnswer = LicenseCapacity(
        organizationName: 'Olivar del Sur',
        seats: 60,
        contractedAreaHa: 200,
        seatsUsed: 58,
        seatsFree: 2,
        reservedAreaHa: 190,
        freeAreaHa: 10,
        suggestedHectaresPerCode: 5,
        startsAt: DateTime.utc(2026),
        endsAt: DateTime.utc(2027),
      );
      final viewModel = viewModelOf();

      await viewModel.issue();

      expect(viewModel.state.failure, isA<NotEnoughSeats>());
      expect(viewModel.state.capacity.seatsFree, 2);
      expect(viewModel.state.exceedsSeats, isTrue);
    });

    testWidgets('on a short screen the sheet scrolls down to its button', (tester) async {
      tester.view.physicalSize = const Size(1080, 1500);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      var issued = false;
      await tester.pumpWidget(_app(Scaffold(
        body: IssueCodesSheetContent(
          state: IssueCodesUiState(capacity: _capacity, quantity: 5, hectaresPerCode: 5),
          now: DateTime.utc(2026, 11, 27),
          onClose: () {},
          onIncreaseQuantity: () {},
          onDecreaseQuantity: () {},
          onIncreaseHectares: () {},
          onDecreaseHectares: () {},
          onValidity: (_) {},
          onIssue: () => issued = true,
        ),
      )));

      await tester.scrollUntilVisible(find.text('Generar 5 códigos'), 200);
      await tester.tap(find.text('Generar 5 códigos'));

      expect(issued, isTrue);
    });

    testWidgets('says why the codes cannot be issued when they exceed the seats', (tester) async {
      await tester.pumpWidget(_app(Scaffold(
        body: IssueCodesSheetContent(
          state: IssueCodesUiState(capacity: _capacity, quantity: 15, hectaresPerCode: 5),
          now: DateTime.utc(2026, 11, 27),
          onClose: () {},
          onIncreaseQuantity: () {},
          onDecreaseQuantity: () {},
          onIncreaseHectares: () {},
          onDecreaseHectares: () {},
          onValidity: (_) {},
          onIssue: () {},
        ),
      )));

      expect(find.text('supera las 12 plazas libres'), findsOneWidget);
      expect(find.textContaining('pasarías tu cupo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('G41 · Socio', () {
    testWidgets('a member who stopped sharing shows only the link code', (tester) async {
      await tester.pumpWidget(_app(MemberDetailContent(
        state: MemberDetailUiState(
          loading: false,
          organizationName: 'Cooperativa Olivar del Sur',
          member: MemberDetail(
            id: 'm2',
            fullName: 'Hilda Poma',
            sharing: MemberSharing.withdrawn,
            withdrawnAt: DateTime.utc(2026, 11, 12, 15),
            memberSince: null,
            quotaHa: null,
            maskedCode: 'COOP-••7Q',
            phone: null,
            email: null,
            registeredAreaHa: null,
            plots: const [],
          ),
        ),
        onBack: () {},
        onRetry: () {},
        onCall: (_) {},
        onWhatsapp: (_) {},
      )));

      expect(find.text('Retiró el acceso'), findsOneWidget);
      expect(find.text('COOP-••7Q · canjeado'), findsOneWidget);
      expect(find.text('Llamar'), findsNothing);
      expect(find.textContaining('Para liberarla'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    test('a plot whose sector waits for the manager has none yet', () {
      final member = MemberDetailDto.fromJson({
        'id': 'm1',
        'fullName': 'Teodoro Mamani',
        'sharing': 'SHARING',
        'plots': [
          {'plotId': 'p1', 'plotName': 'Lote Norte', 'areaHa': 1.5, 'sectorZoneName': 'Magollo', 'sectorStatus': 'PENDING', 'riskLevel': 'NO_DATA'},
          {
            'plotId': 'p2',
            'plotName': 'La Yarada 02',
            'areaHa': 2.5,
            'sectorZoneName': 'La Yarada Baja',
            'sectorStatus': 'ASSIGNED',
            'riskLevel': 'CRITICAL',
            'reasons': [
              {'type': 'OVERLOAD'},
            ],
          },
        ],
      }).toDomain();

      expect(member.plots.first.sectorName, isNull);
      expect(member.plots.last.sectorName, 'La Yarada Baja');
      expect(member.plots.last.reason, RiskReason.overload);
    });
  });

  group('errors of the server', () {
    test('issuing tells seats from hectares', () {
      expect(
        CooperativeErrorMapper.issue(
          const ApiException(409, {'reason': 'subscription.license.insufficient_seats', 'seatsFree': 3}, null),
        ),
        isA<NotEnoughSeats>().having((failure) => failure.seatsFree, 'seatsFree', 3),
      );
      expect(
        CooperativeErrorMapper.issue(const ApiException(409, {'reason': 'subscription.license.insufficient_area'}, null)),
        isA<NotEnoughArea>(),
      );
      expect(CooperativeErrorMapper.issue(const ApiException(503, {}, null)), isA<CodesUnavailable>());
    });

    test('revoking tells a redeemed code from one no longer available', () {
      expect(
        CooperativeErrorMapper.revoke(
          const ApiException(409, {'reason': 'subscription.invitation_code.already_redeemed'}, null),
        ),
        isA<CodeAlreadyRedeemed>(),
      );
      expect(
        CooperativeErrorMapper.revoke(
          const ApiException(409, {'reason': 'subscription.invitation_code.not_available'}, null),
        ),
        isA<CodeNotAvailable>(),
      );
    });
  });

}
