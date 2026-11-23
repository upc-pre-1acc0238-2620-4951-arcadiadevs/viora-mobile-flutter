import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';

/// GET and PUT caliber-ranges.
class CaliberRangeApi {
  const CaliberRangeApi({required this.client});

  final ApiClient client;

  Future<List<CaliberRange>> ranges() async => (await client.getList('caliber-ranges')).map(_range).toList();

  Future<List<CaliberRange>> replace(List<CaliberRange> ranges) async => (await client.putList('caliber-ranges', {
        'ranges': [
          for (final range in ranges) {'minFruitsPerKg': range.minFruitsPerKg, 'maxFruitsPerKg': range.maxFruitsPerKg},
        ],
      }))
          .map(_range)
          .toList();

  static CaliberRange _range(Map<String, dynamic> json) => CaliberRange(
        minFruitsPerKg: (json['minFruitsPerKg'] as num).toInt(),
        maxFruitsPerKg: (json['maxFruitsPerKg'] as num).toInt(),
      );
}
