import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// A code someone redeemed while the manager tried to revoke it (G42 · Código ya canjeado).
class RedeemedWhileRevoking {
  const RedeemedWhileRevoking({required this.code, required this.redeemedBy, required this.redeemedAt});

  final String code;
  final String? redeemedBy;
  final DateTime? redeemedAt;
}

/// G42 · Códigos: the three lists with their counts, and what revoking left to say.
class CodesUiState {
  const CodesUiState({
    this.loading = true,
    this.failure,
    this.capacity,
    this.tab = InvitationCodeFilter.available,
    this.codes = const {},
    this.revoking = false,
    this.revokedNotice = false,
    this.redeemed,
    this.notAvailable = false,
  });

  final bool loading;
  final CooperativeFailure? failure;
  final LicenseCapacity? capacity;
  final InvitationCodeFilter tab;
  final Map<InvitationCodeFilter, List<InvitationCode>> codes;
  final bool revoking;

  /// The "Código revocado" pill over the title, for a moment after a revocation.
  final bool revokedNotice;
  final RedeemedWhileRevoking? redeemed;

  /// The code had already expired or been revoked when the manager tried.
  final bool notAvailable;

  List<InvitationCode> of(InvitationCodeFilter filter) => codes[filter] ?? const [];

  /// The codes of the open tab, grouped by the batch they were issued in, newest batch first.
  List<List<InvitationCode>> get batches {
    final groups = <String, List<InvitationCode>>{};
    for (final code in of(tab)) {
      groups.putIfAbsent(code.batchId, () => []).add(code);
    }
    return groups.values.toList()..sort((a, b) => b.first.issuedAt.compareTo(a.first.issuedAt));
  }

  CodesUiState copyWith({
    bool? loading,
    CooperativeFailure? Function()? failure,
    LicenseCapacity? capacity,
    InvitationCodeFilter? tab,
    Map<InvitationCodeFilter, List<InvitationCode>>? codes,
    bool? revoking,
    bool? revokedNotice,
    RedeemedWhileRevoking? Function()? redeemed,
    bool? notAvailable,
  }) =>
      CodesUiState(
        loading: loading ?? this.loading,
        failure: failure != null ? failure() : this.failure,
        capacity: capacity ?? this.capacity,
        tab: tab ?? this.tab,
        codes: codes ?? this.codes,
        revoking: revoking ?? this.revoking,
        revokedNotice: revokedNotice ?? this.revokedNotice,
        redeemed: redeemed != null ? redeemed() : this.redeemed,
        notAvailable: notAvailable ?? this.notAvailable,
      );
}
