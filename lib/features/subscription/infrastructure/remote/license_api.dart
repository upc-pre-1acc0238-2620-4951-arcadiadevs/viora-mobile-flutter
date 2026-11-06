import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/infrastructure/remote/manager_license_dto.dart';
import 'package:viora/features/subscription/infrastructure/remote/redeem_manager_code_request_dto.dart';

class LicenseApi {
  const LicenseApi({required this.client});

  final ApiClient client;

  /// The licenses the signed-in manager is in charge of: one at most.
  Future<List<ManagerLicenseDto>> managed() async =>
      (await client.getList('cooperative-licenses')).map(ManagerLicenseDto.fromJson).toList();

  Future<ManagerLicenseDto> redeem(RedeemManagerCodeRequestDto request) async =>
      ManagerLicenseDto.fromJson(await client.post('manager-code-redemptions', request.toMap()));
}
