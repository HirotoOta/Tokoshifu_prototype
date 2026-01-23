// =========================
// 4) lib/app.dart
// =========================
import 'package:flutter/material.dart';
import 'core/repository.dart';
import 'ui/general/student_entry_page.dart';

class TokosaiApp extends StatelessWidget {
  const TokosaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 後でProvider/RiverpodにしてもOK。MVPは直渡しで十分。
    final repo = AppRepository();

    return MaterialApp(
      title: 'とこ祭シフト確認',
      theme: ThemeData(useMaterial3: true),
      home: StudentEntryPage(repo: repo),
    );
  }
}
