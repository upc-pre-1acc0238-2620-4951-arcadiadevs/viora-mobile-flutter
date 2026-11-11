import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_api.dart';

class IntakeRepositoryImpl implements IntakeRepository {
  const IntakeRepositoryImpl({required this.api});

  final IntakeApi api;

  @override
  Future<List<IntakeForecast>> campaigns() =>
      _call(() async => (await api.campaigns()).map((dto) => dto.toDomain()).toList());

  @override
  Future<IntakeForecast> campaign(int year) => _call(() async => (await api.campaign(year)).toDomain());

  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw CooperativeErrorMapper.read(error);
    }
  }
}
