// =========================
// 6) lib/core/models.dart
// =========================
import 'dart:convert';

/// 1行=1割当
class Assignment {
  final String studentId; // 学籍番号（文字列として扱う）
  final String dateISO;   // YYYY-MM-DD
  final String start;     // HH:MM
  final String end;       // HH:MM

  // 任意列
  final String? bureau;
  final String? place;
  final String? role;
  final String? memo;

  const Assignment({
    required this.studentId,
    required this.dateISO,
    required this.start,
    required this.end,
    this.bureau,
    this.place,
    this.role,
    this.memo,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'dateISO': dateISO,
        'start': start,
        'end': end,
        'bureau': bureau,
        'place': place,
        'role': role,
        'memo': memo,
      };

  /// JSONから復元（値が int/double でも String に寄せる・null安全）
  static Assignment fromJson(Map<String, dynamic> json) => Assignment(
        studentId: _asString(json['studentId']) ?? '',
        dateISO: _asString(json['dateISO']) ?? '',
        start: _asString(json['start']) ?? '',
        end: _asString(json['end']) ?? '',
        bureau: _asString(json['bureau']),
        place: _asString(json['place']),
        role: _asString(json['role']),
        memo: _asString(json['memo']),
      );

  /// ちょっと便利：デバッグ出力用
  @override
  String toString() =>
      'Assignment(studentId=$studentId, dateISO=$dateISO, start=$start, end=$end, bureau=$bureau, place=$place, role=$role, memo=$memo)';

  static String? _asString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v;
    // 数値なども文字列化して扱う（CSV/JSON混在対策）
    return v.toString();
  }
}

class AssignmentCodec {
  static String encode(List<Assignment> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<Assignment> decode(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! List) return <Assignment>[];

  return decoded
      .where((e) => e is Map)
      .map((e) => Assignment.fromJson((e as Map).cast<String, dynamic>()))
      .toList();
}

}
