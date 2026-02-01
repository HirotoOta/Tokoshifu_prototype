// =========================
// 11) lib/ui/general/student_entry_page.dart
// =========================
import 'package:flutter/material.dart';
import 'package:tokosai_shift_viewer/core/repository.dart';
import 'package:tokosai_shift_viewer/ui/admin/admin_gate.dart';
import 'package:tokosai_shift_viewer/ui/manager/manager_login_page.dart';
import 'package:tokosai_shift_viewer/ui/general/day_schedule_page.dart';


class StudentEntryPage extends StatefulWidget {
  final AppRepository repo;
  const StudentEntryPage({super.key, required this.repo});

  @override
  State<StudentEntryPage> createState() => _StudentEntryPageState();
}

class _StudentEntryPageState extends State<StudentEntryPage> {
  final _controller = TextEditingController();
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await widget.repo.ensureDefaults();

    // 学籍番号の復元
    final last = await widget.repo.storage.getLastStudentId();
    if (last != null && last.isNotEmpty) _controller.text = last;

    // 初回はサンプルCSVで動くようにする（ステップ1の成功体験最優先）
    final stored = await widget.repo.loadStoredAssignments();
    if (stored.isEmpty) {
      final sample = await widget.repo.loadSampleAssignments();
      await widget.repo.storage.setAssignments(sample);
      await widget.repo.storage.setLastUpdatedAt('sample');
    }

    if (mounted) setState(() {});
  }

  void _onTitleTap() {
    _tapCount += 1;
    if (_tapCount >= 7) {
      _tapCount = 0;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AdminGate(repo: widget.repo),
      ));
    }
  }

  Future<void> _confirm() async {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('学籍番号を入力してください')),
      );
      return;
    }
    await widget.repo.storage.setLastStudentId(id);

    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DaySchedulePage(
        repo: widget.repo,
        studentId: id,
        initialMode: DayMode.eventDay, // 起動後は当日（B1=B）
      ),
    ));
  }

  void _openManager() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ManagerLoginPage(repo: widget.repo),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(onTap: _onTitleTap, child: const Text('シフト確認')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '学籍番号',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _confirm,
                child: const Text('確認する'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: _openManager, child: const Text('統括ログイン')),
            const Spacer(),
            FutureBuilder<String?>(
              future: widget.repo.storage.getLastUpdatedAt(),
              builder: (_, snap) => Text(
                '最終更新: ${snap.data ?? '(unknown)'}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}