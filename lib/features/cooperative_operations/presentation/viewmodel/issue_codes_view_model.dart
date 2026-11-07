import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viora/features/cooperative_operations/application/usecase/get_license_capacity_use_case.dart';
import 'package:viora/features/cooperative_operations/application/usecase/issue_invitation_codes_use_case.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/presentation/state/issue_codes_ui_state.dart';

/// G43 · Generar códigos. Starts from the hectares the license suggests and five codes (or
/// the free seats, when fewer). The steppers may go over what is free: the sheet then says
/// why and doesn't let the codes be issued.
class IssueCodesViewModel extends Cubit<IssueCodesUiState> {
  IssueCodesViewModel({
    required LicenseCapacity capacity,
    required this.issueCodes,
    required this.getCapacity,
  }) : super(IssueCodesUiState(
          capacity: capacity,
          quantity: math.max(1, math.min(_initialQuantity, capacity.seatsFree)),
          hectaresPerCode: _initialHectares(capacity),
        ));

  static const _initialQuantity = 5;

  /// One hectare at a time, as in the design; the suggestion may come with decimals.
  static const hectareStep = 1.0;

  final IssueInvitationCodesUseCase issueCodes;
  final GetLicenseCapacityUseCase getCapacity;

  static double _initialHectares(LicenseCapacity capacity) {
    final suggested = capacity.suggestedHectaresPerCode;
    return suggested > 0 ? suggested : hectareStep;
  }

  void increaseQuantity() => emit(state.copyWith(quantity: state.quantity + 1, failure: () => null));

  void decreaseQuantity() {
    if (state.quantity > 1) emit(state.copyWith(quantity: state.quantity - 1, failure: () => null));
  }

  void increaseHectares() =>
      emit(state.copyWith(hectaresPerCode: state.hectaresPerCode + hectareStep, failure: () => null));

  void decreaseHectares() {
    final lower = state.hectaresPerCode - hectareStep;
    if (lower > 0) emit(state.copyWith(hectaresPerCode: lower, failure: () => null));
  }

  void selectValidity(int days) => emit(state.copyWith(validityDays: days));

  Future<void> issue() async {
    if (!state.canIssue) return;
    emit(state.copyWith(issuing: true, failure: () => null));
    try {
      final issued = await issueCodes.execute(
        quantity: state.quantity,
        hectaresPerCode: state.hectaresPerCode,
        validityDays: state.validityDays,
      );
      if (!isClosed) emit(state.copyWith(issuing: false, issued: issued));
    } on CooperativeFailure catch (failure) {
      // Someone else used the seats meanwhile: show what is free now, and the sheet says why.
      final capacity = failure is NotEnoughSeats || failure is NotEnoughArea ? await _freshCapacity() : null;
      if (!isClosed) emit(state.copyWith(issuing: false, capacity: capacity, failure: () => failure));
    }
  }

  Future<LicenseCapacity?> _freshCapacity() async {
    try {
      return await getCapacity.execute();
    } on CooperativeFailure {
      return null;
    }
  }
}
