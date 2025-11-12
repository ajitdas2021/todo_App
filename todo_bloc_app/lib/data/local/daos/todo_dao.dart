// lib/data/local/daos/todo_dao.dart
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../tables/todo_table.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [TodosTable])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(AppDatabase db) : super(db);

  // Get all todos (returns a stream for real-time updates)
  Stream<List<TodosTableData>> watchAllTodos() {
    return (select(todosTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  // Get all todos as a future (one-time fetch)
  Future<List<TodosTableData>> getAllTodos() {
    return (select(todosTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .get();
  }

  // Get a single todo by ID
  Future<TodosTableData?> getTodoById(int id) {
    return (select(todosTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Insert a new todo
  Future<int> insertTodo(TodosTableCompanion todo) {
    return into(todosTable).insert(todo);
  }

  // Update an existing todo
  Future<bool> updateTodo(TodosTableData todo) {
    return update(todosTable).replace(todo);
  }

  // Delete a todo by ID
  Future<int> deleteTodoById(int id) {
    return (delete(todosTable)..where((t) => t.id.equals(id))).go();
  }

  // Delete all todos
  Future<int> deleteAllTodos() {
    return delete(todosTable).go();
  }

  // Toggle todo completion status
  Future<bool> toggleTodoCompletion(int id) async {
    final todo = await getTodoById(id);
    if (todo != null) {
      return update(todosTable).replace(
        todo.copyWith(completed: !todo.completed),
      );
    }
    return false;
  }
}