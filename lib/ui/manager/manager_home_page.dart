// =========================
// 14) lib/ui/manager/manager_home_page.dart
// =========================
import 'package:flutter/material.dart';
import '../../core/repository.dart';

class ManagerHomePage extends StatefulWidget {
  final AppRepository repo;
  const ManagerHomePage({super.key, required this.repo});

  @override
  State<ManagerHomePage> createState() => _ManagerHomePageState();
}

class _ManagerHomePageState extends State<ManagerHomePage> {
  final _url = TextEditingController();
  String? _status;

  @override
  void initState() {
    super.initState();
    _loadDefault();
  }

  Future<void> _loadDefault() async {
    _url.text = (await widget.repo.storage.getDefaultCsvUrl()) ?? '';
    if (mounted) setState(() {});
  }

  Future<void> _importUrl() async {
    setState(() => _status = '取り込み中...');
    final res = await widget.repo.importFromUrl(_url.text.trim());
    setState(() {
      _status = res.success
          ? '取り込み成功: ${res.importedCount}件'
          : '取り込み失敗: ${res.errorMessage}';
    });
  }

  void _backToGeneral() => Navigator.of(context).popUntil((r) => r.isFirst);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('統括（取り込み）')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('CSV公開リンク（URL）から取り込みます。'),
            const SizedBox(height: 12),
            TextField(
              controller: _url,
              decoration: const InputDecoration(
                labelText: 'CSV URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _importUrl, child: const Text('URLから取り込む')),
            const SizedBox(height: 12),

            // ステップ3（後で追加）
            OutlinedButton(
              onPressed: null, // TODO: file_picker導入後に実装
              child: const Text('ファイルから取り込む（未実装）'),
            ),

            if (_status != null) ...[
              const SizedBox(height: 12),
              Text(_status!),
            ],

            const Spacer(),
            OutlinedButton(onPressed: _backToGeneral, child: const Text('一般画面へ戻る')),
          ],
        ),
      ),
    );
  }
}