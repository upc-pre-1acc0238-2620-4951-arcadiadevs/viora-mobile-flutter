import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/intake_forecast_dto.dart';

/// The intake of the license's campaigns.
class IntakeApi {
  const IntakeApi({required this.client});

  final ApiClient client;

  Future<List<IntakeForecastDto>> campaigns() async =>
      (await client.getList('intake-forecasts')).map(IntakeForecastDto.fromJson).toList();

  Future<IntakeForecastDto> campaign(int year) async =>
      IntakeForecastDto.fromJson(await client.get('intake-forecasts/$year'));
}
