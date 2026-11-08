import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

class GetRiskPlotsUseCase {
  const GetRiskPlotsUseCase({required this.repository});

  final RiskRepository repository;

  Future<List<RiskPlot>> execute({GeoCoordinate? origin}) => repository.plots(origin: origin);
}
