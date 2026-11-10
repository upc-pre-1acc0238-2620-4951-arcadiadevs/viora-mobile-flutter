import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/provisional_dossier.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/dossier_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/dossier_api.dart';

class DossierRepositoryImpl implements DossierRepository {
  const DossierRepositoryImpl({required this.api});

  /// The name of the PDF when the server doesn't give one.
  static const _fallbackFileName = 'expediente-provisional.pdf';

  final DossierApi api;

  @override
  Future<ProvisionalDossier> provisional(String plotId) =>
      _call(() async => (await api.provisional(plotId)).toDomain());

  @override
  Future<DossierFile> provisionalPdf(String plotId) => _call(() async {
        final file = await api.provisionalPdf(plotId);
        return DossierFile(bytes: file.bytes, fileName: file.fileName ?? _fallbackFileName);
      });

  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw CooperativeErrorMapper.dossier(error);
    }
  }
}
