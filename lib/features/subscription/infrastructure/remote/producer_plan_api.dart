import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/infrastructure/remote/producer_plan_offer_dto.dart';

class ProducerPlanApi {
  const ProducerPlanApi({required this.client});

  final ApiClient client;

  Future<List<ProducerPlanOfferDto>> offers() async =>
      (await client.getList('subscription-plans')).map(ProducerPlanOfferDto.fromJson).toList();
}
