import 'package:equatable/equatable.dart';
import 'package:login_todo/models/enums/todo_edit.dart';
import 'package:login_todo/models/todos/todo_model.dart';

class EditTodoState extends Equatable {
  final EditTodoStatus status;
  final TodoModel? initialTodo;
  final String title;
  final String description;

  const EditTodoState({
    this.status = EditTodoStatus.initial,
    this.initialTodo,
    this.title = '',
    this.description = '',
  });

  EditTodoState copyWith({
    EditTodoStatus? status,
    TodoModel? initialTodo,
    String? title,
    String? description,
}){
    return EditTodoState(
      status: status ?? this.status,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [status,initialTodo,title,description];
}
