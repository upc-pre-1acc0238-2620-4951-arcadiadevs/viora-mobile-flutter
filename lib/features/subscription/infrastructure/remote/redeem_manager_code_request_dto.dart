import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';

class RedeemManagerCodeRequestDto {
  const RedeemManagerCodeRequestDto({required this.code});

  factory RedeemManagerCodeRequestDto.fromDomain(ManagerCode code) =>
      RedeemManagerCodeRequestDto(code: code.value);

  final String code;

  Map<String, dynamic> toMap() => {'code': code};
}
