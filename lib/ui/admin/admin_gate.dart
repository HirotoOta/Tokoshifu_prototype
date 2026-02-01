// =========================
// 15) lib/ui/admin/admin_gate.dart
// =========================
import 'package:flutter/material.dart';
import 'package:tokosai_shift_viewer/core/constants.dart';
import 'package:tokosai_shift_viewer/core/repository.dart';
import 'package:tokosai_shift_viewer/ui/admin/admin_settings_page.dart';

class AdminGate extends StatefulWidget {
  final AppRepository repo;
  const AdminGate({super.key, required this.repo});

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  final _pw = TextEditingController();
  String? _error;

  void _enter() {
    final ok = _pw.text.trim() == AppConstants.defaultAdminPassword;
    if (!ok) {
      setState(() => _error = 'パスワードが違います');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AdminSettingsPage(repo: widget.repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('開発者（管理者）')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '管理者パスワード',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: _enter, child: const Text('入る'))),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
    );
  }
}