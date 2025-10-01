import 'package:equatable/equatable.dart';

class EditTodoEvent extends Equatable{
  const EditTodoEvent();
  @override
  List<Object?> get props => [];


}

class EditTitle extends EditTodoEvent{
  final String title;

  const EditTitle(this.title);

  @override
  List<Object?> get props => [title];
}

class EditDescription extends EditTodoEvent{
  final String description;

  const EditDescription(this.description);

  @override
  List<Object?> get props => [description];
}

class EditSubmit extends EditTodoEvent{
  const EditSubmit();
}