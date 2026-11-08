import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

class GetRiskPlotUseCase {
  const GetRiskPlotUseCase({required this.repository});

  final RiskRepository repository;

  Future<RiskPlotDetail> execute(String id) => repository.plot(id);
}
