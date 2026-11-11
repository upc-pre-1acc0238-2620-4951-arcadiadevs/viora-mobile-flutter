import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:viora/features/iam/application/usecase/is_signed_in_use_case.dart';
import 'package:viora/features/iam/domain/repository/auth_repository.dart';
import 'package:viora/features/subscription/application/usecase/refresh_license_use_case.dart';
import 'package:viora/features/subscription/application/usecase/watch_current_license_use_case.dart';
import 'package:viora/features/subscription/domain/entity/manager_license.dart';
import 'package:viora/features/subscription/domain/exception/license_failure.dart';
import 'package:viora/features/subscription/domain/repository/license_repository.dart';
import 'package:viora/features/subscription/presentation/viewmodel/license_guard_view_model.dart';

final _start = DateTime.utc(2026, 11, 6, 15);

ManagerLicense _license({required DateTime endsAt}) => ManagerLicense(
      id: 'license-1',
      organizationName: 'Cooperativa Olivar del Sur',
      seats: 60,
      contractedAreaHa: 200,
      startsAt: DateTime.utc(2026, 11, 5),
      endsAt: endsAt,
    );

class _FakeLicenses implements LicenseRepository {
  _FakeLicenses(this.current);

  ManagerLicense? current;
  LicenseFailure? refreshFailure;
  int refreshes = 0;
  final _changes = StreamController<ManagerLicense?>.broadcast();

  /// The kept license changes, as when the server's answer replaces it.
  void change(ManagerLicense? license) {
    current = license;
    _changes.add(license);
  }

  @override
  Stream<ManagerLicense?> watchCurrent() async* {
    yield current;
    yield* _changes.stream;
  }

  @override
  Future<ManagerLicense?> refresh() async {
    refreshes++;
    final failure = refreshFailure;
    if (failure != null) throw failure;
    return current;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAuth implements AuthRepository {
  bool signedIn = true;

  @override
  Future<bool> isSignedIn() async => signedIn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

LicenseGuardViewModel _guard(
  _FakeLicenses licenses,
  _FakeAuth auth,
  DateTime Function() now, {
  Future<void> Function()? onLicenseEnded,
}) =>
    LicenseGuardViewModel(
      watchLicense: WatchCurrentLicenseUseCase(repository: licenses),
      refreshLicense: RefreshLicenseUseCase(repository: licenses),
      isSignedIn: IsSignedInUseCase(repository: auth),
      onLicenseEnded: onLicenseEnded,
      now: now,
    );

void main() {
  test('the end of the license forgets what the phone kept of it, once', () async {
    var forgotten = 0;
    final licenses = _FakeLicenses(_license(endsAt: DateTime.utc(2028)));
    final guard = _guard(licenses, _FakeAuth(), () => _start, onLicenseEnded: () async => forgotten++);
    await pumpEventQueue();
    expect(forgotten, 0);

    licenses.change(null);
    await pumpEventQueue();
    licenses.change(null);
    await pumpEventQueue();

    expect(forgotten, 1);
    await guard.close();
  });

  test('a license in force keeps the manager in the app', () {
    fakeAsync((async) {
      final licenses = _FakeLicenses(_license(endsAt: _start.add(const Duration(days: 30))));
      final guard = _guard(licenses, _FakeAuth(), () => _start.add(async.elapsed));

      async.elapse(const Duration(days: 29));

      expect(guard.state, isFalse);
      guard.close();
    });
  });

  test('a license that runs out while the app is open sends the manager back', () {
    fakeAsync((async) {
      final licenses = _FakeLicenses(_license(endsAt: _start.add(const Duration(hours: 2))));
      final guard = _guard(licenses, _FakeAuth(), () => _start.add(async.elapsed));

      async.elapse(const Duration(hours: 1, minutes: 59));
      expect(guard.state, isFalse);

      async.elapse(const Duration(minutes: 1));
      expect(guard.state, isTrue);
      guard.close();
    });
  });

  test('a kept license that already ran out sends the manager back right away', () async {
    final licenses = _FakeLicenses(_license(endsAt: _start.subtract(const Duration(days: 1))));
    final guard = _guard(licenses, _FakeAuth(), () => _start);

    await pumpEventQueue();

    expect(guard.state, isTrue);
    await guard.close();
  });

  test('a license the server took away sends the signed-in manager back', () async {
    final licenses = _FakeLicenses(_license(endsAt: DateTime.utc(2028)));
    final guard = _guard(licenses, _FakeAuth(), () => _start);
    await pumpEventQueue();

    licenses.change(null);
    await pumpEventQueue();

    expect(guard.state, isTrue);
    await guard.close();
  });

  test('the license forgotten on sign-out does not send anyone to the license check', () async {
    final licenses = _FakeLicenses(_license(endsAt: DateTime.utc(2028)));
    final auth = _FakeAuth();
    final guard = _guard(licenses, auth, () => _start);
    await pumpEventQueue();

    auth.signedIn = false;
    licenses.change(null);
    await pumpEventQueue();

    expect(guard.state, isFalse);
    await guard.close();
  });

  test('a renewed license moves the end to its new date', () {
    fakeAsync((async) {
      final licenses = _FakeLicenses(_license(endsAt: _start.add(const Duration(hours: 1))));
      final guard = _guard(licenses, _FakeAuth(), () => _start.add(async.elapsed));
      async.flushMicrotasks();

      licenses.change(_license(endsAt: _start.add(const Duration(days: 365))));
      async.elapse(const Duration(hours: 2));

      expect(guard.state, isFalse);
      guard.close();
    });
  });

  test('back in the app, the license is read again; without a connection the kept one stays',
      () async {
    final licenses = _FakeLicenses(_license(endsAt: DateTime.utc(2028)));
    final guard = _guard(licenses, _FakeAuth(), () => _start);
    await pumpEventQueue();

    await guard.recheck();
    licenses.refreshFailure = const LicenseOffline();
    await guard.recheck();

    expect(licenses.refreshes, 2);
    expect(guard.state, isFalse);
    await guard.close();
  });
}
