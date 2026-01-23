// =========================
// 5) lib/core/constants.dart
// =========================
class AppConstants {
  static const int adminTapCount = 7;

  // MVP用：固定パスワード（将来は管理者画面から変更できるようにしてもOK）
  static const String defaultManagerPassword = 'tokosai-admin';
  static const String defaultAdminPassword = 'only-me';

  // 管理者設定で上書き可能
  static const String defaultEventDateISO = '2026-11-01';
  static const String defaultCsvUrl = '';

  // ステップ1：サンプルCSV
  static const String sampleAssetCsvPath = 'assets/sample_assignments.csv';
}
