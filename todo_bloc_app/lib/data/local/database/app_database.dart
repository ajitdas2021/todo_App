// lib/data/local/database/app_database.dart
import 'package:drift/drift.dart';
import '../tables/todo_table.dart';
import '../daos/todo_dao.dart';

// Conditional imports - Flutter will choose the right one
import 'connection/connection.dart'
    if (dart.library.js_interop) 'connection/web.dart'
    if (dart.library.io) 'connection/native.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TodosTable], daos: [TodoDao])
class AppDatabase extends _$AppDatabase {
  // Private constructor for singleton
  AppDatabase._privateConstructor() : super(constructDb()) {
    print('🗄️ AppDatabase initialized');
  }
  
  static final AppDatabase _instance = AppDatabase._privateConstructor();
  
  // Factory constructor returns the same instance
  factory AppDatabase() => _instance;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        print('📊 Creating database tables...');
        await m.createAll();
        print('✅ Database tables created successfully!');
      },
      onUpgrade: (Migrator m, int from, int to) async {
        print('⬆️ Upgrading database from version $from to $to');
      },
    );
  }
}