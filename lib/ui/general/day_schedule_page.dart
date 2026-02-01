// =========================
// 12) lib/ui/general/day_schedule_page.dart
// =========================
import 'package:flutter/material.dart';
import 'package:tokosai_shift_viewer/core/date_utils.dart';
import 'package:tokosai_shift_viewer/core/models.dart';
import 'package:tokosai_shift_viewer/core/repository.dart';

enum DayMode { eventDay, previousDay }

class DaySchedulePage extends StatefulWidget {
  final AppRepository repo;
  final String studentId;
  final DayMode initialMode;

  const DaySchedulePage({
    super.key,
    required this.repo,
    required this.studentId,
    required this.initialMode,
  });

  @override
  State<DaySchedulePage> createState() => _DaySchedulePageState();
}

class _DaySchedulePageState extends State<DaySchedulePage> {
  late DayMode _mode;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  Future<_ScheduleView> _load() async {
    final eventDateISO = await widget.repo.storage.getEventDateISO() ?? '2026-11-01';
    final prevISO = DateUtilsEx.previousDayISO(eventDateISO);
    final targetISO = (_mode == DayMode.eventDay) ? eventDateISO : prevISO;

    final all = await widget.repo.loadStoredAssignments();

    // 自分だけ（R1=A）
    final mine =
        all.where((a) => a.studentId == widget.studentId && a.dateISO == targetISO).toList();

    // start -> end でソート
    mine.sort((a, b) {
      final s = a.start.compareTo(b.start);
      return s != 0 ? s : a.end.compareTo(b.end);
    });

    return _ScheduleView(targetISO: targetISO, items: mine);
  }

  void _toggleDay() {
    setState(() {
      _mode = (_mode == DayMode.eventDay) ? DayMode.previousDay : DayMode.eventDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = (_mode == DayMode.eventDay) ? '当日' : '前日';
    final toggleLabel = (_mode == DayMode.eventDay) ? '前日へ' : '当日へ';

    return Scaffold(
      appBar: AppBar(
        title: Text('$title（${widget.studentId}）'),
        actions: [
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
            tooltip: '更新',
          ),
        ],
      ),
      body: FutureBuilder<_ScheduleView>(
        future: _load(),
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '読み込みエラー: ${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final view = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1ボタンで前日/当日切替（要件）
                FilledButton(onPressed: _toggleDay, child: Text(toggleLabel)),
                const SizedBox(height: 12),
                Text('表示日: ${view.targetISO}'),
                const SizedBox(height: 12),
                Expanded(
                  child: view.items.isEmpty
                      ? const Center(child: Text('シフトが見つかりません'))
                      : ListView.separated(
                          itemCount: view.items.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, i) {
                            final a = view.items[i];
                            final subtitle = [
                              if ((a.place ?? '').isNotEmpty) a.place!,
                              if ((a.role ?? '').isNotEmpty) a.role!,
                              if ((a.bureau ?? '').isNotEmpty) a.bureau!,
                            ].join(' / ');

                            return ListTile(
                              title: Text('${a.start} - ${a.end}'),
                              subtitle: subtitle.isEmpty ? null : Text(subtitle),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ScheduleView {
  final String targetISO;
  final List<Assignment> items;
  _ScheduleView({required this.targetISO, required this.items});
}
