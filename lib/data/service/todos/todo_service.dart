import 'package:login_todo/domain/repositories/todos/todo_repository.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class TodoService {
  final TodoRepository _repository;
  int _currentId = 0;

  TodoService(this._repository);

  Future<List<TodoModel>> loadTodos() async {
    final todos = await _repository.loadTodos();
    if (todos.isNotEmpty) {
      _currentId = todos.map((t) => t.id).reduce((a, b) => a > b ? a : b);
    }
    return todos;
  }

  Future<void> addTodos(
    String title,
    String description,
    List<TodoModel> current,
  ) async {
    _currentId++;
    final todo = TodoModel.create(_currentId, title, description);
    final newList = List<TodoModel>.from(current)..insert(0, todo);
    await _repository.saveTodos(newList);
  }

  Future<void> toggleTodo(int id, List<TodoModel> current) async {
    final newList = current
        .map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t)
        .toList();
    await _repository.saveTodos(newList);
  }

  Future<void> deleteTodo(int id, List<TodoModel> current) async {
    final newList = current.where((t) => t.id != id).toList();
    await _repository.saveTodos(newList);
  }

  Future<void> updateTodo(
    int id, {
    String? newTitle,
    String? newDescription,
    required List<TodoModel> current,
  }) async {
    final newList = current.map((t) {
      if (t.id != id) return t;
        return t.copyWith(
          title: newTitle ?? t.title,
          description: newDescription ?? t.description,
        );
    }).toList();

    await _repository.saveTodos(newList);
  }

  Future<void> clearCompleted(List<TodoModel> current) async {
    final newList = current.where((t) => !t.isCompleted).toList();
    await _repository.saveTodos(newList);
  }

  Future<void> saveAll(List<TodoModel> todo) => _repository.saveTodos(todo);

  Stream<List<TodoModel>> getTodos() {
    return _repository.getTodos();
  }
}
