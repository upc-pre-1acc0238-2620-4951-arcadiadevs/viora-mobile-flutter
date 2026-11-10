import 'package:viora/features/cooperative_operations/domain/entity/sector_alert.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

class GetSectorAlertsUseCase {
  const GetSectorAlertsUseCase({required this.repository});

  final RiskRepository repository;

  Future<List<SectorAlert>> execute() => repository.alerts();
}
