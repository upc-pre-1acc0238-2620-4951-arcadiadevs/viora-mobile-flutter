import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/cooperative_operations/domain/entity/caliber_range.dart';
import 'package:viora/features/cooperative_operations/domain/exception/cooperative_failure.dart';
import 'package:viora/features/cooperative_operations/domain/repository/caliber_range_repository.dart';
import 'package:viora/features/cooperative_operations/infrastructure/mapper/cooperative_error_mapper.dart';
import 'package:viora/features/cooperative_operations/infrastructure/remote/caliber_range_api.dart';

class CaliberRangeRepositoryImpl implements CaliberRangeRepository {
  const CaliberRangeRepositoryImpl({required this.api});

  final CaliberRangeApi api;

  @override
  Future<List<CaliberRange>> ranges() => _call(api.ranges, CooperativeErrorMapper.read);

  @override
  Future<List<CaliberRange>> replace(List<CaliberRange> ranges) =>
      _call(() => api.replace(ranges), CooperativeErrorMapper.caliber);

  Future<T> _call<T>(Future<T> Function() request, CooperativeFailure Function(ApiException) map) async {
    try {
      return await request();
    } on ApiUnreachableException {
      throw const CooperativeOffline();
    } on ApiException catch (error) {
      throw map(error);
    }
  }
}
