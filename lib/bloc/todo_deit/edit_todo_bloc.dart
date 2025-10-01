import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_deit/edit_todo_event.dart';
import 'package:login_todo/bloc/todo_deit/edit_todo_state.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';
import 'package:login_todo/models/enums/todo_edit.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  final TodoService _service;

  EditTodoBloc({required TodoService service, required TodoModel? initialTodo})
    : _service = service,
      super(EditTodoState(
        initialTodo: initialTodo,
        title: initialTodo?.title ?? '',
        description: initialTodo?.description ?? '',
      )
      ){
    on<EditTitle>(_onEditTitle);
    on<EditDescription>(_onEditDescription);
    on<EditSubmit>(_onEditSubmit);
  }

  void _onEditTitle (EditTitle event, Emitter<EditTodoState> emit){
    emit(state.copyWith(title: event.title));
  }
  void _onEditDescription(EditDescription event, Emitter<EditTodoState> emit){
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onEditSubmit(
      EditSubmit event,
      Emitter<EditTodoState> emit,
      ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));

    final updatedTodo = (state.initialTodo ??
        TodoModel.create(0, state.title, state.description))
        .copyWith(
      title: state.title,
      description: state.description,
    );

    try {
      await _service.updateTodo(
        updatedTodo.id,
        newTitle: updatedTodo.title,
        newDescription: updatedTodo.description,
        current: await _service.loadTodos(),
      );
      emit(state.copyWith(status: EditTodoStatus.success, initialTodo: updatedTodo));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
