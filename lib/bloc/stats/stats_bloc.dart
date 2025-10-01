import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/stats/stats_event.dart';
import 'package:login_todo/bloc/stats/stats_state.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';
import 'package:login_todo/models/enums/stats.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final TodoService _todoService;

  StatsBloc({required TodoService todoService})
    : _todoService = todoService,
      super(const StatsState()) {
    on<StatsRequested>(_onRequested);
  }

  Future<void> _onRequested(
    StatsRequested event,
    Emitter<StatsState> emit,
  ) async {
    emit(state.copyWith(status: StatsStatus.loading));
    await emit.forEach<List<TodoModel>>(
      _todoService.getTodos(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        completed: todos.where((todo) => todo.isCompleted).length,
        active: todos.where((todo) => !todo.isCompleted).length,
      ),
      onError: (_, _) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
