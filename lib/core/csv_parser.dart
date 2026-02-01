// =========================
// 7) lib/core/csv_parser.dart
// =========================
import 'package:csv/csv.dart';
import 'models.dart';

/// CSVテキスト -> Assignment[]
/// 必須列：studentId,dateISO,start,end
/// 任意列：bureau,place,role,memo
class CsvAssignmentParser {
  static List<Assignment> parse(String csvText) {
    final rows = const CsvToListConverter(eol: '\n').convert(csvText);
    if (rows.isEmpty) return [];

    final headers = rows.first.map((e) => e.toString().trim()).toList();
    int idxOf(String name) => headers.indexOf(name);

    final iStudent = idxOf('studentId');
    final iDate = idxOf('dateISO');
    final iStart = idxOf('start');
    final iEnd = idxOf('end');

    if ([iStudent, iDate, iStart, iEnd].any((i) => i < 0)) {
      throw FormatException('CSVヘッダに必須列がありません（studentId,dateISO,start,end）');
    }

    final iBureau = idxOf('bureau');
    final iPlace = idxOf('place');
    final iRole = idxOf('role');
    final iMemo = idxOf('memo');

    String pick(List row, int i) =>
        (i >= 0 && i < row.length) ? row[i].toString().trim() : '';

    final out = <Assignment>[];
    for (int r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.isEmpty) continue;

      final studentId = pick(row, iStudent);
      final dateISO = pick(row, iDate);
      final start = pick(row, iStart);
      final end = pick(row, iEnd);

      // 必須欠けはスキップ（MVP）
      if (studentId.isEmpty || dateISO.isEmpty || start.isEmpty || end.isEmpty) continue;

      out.add(Assignment(
        studentId: studentId,
        dateISO: dateISO,
        start: start,
        end: end,
        bureau: iBureau >= 0 ? pick(row, iBureau) : null,
        place: iPlace >= 0 ? pick(row, iPlace) : null,
        role: iRole >= 0 ? pick(row, iRole) : null,
        memo: iMemo >= 0 ? pick(row, iMemo) : null,
      ));
    }
    return out;
  }
}