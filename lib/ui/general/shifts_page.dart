import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ShiftsPage extends StatefulWidget {
  final String studentId;
  const ShiftsPage({super.key, required this.studentId});

  @override
  State<ShiftsPage> createState() => _ShiftsPageState();
}

class _ShiftsPageState extends State<ShiftsPage> {
  bool loading = true;
  String? error;
  List<Map<String, String>> rows = [];

  @override
  void initState() {
    super.initState();
    _loadCsv();
  }

  Future<void> _loadCsv() async {
    try {
      final raw = await rootBundle.loadString('assets/sample_assignments.csv');

      // 改行で行に分割（空行除外）
      final lines = raw.split(RegExp(r'\r\n|\n|\r')).where((l) => l.trim().isNotEmpty).toList();
      if (lines.isEmpty) throw Exception('CSVが空です');

      // 区切り文字：カンマ or タブの両対応（手元のCSVがタブ区切りの可能性があるため）
      final delimiter = lines.first.contains(',') ? ',' : '\t';

      final header = lines.first.split(delimiter).map((s) => s.trim()).toList();

      final parsed = <Map<String, String>>[];
      for (var i = 1; i < lines.length; i++) {
        final cols = lines[i].split(delimiter).map((s) => s.trim()).toList();
        if (cols.length < header.length) continue;

        final map = <String, String>{};
        for (var j = 0; j < header.length; j++) {
          map[header[j]] = cols[j];
        }
        parsed.add(map);
      }

      final filtered = parsed.where((r) => r['studentId'] == widget.studentId).toList();

      setState(() {
        rows = filtered;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('シフト一覧: ${widget.studentId}')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : (error != null)
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('読み込みエラー:\n$error'),
                )
              : (rows.isEmpty)
                  ? const Center(child: Text('該当するシフトが見つかりません'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final r = rows[index];
                        final date = r['dateISO'] ?? '';
                        final start = r['start'] ?? '';
                        final end = r['end'] ?? '';
                        return Card(
                          child: ListTile(
                            title: Text('$date  $start–$end'),
                            subtitle: Text('studentId: ${r['studentId'] ?? ''}'),
                          ),
                        );
                      },
                    ),
    );
  }
}
