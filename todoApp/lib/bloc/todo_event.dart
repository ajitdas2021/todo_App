import '../model/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo(this.id);
}
class MarkTodoDone extends TodoEvent {
  final int id;
  MarkTodoDone(this.id);
}
