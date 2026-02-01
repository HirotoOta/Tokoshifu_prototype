// =========================
// 9) lib/core/storage.dart
// =========================
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class StorageKeys {
  static const lastStudentId = 'lastStudentId';
  static const eventDateISO = 'eventDateISO';
  static const defaultCsvUrl = 'defaultCsvUrl';
  static const assignmentsJson = 'assignmentsJson';
  static const lastUpdatedAt = 'lastUpdatedAt';
}

class AppStorage {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<String?> getLastStudentId() async =>
      (await _prefs).getString(StorageKeys.lastStudentId);
  Future<void> setLastStudentId(String id) async =>
      (await _prefs).setString(StorageKeys.lastStudentId, id);

  Future<String?> getEventDateISO() async =>
      (await _prefs).getString(StorageKeys.eventDateISO);
  Future<void> setEventDateISO(String iso) async =>
      (await _prefs).setString(StorageKeys.eventDateISO, iso);

  Future<String?> getDefaultCsvUrl() async =>
      (await _prefs).getString(StorageKeys.defaultCsvUrl);
  Future<void> setDefaultCsvUrl(String url) async =>
      (await _prefs).setString(StorageKeys.defaultCsvUrl, url);

  Future<List<Assignment>> getAssignments() async {
    final raw = (await _prefs).getString(StorageKeys.assignmentsJson);
    if (raw == null || raw.isEmpty) return [];
    return AssignmentCodec.decode(raw);
  }

  Future<void> setAssignments(List<Assignment> items) async {
    await (await _prefs).setString(StorageKeys.assignmentsJson, AssignmentCodec.encode(items));
  }

  Future<String?> getLastUpdatedAt() async =>
      (await _prefs).getString(StorageKeys.lastUpdatedAt);
  Future<void> setLastUpdatedAt(String v) async =>
      (await _prefs).setString(StorageKeys.lastUpdatedAt, v);
}