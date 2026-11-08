import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:viora/features/cooperative_operations/domain/entity/risk_plot.dart';
import 'package:viora/features/cooperative_operations/domain/repository/risk_repository.dart';

/// The GPS through geolocator. A failure of the phone reads as "no location": the map then shows
/// the whole valley instead of an error.
class DeviceLocationRepository implements LocationRepository {
  DeviceLocationRepository({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  static const _choiceKey = 'risk.location_choice';
  static const _timeout = Duration(seconds: 8);

  final FlutterSecureStorage _storage;
  ManagerLocation? _lastKnown;

  @override
  ManagerLocation? get lastKnown => _lastKnown;

  static bool _allows(LocationPermission permission) =>
      permission == LocationPermission.always || permission == LocationPermission.whileInUse;

  @override
  Future<bool> hasPermission() async {
    try {
      return _allows(await Geolocator.checkPermission());
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> requestPermission({required bool openSettings}) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        if (openSettings) await Geolocator.openAppSettings();
        return false;
      }
      return _allows(permission);
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<ManagerLocation?> current() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: _timeout),
      );
      return _lastKnown = ManagerLocation(
        coordinate: GeoCoordinate(position.longitude, position.latitude),
        accuracyMeters: position.accuracy,
      );
    } on Exception {
      // Without a fix in time (GPS off, indoors), fall back on the last place the phone knows.
      return _lastKnown = await _lastPlaceOfThePhone();
    }
  }

  Future<ManagerLocation?> _lastPlaceOfThePhone() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) return null;
      return ManagerLocation(
        coordinate: GeoCoordinate(position.longitude, position.latitude),
        accuracyMeters: position.accuracy,
      );
    } on Exception {
      return null;
    }
  }

  @override
  Future<LocationChoice?> choice() async {
    final saved = await _storage.read(key: _choiceKey);
    for (final choice in LocationChoice.values) {
      if (choice.name == saved) return choice;
    }
    return null;
  }

  @override
  Future<void> saveChoice(LocationChoice choice) => _storage.write(key: _choiceKey, value: choice.name);
}
