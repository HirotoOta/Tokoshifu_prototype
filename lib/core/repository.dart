// =========================
// 10) lib/core/repository.dart
// =========================
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:tokosai_shift_viewer/core/constants.dart';
import 'package:tokosai_shift_viewer/core/csv_parser.dart';
import 'package:tokosai_shift_viewer/core/models.dart';
import 'package:tokosai_shift_viewer/core/storage.dart';

class AppRepository {
  final AppStorage storage = AppStorage();

  Future<void> ensureDefaults() async {
    final event = await storage.getEventDateISO();
    if (event == null || event.trim().isEmpty) {
      await storage.setEventDateISO(AppConstants.defaultEventDateISO);
    }

    final url = await storage.getDefaultCsvUrl();
    // null だけでなく空文字も初期化しておくと事故りにくい
    if (url == null || url.trim().isEmpty) {
      await storage.setDefaultCsvUrl(AppConstants.defaultCsvUrl);
    }
  }

  // ステップ1：assetsサンプル
  Future<List<Assignment>> loadSampleAssignments() async {
    final text = await rootBundle.loadString(AppConstants.sampleAssetCsvPath);
    return CsvAssignmentParser.parse(text);
  }

  // 一般画面はこれを読む（統括の取り込みが反映される）
  Future<List<Assignment>> loadStoredAssignments() async {
    return storage.getAssignments();
  }

  // ステップ2：URL取り込み
  Future<ImportResult> importFromUrl(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      return ImportResult.fail('URLが空です');
    }

    try {
      final uri = Uri.parse(trimmed);

      final res = await http.get(uri);
      if (res.statusCode != 200) {
        return ImportResult.fail('HTTP ${res.statusCode}: 取得に失敗しました');
      }

      // 文字化け等がある場合、ここを調整（Shift-JISなど）
      final text = utf8.decode(res.bodyBytes);

      final items = CsvAssignmentParser.parse(text);
      await storage.setAssignments(items);
      await storage.setLastUpdatedAt(DateTime.now().toIso8601String());

      return ImportResult.ok(items.length);
    } catch (e) {
      return ImportResult.fail('例外: $e');
    }
  }

  // ステップ3：ファイル取り込み（後で file_picker から bytes を渡す）
  Future<ImportResult> importFromFileBytes(List<int> bytes) async {
    try {
      final text = utf8.decode(bytes);
      final items = CsvAssignmentParser.parse(text);

      await storage.setAssignments(items);
      await storage.setLastUpdatedAt(DateTime.now().toIso8601String());

      return ImportResult.ok(items.length);
    } catch (e) {
      return ImportResult.fail('例外: $e');
    }
  }
}

class ImportResult {
  final bool success;
  final int importedCount;
  final String? errorMessage;

  const ImportResult._(this.success, this.importedCount, this.errorMessage);

  // ✅ Dartでは「static ImportResult.ok」みたいにドット付き定義はできない
  // 代わりに「ok」「fail」を普通の static メソッドにする
  static ImportResult ok(int c) => ImportResult._(true, c, null);
  static ImportResult fail(String m) => ImportResult._(false, 0, m);
}
