import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_members_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/members_ui_state.dart';

/// G40 · Socios: the license capacity, the codes to redeem and the roster.
class MembersViewModel extends Cubit<MembersUiState> {
  MembersViewModel({
    required this.getCapacity,
    required this.getMembers,
    required this.getCodes,
  }) : super(const MembersUiState());

  final GetLicenseCapacityUseCase getCapacity;
  final GetMembersUseCase getMembers;
  final GetInvitationCodesUseCase getCodes;

  /// Also called when the manager comes back from the codes, which change the seats.
  Future<void> load() async {
    emit(state.copyWith(loading: true, failure: () => null));
    try {
      final capacity = await getCapacity.execute();
      final members = await getMembers.execute();
      final codes = await getCodes.execute(InvitationCodeFilter.available);
      if (isClosed) return;
      emit(state.copyWith(loading: false, capacity: capacity, members: members, availableCodes: codes));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: () => failure));
    }
  }

  void search(String query) => emit(state.copyWith(query: query));

  void filter(MembersFilter filter) => emit(state.copyWith(filter: filter));
}
