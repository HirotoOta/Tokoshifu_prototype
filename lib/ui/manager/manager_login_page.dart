// =========================
// 13) lib/ui/manager/manager_login_page.dart
// =========================
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/repository.dart';
import 'manager_home_page.dart';

class ManagerLoginPage extends StatefulWidget {
  final AppRepository repo;
  const ManagerLoginPage({super.key, required this.repo});

  @override
  State<ManagerLoginPage> createState() => _ManagerLoginPageState();
}

class _ManagerLoginPageState extends State<ManagerLoginPage> {
  final _pw = TextEditingController();
  String? _error;

  void _login() {
    // MVP：固定パスワード
    final ok = _pw.text.trim() == AppConstants.defaultManagerPassword;
    if (!ok) {
      setState(() => _error = 'パスワードが違います');
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ManagerHomePage(repo: widget.repo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('統括ログイン')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '統括パスワード',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _login, child: const Text('ログイン')),
            ),
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