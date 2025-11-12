// lib/data/local/database/connection/native.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor constructDb() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todos_app.db'));
    print('📁 Database path: ${file.path}');
    return NativeDatabase(file, logStatements: true);
  });
}