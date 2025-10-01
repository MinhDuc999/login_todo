import 'dart:async';
import 'dart:convert';
import 'package:login_todo/models/todos/todo_model.dart';
import '../../../domain/repositories/todos/todo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepositoryImpl implements TodoRepository {
  static const _kTodosKey = 'todos_list_v1';
  final SharedPreferences _prefs;
  final _controller = StreamController<List<TodoModel>>.broadcast();

  TodoRepositoryImpl(this._prefs);

  @override
  Future<List<TodoModel>> loadTodos() async {
    final raw = _prefs.getString(_kTodosKey);
    if(raw == null || raw.isEmpty) return [];
    try{
      final list = json.decode(raw) as List<dynamic>;
      return list.map((e) => TodoModel.fromJson(e as Map<String,dynamic>)).toList();
    } catch(_){
      return [];
    }
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final list = todos.map((t) => t.toJson()).toList();
    await _prefs.setString(_kTodosKey, json.encode(list));
    _controller.add(todos);
  }

  @override
  Stream<List<TodoModel>> getTodos() {
    loadTodos().then((value) => _controller.add(value));
    return _controller.stream;
  }
}