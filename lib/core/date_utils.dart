// =========================
// 8) lib/core/date_utils.dart
// =========================
import 'package:intl/intl.dart';

/// アプリ独自の日付ユーティリティ
/// ISO形式（yyyy-MM-dd）を前提とする
class DateUtilsEx {
  /// ISO文字列（yyyy-MM-dd）を DateTime に変換
  static DateTime parseISO(String iso) {
    return DateTime.parse(iso);
  }

  /// DateTime を ISO文字列（yyyy-MM-dd）に変換
  static String toISO(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  /// ISO日付を1日戻した ISO文字列を返す
  ///
  /// 例: '2026-11-01' -> '2026-10-31'
  static String previousDayISO(String eventDateISO) {
    final dt = parseISO(eventDateISO);
    final prev = dt.subtract(const Duration(days: 1));
    return toISO(prev);
  }
}
