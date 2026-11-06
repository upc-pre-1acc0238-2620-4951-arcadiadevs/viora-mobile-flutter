import 'package:viora/core/datastore/session_store.dart';
import 'package:viora/core/network/api_client.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/domain/valueobject/manager_code.dart';
import 'package:viora/features/subscription/infrastructure/local/manager_license_dao.dart';
import 'package:viora/features/subscription/infrastructure/mapper/license_error_mapper.dart';
import 'package:viora/features/subscription/infrastructure/remote/license_api.dart';
import 'package:viora/features/subscription/infrastructure/remote/redeem_manager_code_request_dto.dart';

class LicenseRepositoryImpl implements LicenseRepository {
  const LicenseRepositoryImpl({required this.api, required this.dao, required this.sessionStore});

  final LicenseApi api;
  final ManagerLicenseDao dao;
  final SessionStore sessionStore;

  // Only the signed-in account's license: one kept for another account never shows.
  @override
  Stream<ManagerLicense?> watchCurrent() async* {
    final userId = await sessionStore.userId();
    if (userId == null) {
      yield null;
      return;
    }
    yield* dao.watch(userId);
  }

  @override
  Future<ManagerLicense?> kept() async {
    final userId = await sessionStore.userId();
    return userId == null ? null : dao.read(userId);
  }

  @override
  Future<ManagerLicense?> refresh() async {
    final userId = await sessionStore.userId();
    if (userId == null) return null;
    final List<ManagerLicense> licenses;
    try {
      licenses = (await api.managed()).map((dto) => dto.toDomain()).toList();
    } on ApiUnreachableException {
      throw const LicenseOffline();
    } on ApiException catch (error) {
      throw LicenseErrorMapper.refresh(error);
    }
    // A license the manager no longer holds, such as after a new manager took over, goes away.
    if (licenses.isEmpty) {
      await dao.forget(userId);
      return null;
    }
    await dao.keep(userId, licenses.first);
    return licenses.first;
  }

  @override
  Future<ManagerLicense> activate(ManagerCode code) async {
    final userId = await sessionStore.userId();
    if (userId == null) throw const LicenseUnexpected();
    final ManagerLicense license;
    try {
      license = (await api.redeem(RedeemManagerCodeRequestDto.fromDomain(code))).toDomain();
    } on ApiUnreachableException {
      throw const LicenseOffline();
    } on ApiException catch (error) {
      throw LicenseErrorMapper.activate(error);
    }
    await dao.keep(userId, license);
    return license;
  }

  @override
  Future<String?> accountEmail() => sessionStore.email();

  @override
  Future<void> clear() => dao.clear();
}
