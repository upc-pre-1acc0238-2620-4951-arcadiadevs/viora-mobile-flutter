import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/profiles/infrastructure/remote/profile_dto.dart';
import 'package:viora/features/profiles/infrastructure/remote/update_profile_request_dto.dart';

class ProfileApi {
  const ProfileApi({required this.client});

  final ApiClient client;

  Future<ProfileDto> byUser(String userId) async =>
      ProfileDto.fromJson(await client.get('profiles/${Uri.encodeComponent(userId)}'));

  Future<ProfileDto> update(String userId, UpdateProfileRequestDto request) async => ProfileDto.fromJson(
        await client.put('profiles/${Uri.encodeComponent(userId)}', request.toMap()),
      );
}
