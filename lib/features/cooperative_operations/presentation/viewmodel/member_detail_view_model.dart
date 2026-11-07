import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_member_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/member_detail_ui_state.dart';

/// G41 · Socio: one member in full, under the name of the license's organization.
class MemberDetailViewModel extends Cubit<MemberDetailUiState> {
  MemberDetailViewModel({required this.getMember, required this.getCapacity}) : super(const MemberDetailUiState());

  final GetMemberUseCase getMember;
  final GetLicenseCapacityUseCase getCapacity;

  Future<void> load(String memberId) async {
    emit(MemberDetailUiState(organizationName: state.organizationName));
    try {
      final member = await getMember.execute(memberId);
      final organization = state.organizationName ?? (await getCapacity.execute()).organizationName;
      if (!isClosed) emit(MemberDetailUiState(loading: false, member: member, organizationName: organization));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(MemberDetailUiState(loading: false, failure: failure));
    }
  }
}
