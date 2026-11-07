import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/revoke_invitation_code_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/codes_ui_state.dart';

/// G42 · Códigos: the three lists, revoking a code and what came of it.
class CodesViewModel extends Cubit<CodesUiState> {
  CodesViewModel({
    required this.getCodes,
    required this.getCapacity,
    required this.revokeCode,
    this.noticeDuration = const Duration(seconds: 3),
  }) : super(const CodesUiState());

  final GetInvitationCodesUseCase getCodes;
  final GetLicenseCapacityUseCase getCapacity;
  final RevokeInvitationCodeUseCase revokeCode;
  final Duration noticeDuration;
  Timer? _notice;

  /// Reads the capacity and every list, so each tab shows its count.
  Future<void> load() async {
    emit(state.copyWith(loading: true, failure: () => null));
    try {
      final capacity = await getCapacity.execute();
      final codes = {for (final filter in InvitationCodeFilter.values) filter: await getCodes.execute(filter)};
      if (!isClosed) emit(state.copyWith(loading: false, capacity: capacity, codes: codes));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(loading: false, failure: () => failure));
    }
  }

  void selectTab(InvitationCodeFilter tab) => emit(state.copyWith(tab: tab));

  /// Revokes [code] once the manager confirmed it in its dialog.
  Future<void> revoke(InvitationCode code) async {
    if (state.revoking) return;
    emit(state.copyWith(revoking: true, notAvailable: false));
    try {
      await revokeCode.execute(code.id);
      await load();
      if (isClosed) return;
      emit(state.copyWith(revoking: false, revokedNotice: true));
      _notice?.cancel();
      _notice = Timer(noticeDuration, () {
        if (!isClosed) emit(state.copyWith(revokedNotice: false));
      });
    } on CodeAlreadyRedeemed catch (failure) {
      // Someone used it meanwhile: the redeemed list says who.
      await load();
      if (isClosed) return;
      final used = state.of(InvitationCodeFilter.redeemed).where((each) => each.id == code.id).firstOrNull;
      emit(state.copyWith(
        revoking: false,
        redeemed: () => RedeemedWhileRevoking(
          code: code.shown,
          redeemedBy: used?.redeemedBy,
          redeemedAt: used?.redeemedAt ?? failure.redeemedAt,
        ),
      ));
    } on CodeNotAvailable {
      await load();
      if (!isClosed) emit(state.copyWith(revoking: false, notAvailable: true));
    } on CooperativeFailure catch (failure) {
      if (!isClosed) emit(state.copyWith(revoking: false, failure: () => failure));
    }
  }

  void dismissRedeemed() => emit(state.copyWith(redeemed: () => null));

  void dismissNotAvailable() => emit(state.copyWith(notAvailable: false));

  @override
  Future<void> close() {
    _notice?.cancel();
    return super.close();
  }
}
