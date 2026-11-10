import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/provisional_dossier_dto.dart';

/// The provisional dossier of a member plot, as JSON or as a PDF.
class DossierApi {
  const DossierApi({required this.client});

  final ApiClient client;

  Future<ProvisionalDossierDto> provisional(String plotId) async =>
      ProvisionalDossierDto.fromJson(await client.get('member-plots/$plotId/provisional-dossier'));

  Future<ApiFile> provisionalPdf(String plotId) =>
      client.getFile('member-plots/$plotId/provisional-dossier', accept: 'application/pdf');
}
