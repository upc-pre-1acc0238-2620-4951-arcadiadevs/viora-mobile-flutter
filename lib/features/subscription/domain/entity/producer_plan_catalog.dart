import 'package:viora/features/subscription/domain/entity/producer_plan_offer.dart';

/// A successful empty catalog has a timestamp; a missing catalog is simply null.
final class ProducerPlanCatalog {
  const ProducerPlanCatalog({required this.offers, required this.fetchedAt});

  final List<ProducerPlanOffer> offers;
  final DateTime fetchedAt;
}
