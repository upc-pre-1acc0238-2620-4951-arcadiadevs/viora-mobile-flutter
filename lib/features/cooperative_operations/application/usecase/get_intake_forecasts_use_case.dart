import 'package:viora/features/cooperative_operations/domain/entity/intake_forecast.dart';
import 'package:viora/features/cooperative_operations/domain/repository/intake_repository.dart';

class GetIntakeForecastsUseCase {
  const GetIntakeForecastsUseCase({required this.repository});

  final IntakeRepository repository;

  Future<List<IntakeForecast>> execute() => repository.campaigns();
}

/// One campaign with its sectors, as G30 shows it.
class GetIntakeForecastUseCase {
  const GetIntakeForecastUseCase({required this.repository});

  final IntakeRepository repository;

  Future<IntakeForecast> execute(int campaignYear) => repository.campaign(campaignYear);
}
