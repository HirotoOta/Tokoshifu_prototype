// =========================
// 16) lib/ui/admin/admin_settings_page.dart
// =========================
import 'package:flutter/material.dart';
import '../../core/repository.dart';

class AdminSettingsPage extends StatefulWidget {
  final AppRepository repo;
  const AdminSettingsPage({super.key, required this.repo});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final _eventDate = TextEditingController();
  final _defaultUrl = TextEditingController();
  String? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _eventDate.text = (await widget.repo.storage.getEventDateISO()) ?? '';
    _defaultUrl.text = (await widget.repo.storage.getDefaultCsvUrl()) ?? '';
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    await widget.repo.storage.setEventDateISO(_eventDate.text.trim());
    await widget.repo.storage.setDefaultCsvUrl(_defaultUrl.text.trim());
    setState(() => _status = '保存しました');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('管理者設定')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('当日の日付（YYYY-MM-DD）と、統括用の既定CSV URLを設定します。'),
            const SizedBox(height: 12),
            TextField(
              controller: _eventDate,
              decoration: const InputDecoration(
                labelText: 'イベント当日（日付）',
                border: OutlineInputBorder(),
                hintText: '例: 2026-11-01',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _defaultUrl,
              decoration: const InputDecoration(
                labelText: '既定CSV URL',
                border: OutlineInputBorder(),
                hintText: '例: https://.../export?format=csv',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _save, child: const Text('保存')),
            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(_status!),
            ],
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}