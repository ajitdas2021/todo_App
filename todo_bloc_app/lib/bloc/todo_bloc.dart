// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../model/todo.dart';
// import '../service/api_service.dart';
// import 'todo_event.dart';
// import 'todo_state.dart';

// class TodoBloc extends Bloc<TodoEvent, TodoState> {
//   final ApiService apiService;

//   TodoBloc(this.apiService) : super(TodoInitial()) {
//     on<LoadTodos>(_onLoadTodos);
//     on<AddTodo>(_onAddTodo);
//     on<DeleteTodo>(_onDeleteTodo);
//   }

//   Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
//     emit(TodoLoading());
//     try {
//       final todos = await apiService.fetchTodos();
//       emit(TodoLoaded(todos));
//     } catch (e) {
//       emit(TodoError('Failed to load todos: $e'));
//     }
//   }

//   Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
//     if (state is TodoLoaded) {
//       final currentState = state as TodoLoaded;
//       try {
//         final newTodo = await apiService.addTodo(event.title);
//         emit(TodoLoaded([...currentState.todos, newTodo]));
//       } catch (e) {
//         emit(TodoError('Failed to add todo: $e'));
//       }
//     }
//   }

//   Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
//     if (state is TodoLoaded) {
//       final currentState = state as TodoLoaded;
//       try {
//         await apiService.deleteTodo(event.id);
//         final updatedTodos =
//             currentState.todos.where((todo) => todo.id != event.id).toList();
//         emit(TodoLoaded(updatedTodos));
//       } catch (e) {
//         emit(TodoError('Failed to delete todo: $e'));
//       }
//     }
//   }
// }
// lib/bloc/todo_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/todo.dart';
import '../data/repository/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc(this.repository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await repository.fetchTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos: $e'));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        final newTodo = await repository.addTodo(event.title);
        emit(TodoLoaded([...currentState.todos, newTodo]));
      } catch (e) {
        emit(TodoError('Failed to add todo: $e'));
      }
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        await repository.deleteTodo(event.id);
        final updatedTodos =
            currentState.todos.where((todo) => todo.id != event.id).toList();
        emit(TodoLoaded(updatedTodos));
      } catch (e) {
        emit(TodoError('Failed to delete todo: $e'));
      }
    }
  }
}
