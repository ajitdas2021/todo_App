import 'package:dio/dio.dart';
import '../model/todo.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Todo>> fetchTodos() async {
    final response = await _dio.get(baseUrl);
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.take(10).map((e) => Todo.fromJson(e)).toList(); // limit to 10
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<Todo> addTodo(String title) async {
    final response = await _dio.post(baseUrl, data: {
      "title": title,
      "completed": false,
    });

    if (response.statusCode == 201) {
      return Todo.fromJson(response.data);
    } else {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await _dio.delete('$baseUrl/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
  
}
