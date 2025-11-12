// lib/data/local/database/connection/web.dart
import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor constructDb() {
  print('🌐 Using WebDatabase for browser');
  return WebDatabase('todos_app_db', logStatements: true);
}