import 'package:equatable/equatable.dart';

import '../../models/enums/todo_type.dart';
import '../../models/todos/todo_model.dart';

abstract class TodoState extends Equatable {
  final TodoModel? lastDeletedTodo;
  const TodoState({this.lastDeletedTodo});


  @override
  List<Object?> get props => [lastDeletedTodo];
}

class TodosInitial extends TodoState {}

class TodosLoadInProgress extends TodoState {}

class TodosLoadFailure extends TodoState {
  final String message;

  const TodosLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class TodosLoadSuccess extends TodoState {
  final List<TodoModel> todos;
  final TodosViewFilter filter;

  const TodosLoadSuccess(
      this.todos, {
        this.filter = TodosViewFilter.all,
        super.lastDeletedTodo,
      });

  Iterable<TodoModel> get filteredTodos => filter.applyAll(todos);

  TodosLoadSuccess copyWith({
    List<TodoModel> Function()? todos,
    TodosViewFilter Function()? filter,
    TodoModel? Function()? lastDeletedTodo,
  }) {
    return TodosLoadSuccess(
      todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo: lastDeletedTodo != null
          ? lastDeletedTodo()
          : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [todos, filter, lastDeletedTodo];
}

