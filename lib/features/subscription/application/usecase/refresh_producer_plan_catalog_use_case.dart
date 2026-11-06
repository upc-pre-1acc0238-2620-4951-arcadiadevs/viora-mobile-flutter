import 'package:viora/features/subscription/domain/entity/producer_plan_catalog.dart';
import 'package:viora/features/subscription/domain/repository/producer_plan_repository.dart';

class RefreshProducerPlanCatalogUseCase {
  const RefreshProducerPlanCatalogUseCase({required this.repository});

  final ProducerPlanRepository repository;

  Future<ProducerPlanCatalog> execute() => repository.refresh();
}
