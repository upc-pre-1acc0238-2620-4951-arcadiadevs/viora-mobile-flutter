import 'package:viora/core/domain/decimal.dart';
import 'package:viora/features/subscription/domain/entity/producer_plan_offer.dart';
import 'package:viora/features/subscription/domain/exception/plan_catalog_failure.dart';
import 'package:viora/features/subscription/domain/valueobject/plan_capacity.dart';

/// Browsing an offer is separate from contracting it or authorizing access.
sealed class ProducerPlanUiState {
  const ProducerPlanUiState();
}

class ProducerPlanLoading extends ProducerPlanUiState {
  const ProducerPlanLoading();
}

/// Nothing kept and the first read failed.
class ProducerPlanFailed extends ProducerPlanUiState {
  const ProducerPlanFailed(this.failure);

  final PlanCatalogFailure failure;
}

/// The server answered with no plans.
class ProducerPlanEmpty extends ProducerPlanUiState {
  const ProducerPlanEmpty({required this.isRefreshing, this.failure});

  final bool isRefreshing;
  final PlanCatalogFailure? failure;
}

class ProducerPlanContent extends ProducerPlanUiState {
  const ProducerPlanContent({
    required this.offers,
    required this.selectedOffer,
    required this.capacity,
    required this.fetchedAt,
    required this.isRefreshing,
    required this.isSavedCopy,
    this.failure,
  });

  final List<ProducerPlanOffer> offers;
  final ProducerPlanOffer selectedOffer;
  final PlanCapacity capacity;
  final DateTime fetchedAt;
  final bool isRefreshing;

  /// The catalog shown is the kept one, not yet confirmed by this visit.
  final bool isSavedCopy;
  final PlanCatalogFailure? failure;

  PlanEstimate get estimate => selectedOffer.estimate(capacity);

  bool get canDecrease => capacity.hectares > selectedOffer.minimumQuota.hectares;

  Decimal get step => selectedOffer.quotaIncrement.hectares;
}
