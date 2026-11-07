import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/domain/entity/producer_plan_catalog.dart';
import 'package:viora/features/subscription/domain/entity/producer_plan_offer.dart';
import 'package:viora/features/subscription/domain/exception/plan_catalog_failure.dart';
import 'package:viora/features/subscription/domain/repository/producer_plan_repository.dart';
import 'package:viora/features/subscription/infrastructure/remote/producer_plan_api.dart';

/// All offers are validated before the kept catalog is replaced.
class ProducerPlanRepositoryImpl implements ProducerPlanRepository {
  ProducerPlanRepositoryImpl({required this.api, DateTime Function()? now})
      : _now = now ?? DateTime.now;

  final ProducerPlanApi api;
  final DateTime Function() _now;

  ProducerPlanCatalog? _kept;

  @override
  ProducerPlanCatalog? kept() => _kept;

  @override
  Future<ProducerPlanCatalog> refresh() async {
    final List<ProducerPlanOffer> offers;
    try {
      offers = (await api.offers()).map((dto) => dto.toDomain()).toList();
    } on ApiUnreachableException {
      throw const PlanCatalogOffline();
    } on Object {
      // An error status, an unreadable answer or a plan the domain rejects.
      throw const PlanCatalogUnexpected();
    }
    if (offers.map((offer) => offer.code).toSet().length != offers.length) {
      throw const PlanCatalogUnexpected();
    }
    offers.sort((a, b) => a.code.value.compareTo(b.code.value));
    return _kept = ProducerPlanCatalog(offers: offers, fetchedAt: _now());
  }
}
