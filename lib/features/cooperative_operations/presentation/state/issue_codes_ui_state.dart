import 'package:viora/features/cooperative_operations/domain/entity/invitation_code.dart';
import 'package:viora/features/cooperative_operations/domain/entity/license_capacity.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';

/// G43 · Generar códigos: how many, how many hectares each and for how long, checked against
/// what the license has free before anything is sent.
class IssueCodesUiState {
  const IssueCodesUiState({
    required this.capacity,
    required this.quantity,
    required this.hectaresPerCode,
    this.validityDays = 30,
    this.issuing = false,
    this.failure,
    this.issued,
  });

  static const validities = [7, 15, 30];

  final LicenseCapacity capacity;
  final int quantity;
  final double hectaresPerCode;
  final int validityDays;
  final bool issuing;
  final CooperativeFailure? failure;

  /// Set once the server issued the codes: the sheet then opens G44.
  final IssuedCodes? issued;

  double get totalHectares => quantity * hectaresPerCode;

  /// G43 · Cupo excedido.
  bool get exceedsSeats => quantity > capacity.seatsFree;

  /// G43 · Hectáreas insuficientes. A cent of slack keeps rounding from blocking a fair batch.
  bool get exceedsArea => totalHectares > capacity.freeAreaHa + 0.005;

  bool get canIssue => quantity > 0 && hectaresPerCode > 0 && !exceedsSeats && !exceedsArea && !issuing;

  /// Whether the hectares are the ones the license suggests.
  bool get hectaresSuggested => (hectaresPerCode - capacity.suggestedHectaresPerCode).abs() < 0.005;

  DateTime expiresOn(DateTime now) => now.add(Duration(days: validityDays));

  IssueCodesUiState copyWith({
    LicenseCapacity? capacity,
    int? quantity,
    double? hectaresPerCode,
    int? validityDays,
    bool? issuing,
    CooperativeFailure? Function()? failure,
    IssuedCodes? issued,
  }) =>
      IssueCodesUiState(
        capacity: capacity ?? this.capacity,
        quantity: quantity ?? this.quantity,
        hectaresPerCode: hectaresPerCode ?? this.hectaresPerCode,
        validityDays: validityDays ?? this.validityDays,
        issuing: issuing ?? this.issuing,
        failure: failure != null ? failure() : this.failure,
        issued: issued ?? this.issued,
      );
}
