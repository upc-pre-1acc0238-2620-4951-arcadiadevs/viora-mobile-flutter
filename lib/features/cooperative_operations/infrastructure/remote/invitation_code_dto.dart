import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';

/// A code as GET invitation-codes lists it.
class InvitationCodeDto {
  const InvitationCodeDto(this.json);

  factory InvitationCodeDto.fromJson(Map<String, dynamic> json) => InvitationCodeDto(json);

  final Map<String, dynamic> json;

  InvitationCode toDomain() {
    final redeemedAt = json['redeemedAt'] as String?;
    return InvitationCode(
      id: json['id'] as String,
      batchId: json['batchId'] as String? ?? '',
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      hectares: (json['hectares'] as num).toDouble(),
      status: InvitationCodeStatus.parse(json['status'] as String? ?? ''),
      code: json['code'] as String?,
      maskedCode: json['maskedCode'] as String? ?? '',
      redeemedBy: json['redeemedBy'] as String?,
      redeemedAt: redeemedAt == null ? null : DateTime.parse(redeemedAt),
    );
  }
}

/// The batch POST invitation-codes answers.
class IssuedCodesDto {
  const IssuedCodesDto(this.json);

  factory IssuedCodesDto.fromJson(Map<String, dynamic> json) => IssuedCodesDto(json);

  final Map<String, dynamic> json;

  IssuedCodes toDomain() => IssuedCodes(
        batchId: json['batchId'] as String,
        issuedAt: DateTime.parse(json['issuedAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
        hectaresPerCode: (json['hectaresPerCode'] as num).toDouble(),
        codes: [
          for (final code in (json['codes'] as List).whereType<Map<String, dynamic>>()) code['code'] as String,
        ],
      );
}

class IssueInvitationCodesRequestDto {
  const IssueInvitationCodesRequestDto({
    required this.quantity,
    required this.hectaresPerCode,
    required this.validityDays,
  });

  final int quantity;
  final double hectaresPerCode;
  final int validityDays;

  Map<String, dynamic> toMap() => {
        'quantity': quantity,
        'hectaresPerCode': hectaresPerCode,
        'validityDays': validityDays,
      };
}
