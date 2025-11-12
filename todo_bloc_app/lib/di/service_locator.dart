// lib/di/service_locator.dart
import 'package:get_it/get_it.dart';
import '../data/local/database/app_database.dart';
import '../data/local/daos/todo_dao.dart';
import '../data/repository/todo_repository.dart';
import '../bloc/todo_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // Register Database as Singleton
  // The AppDatabase class itself uses singleton pattern internally
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // Register DAO as Singleton
  getIt.registerSingleton<TodoDao>(
    getIt<AppDatabase>().todoDao,
  );

  // Register Repository as Singleton
  getIt.registerSingleton<TodoRepository>(
    TodoRepository(getIt<TodoDao>()),
  );

  // Register BLoC as Factory (new instance each time needed)
  getIt.registerFactory<TodoBloc>(
    () => TodoBloc(getIt<TodoRepository>()),
  );
}

// Optional: Cleanup method for testing or app disposal
Future<void> resetLocator() async {
  await getIt.reset();
}