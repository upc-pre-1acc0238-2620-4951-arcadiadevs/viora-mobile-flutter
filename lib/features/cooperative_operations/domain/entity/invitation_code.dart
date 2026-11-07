/// Where a code stands. A closed code is [expired] or [revoked].
enum InvitationCodeStatus {
  available,
  redeemed,
  expired,
  revoked;

  static InvitationCodeStatus parse(String value) => switch (value) {
        'REDEEMED' => redeemed,
        'EXPIRED' => expired,
        'REVOKED' => revoked,
        _ => available,
      };
}

/// The lists of G42: codes to redeem, redeemed ones and closed ones.
enum InvitationCodeFilter {
  available('available'),
  redeemed('redeemed'),
  closed('closed');

  const InvitationCodeFilter(this.query);

  /// The value the server reads in `?status=`.
  final String query;
}

/// A code the manager issued for one producer. [code] comes in full only while it can be
/// redeemed, so it can be shared again; afterwards only [maskedCode] is left.
class InvitationCode {
  const InvitationCode({
    required this.id,
    required this.batchId,
    required this.issuedAt,
    required this.expiresAt,
    required this.hectares,
    required this.status,
    required this.code,
    required this.maskedCode,
    required this.redeemedBy,
    required this.redeemedAt,
  });

  final String id;
  final String batchId;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final double hectares;
  final InvitationCodeStatus status;
  final String? code;
  final String maskedCode;

  /// The producer who used it, once redeemed.
  final String? redeemedBy;
  final DateTime? redeemedAt;

  /// What the screens show: the full code while it can be shared, the masked one after.
  String get shown => code ?? maskedCode;
}

/// Codes issued together (G44): they share their hectares and their end.
class IssuedCodes {
  const IssuedCodes({
    required this.batchId,
    required this.issuedAt,
    required this.expiresAt,
    required this.hectaresPerCode,
    required this.codes,
  });

  final String batchId;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final double hectaresPerCode;
  final List<String> codes;
}
