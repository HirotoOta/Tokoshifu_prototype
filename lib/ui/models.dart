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

  static Assignment fromJson(Map<String, dynamic> json) => Assignment(
    studentId: json['studentId'] as String,
    dateISO: json['dateISO'] as String,
    start: json['start'] as String,
    end: json['end'] as String,
    bureau: json['bureau'] as String?,
    place: json['place'] as String?,
    role: json['role'] as String?,
    memo: json['memo'] as String?,
  );
}

class AssignmentCodec {
  static String encode(List<Assignment> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<Assignment> decode(String raw) {
    final list = (jsonDecode(raw) as List).cast<dynamic>();
    return list
        .map((e) => Assignment.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }
}
