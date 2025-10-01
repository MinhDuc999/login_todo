import 'package:login_todo/models/todos/todo_model.dart';

abstract class TodoRepository{
  Future<List<TodoModel>> loadTodos();
  Future<void> saveTodos(List<TodoModel> todos);
  Stream<List<TodoModel>> getTodos();
}