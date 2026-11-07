import 'package:viora/features/subscription/domain/entity/producer_plan_catalog.dart';

/// The offers of the Producer Plan, kept for as long as the app runs and updated on demand.
abstract class ProducerPlanRepository {
  /// The last catalog read successfully, without going to the server; null before the first.
  ProducerPlanCatalog? kept();

  /// Downloads the catalog and keeps it. Throws a PlanCatalogFailure when it can't, and the
  /// kept one stays.
  Future<ProducerPlanCatalog> refresh();
}
