
// lib/data/repository/todo_repository.dart
import 'package:drift/drift.dart';
import '../../model/todo.dart';
import '../local/daos/todo_dao.dart';
import '../local/database/app_database.dart';

class TodoRepository {
  final TodoDao _todoDao;

  TodoRepository(this._todoDao);

  // Fetch all todos (converts Drift entities to domain models)
  Future<List<Todo>> fetchTodos() async {
    try {
      final todosData = await _todoDao.getAllTodos();
      return todosData.map((data) => _mapToTodo(data)).toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  // Add a new todo
  Future<Todo> addTodo(String title) async {
    try {
      final companion = TodosTableCompanion.insert(
        title: title,
        completed: const Value(false),
        createdAt: Value(DateTime.now()),
      );
      
      final id = await _todoDao.insertTodo(companion);
      
      // Return the newly created todo
      return Todo(
        id: id,
        title: title,
        completed: false,
      );
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  // Delete a todo by ID
  Future<void> deleteTodo(int id) async {
    try {
      await _todoDao.deleteTodoById(id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  // Update todo completion status
  Future<Todo> toggleTodoCompletion(int id) async {
    try {
      await _todoDao.toggleTodoCompletion(id);
      final updatedTodo = await _todoDao.getTodoById(id);
      
      if (updatedTodo == null) {
        throw Exception('Todo not found after update');
      }
      
      return _mapToTodo(updatedTodo);
    } catch (e) {
      throw Exception('Failed to toggle todo: $e');
    }
  }

  // Delete all todos
  Future<void> deleteAllTodos() async {
    try {
      await _todoDao.deleteAllTodos();
    } catch (e) {
      throw Exception('Failed to delete all todos: $e');
    }
  }

  // Helper method to map Drift entity to domain model
  Todo _mapToTodo(TodosTableData data) {
    return Todo(
      id: data.id,
      title: data.title,
      completed: data.completed,
    );
  }

  // Watch todos stream (for real-time updates - optional)
  Stream<List<Todo>> watchTodos() {
    return _todoDao.watchAllTodos().map(
          (todosData) => todosData.map((data) => _mapToTodo(data)).toList(),
        );
  }
}