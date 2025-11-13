
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/todo.dart';
import '../service/api_service.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final ApiService apiService;

  TodoBloc(this.apiService) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<MarkTodoDone>(_onMarkTodoDone); // NEW EVENT
  }

  // Load todos from API
  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await apiService.fetchTodos();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to load todos: $e'));
    }
  }

  // Add a new todo
  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        // Generate unique ID for dummy API
        final newId = currentState.todos.isNotEmpty
            ? currentState.todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1
            : 1;

        final newTodo = Todo(
          id: newId,
          title: event.title,
          completed: false,
        );

        // Optional: call API if needed
        await apiService.addTodo(event.title);

        emit(TodoLoaded([...currentState.todos, newTodo]));
      } catch (e) {
        emit(TodoError('Failed to add todo: $e'));
      }
    }
  }

  // Delete a todo
  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      try {
        await apiService.deleteTodo(event.id);
        final updatedTodos =
            currentState.todos.where((todo) => todo.id != event.id).toList();
        emit(TodoLoaded(updatedTodos));
      } catch (e) {
        emit(TodoError('Failed to delete todo: $e'));
      }
    }
  }

  // MARK TASK AS DONE (Pomodoro completion)
  Future<void> _onMarkTodoDone(MarkTodoDone event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;

      final updatedTodos = currentState.todos.map((todo) {
        if (todo.id == event.id) {
          return Todo(
            id: todo.id,
            title: todo.title,
            completed: true, // mark as done
          );
        } else {
          return todo;
        }
      }).toList();

      emit(TodoLoaded(updatedTodos));
    }
  }
}
