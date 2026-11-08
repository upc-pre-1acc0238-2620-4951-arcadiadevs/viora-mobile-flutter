import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

class HasActiveSectorAlertsUseCase {
  const HasActiveSectorAlertsUseCase({required this.repository});

  final RiskRepository repository;

  Future<bool> execute() => repository.hasActiveAlerts();
}
