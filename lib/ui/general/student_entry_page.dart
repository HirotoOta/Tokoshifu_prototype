// lib/ui/general/student_entry_page.dart
import 'package:flutter/material.dart';
import '../../core/repository.dart';

class StudentEntryPage extends StatefulWidget {
  final AppRepository repo;
  const StudentEntryPage({super.key, required this.repo});

  @override
  State<StudentEntryPage> createState() => _StudentEntryPageState();
}

class _StudentEntryPageState extends State<StudentEntryPage> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('学籍番号入力')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('学籍番号を入力してください'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '例: 1J24F034',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // いまはダミー：入力値を表示するだけ
                final id = controller.text.trim();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('入力: $id')),
                );
              },
              child: const Text('確認'),
            ),
          ],
        ),
      ),
    );
  }
}
