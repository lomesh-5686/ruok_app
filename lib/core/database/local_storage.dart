import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class LocalStorage {
  Box? _box;

  Future<void> init() async {
    if (!Hive.isBoxOpen(AppConstants.appBoxName)) {
      _box = await Hive.openBox(AppConstants.appBoxName);
    } else {
      _box = Hive.box(AppConstants.appBoxName);
    }
  }

  Box get box {
    if (_box == null || !_box!.isOpen) {
      _box = Hive.box(AppConstants.appBoxName);
    }
    return _box!;
  }

  // --- Auth Session ---
  bool isLoggedIn() {
    return box.get(AppConstants.keyIsLoggedIn, defaultValue: false) as bool;
  }

  Future<void> saveUserSession({
    required String name,
    required String phone,
    required String countryCode,
  }) async {
    await box.put(AppConstants.keyIsLoggedIn, true);
    await box.put(AppConstants.keyUserName, name);
    await box.put(AppConstants.keyUserPhone, phone);
    await box.put(AppConstants.keyCountryCode, countryCode);
  }

  String getUserName() => box.get(AppConstants.keyUserName, defaultValue: '') as String;
  String getUserPhone() => box.get(AppConstants.keyUserPhone, defaultValue: '') as String;
  String getCountryCode() => box.get(AppConstants.keyCountryCode, defaultValue: '+0123') as String;

  Future<void> clearSession() async {
    await box.clear();
  }

  // --- Safety Status ---
  String getSafetyStatus() {
    return box.get(AppConstants.keySafetyStatus, defaultValue: AppConstants.statusIdle) as String;
  }

  Future<void> setSafetyStatus(String status) async {
    await box.put(AppConstants.keySafetyStatus, status);
  }

  // --- Shift Timestamps ---
  int? getShiftEndTime() {
    return box.get(AppConstants.keyShiftEndTime) as int?;
  }

  Future<void> setShiftEndTime(int endTimeEpochMs) async {
    await box.put(AppConstants.keyShiftEndTime, endTimeEpochMs);
  }

  Future<void> clearShiftEndTime() async {
    await box.delete(AppConstants.keyShiftEndTime);
  }

  // --- Alert Timestamps ---
  int? getAlertEndTime() {
    return box.get(AppConstants.keyAlertEndTime) as int?;
  }

  Future<void> setAlertEndTime(int endTimeEpochMs) async {
    await box.put(AppConstants.keyAlertEndTime, endTimeEpochMs);
  }

  Future<void> clearAlertEndTime() async {
    await box.delete(AppConstants.keyAlertEndTime);
  }

  // --- Incident Data ---
  Future<void> saveIncidentData({
    required int timestamp,
    required double latitude,
    required double longitude,
  }) async {
    await box.put(AppConstants.keyIncidentTimestamp, timestamp);
    await box.put(AppConstants.keyIncidentLatitude, latitude);
    await box.put(AppConstants.keyIncidentLongitude, longitude);
  }

  int? getIncidentTimestamp() => box.get(AppConstants.keyIncidentTimestamp) as int?;
  double? getIncidentLatitude() => box.get(AppConstants.keyIncidentLatitude) as double?;
  double? getIncidentLongitude() => box.get(AppConstants.keyIncidentLongitude) as double?;

  Future<void> resetToIdle() async {
    await setSafetyStatus(AppConstants.statusIdle);
    await clearShiftEndTime();
    await clearAlertEndTime();
  }
}
