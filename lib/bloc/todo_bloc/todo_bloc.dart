import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState>{
  final TodoService _service;
  List<TodoModel> _cache = [];

  TodoBloc(this._service): super(TodosInitial()){
    on<TodoLoadRequested>(_onLoad);
    on<TodoAddRequested>(_onAdd);
    on<TodoToggleRequested>(_onToggle);
    on<TodoDeleteRequested>(_onDelete);
    on<TodoClearCompletedRequested>(_onClearCompleted);
    on<TodoUpdateRequested>(_onUpdate);
    on<TodoOverviewFilterChanged>(_onFilterChanged);
    on<TodoUndoDeletionRequested>(_onUndoDelete);
    on<TodoToggleAllRequested>(_onToggleAll);

  }

  Future<void> _onLoad(TodoLoadRequested event, Emitter<TodoState> emit) async{
    emit(TodosLoadInProgress());
    try{
      _cache = await _service.loadTodos();
      emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
    } catch (e){
      emit(TodosLoadFailure(e.toString()));
    }
  }

  Future<void> _onAdd(TodoAddRequested event, Emitter<TodoState> emit) async {
    await _service.addTodos(event.title, event.description, _cache);
    _cache = await _service.loadTodos();
    emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
  }

  Future<void> _onToggle(TodoToggleRequested event, Emitter<TodoState> emit) async {
    await _service.toggleTodo(event.id, _cache);
    _cache = await _service.loadTodos();
    emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
  }

  Future<void> _onDelete(
      TodoDeleteRequested event, Emitter<TodoState> emit) async {
    final todoToDelete = _cache.firstWhere((t) => t.id == event.id);
    await _service.deleteTodo(event.id, _cache);
    _cache = await _service.loadTodos();

    emit(TodosLoadSuccess(
      List<TodoModel>.from(_cache),
      lastDeletedTodo: todoToDelete,
    ));
  }

  Future<void> _onUndoDelete(
      TodoUndoDeletionRequested event, Emitter<TodoState> emit) async {
    if (state is TodosLoadSuccess) {
      final currentState = state as TodosLoadSuccess;
      final lastDeleted = currentState.lastDeletedTodo;
      if (lastDeleted != null) {
        await _service.addTodos(lastDeleted.title, lastDeleted.description, _cache);
        _cache = await _service.loadTodos();
        emit(currentState.copyWith(
          todos: () => List<TodoModel>.from(_cache),
          lastDeletedTodo: () => null,
        ));
      }
    }
  }


  Future<void> _onUpdate(TodoUpdateRequested event, Emitter<TodoState> emit) async{
    await _service.updateTodo(event.id,newTitle: event.newTitle, newDescription: event.newDescription, current: _cache);
    _cache = await _service.loadTodos();
    emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
  }

  Future<void> _onClearCompleted(TodoClearCompletedRequested event, Emitter<TodoState> emit) async {
    await _service.clearCompleted(_cache);
    _cache = await _service.loadTodos();
    emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
  }

  void _onFilterChanged(
      TodoOverviewFilterChanged event,
      Emitter<TodoState> emit,
      ) {
    if (state is TodosLoadSuccess) {
      final currentState = state as TodosLoadSuccess;
      emit(
        currentState.copyWith(
          filter: () => event.filter,
        ),
      );
    }
  }

  Future<void> _onToggleAll(
      TodoToggleAllRequested event,
      Emitter<TodoState> emit,
      ) async {
    final allCompleted = _cache.every((t) => t.isCompleted);
    final newList = _cache
        .map((t) => t.copyWith(isCompleted: !allCompleted))
        .toList();

    await _service.saveAll(newList);
    _cache = await _service.loadTodos();

    emit(TodosLoadSuccess(List<TodoModel>.from(_cache)));
  }



}