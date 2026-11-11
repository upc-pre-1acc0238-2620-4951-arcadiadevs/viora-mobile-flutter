import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_kept_reads_use_cases.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_members_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/sector_use_cases.dart';
import 'package:viora/features/cooperative_operations/domain/entity/cooperative_member.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/members_ui_state.dart';

/// G40 · Socios: the license capacity, the codes to redeem and the roster.
class MembersViewModel extends Cubit<MembersUiState> {
  MembersViewModel({
    required this.getCapacity,
    required this.getMembers,
    required this.getCodes,
    this.getSectors,
    this.getKeptCapacity,
    this.getKeptMembers,
    this.getKeptCodes,
  }) : super(const MembersUiState());

  final GetLicenseCapacityUseCase getCapacity;
  final GetMembersUseCase getMembers;
  final GetInvitationCodesUseCase getCodes;

  /// The «Sectores» card; without it the card is not shown.
  final GetSectorsUseCase? getSectors;

  /// The last seats, roster and codes read, shown with their date when there is no connection.
  final GetKeptLicenseCapacityUseCase? getKeptCapacity;
  final GetKeptMembersUseCase? getKeptMembers;
  final GetKeptInvitationCodesUseCase? getKeptCodes;

  /// Also called when the manager comes back from the codes, which change the seats.
  Future<void> load() async {
    emit(state.copyWith(loading: true, failure: () => null));
    try {
      final capacity = await getCapacity.execute();
      final members = await getMembers.execute();
      final codes = await getCodes.execute(InvitationCodeFilter.available);
      if (isClosed) return;
      emit(state.copyWith(
        loading: false,
        capacity: capacity,
        members: members,
        availableCodes: codes,
        savedAt: () => null,
      ));
    } on CooperativeOffline catch (failure) {
      final kept = await _kept();
      if (isClosed) return;
      emit(kept == null
          ? state.copyWith(loading: false, failure: () => failure)
          : state.copyWith(
              loading: false,
              capacity: kept.capacity,
              members: kept.members,
              availableCodes: kept.codes,
              savedAt: () => kept.savedAt,
            ));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: () => failure));
    }
    await _readSectors();
  }

  /// The roster as last read, dated by its oldest part; null unless the seats and the roster were kept.
  Future<({LicenseCapacity capacity, List<CooperativeMember> members, List<InvitationCode> codes, DateTime savedAt})?>
      _kept() async {
    final capacity = await getKeptCapacity?.execute();
    final members = await getKeptMembers?.execute();
    if (capacity == null || members == null) return null;
    final codes = await getKeptCodes?.execute(InvitationCodeFilter.available);
    final dates = [capacity.savedAt, members.savedAt, if (codes != null) codes.savedAt];
    return (
      capacity: capacity.value,
      members: members.value,
      codes: codes?.value ?? const <InvitationCode>[],
      savedAt: dates.reduce((a, b) => a.isBefore(b) ? a : b),
    );
  }

  /// The card is a way in: if the list can't be read the card is left out, not the roster.
  Future<void> _readSectors() async {
    final getSectors = this.getSectors;
    if (getSectors == null) return;
    try {
      final read = await getSectors.execute();
      if (!isClosed) emit(state.copyWith(sectorCount: () => read.sectors.length, pendingSectors: read.pending.length));
    } on CooperativeFailure {
      if (!isClosed) emit(state.copyWith(sectorCount: () => null, pendingSectors: 0));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void filter(MembersFilter filter) => emit(state.copyWith(filter: filter));
}
