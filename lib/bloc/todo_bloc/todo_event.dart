import 'package:equatable/equatable.dart';

import '../../models/enums/todo_type.dart';

abstract class TodoEvent extends Equatable{
  const TodoEvent();
  @override
  List<Object?> get props => [];
}

class TodoLoadRequested extends TodoEvent{
  const TodoLoadRequested();
  @override
  List<Object?> get props => [];
}

class TodoAddRequested extends TodoEvent {
  final String title;
  final String description;
  const TodoAddRequested(this.title, this.description);

  @override
  List<Object?> get props => [title,description];


}

class TodoToggleAllRequested extends TodoEvent {
  const TodoToggleAllRequested();
}


class TodoToggleRequested extends TodoEvent {
  final int id;
  const TodoToggleRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoDeleteRequested extends TodoEvent {
  final int id;
  const TodoDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoUpdateRequested extends TodoEvent {
  final int id;
  final String? newTitle;
  final String? newDescription;
  const TodoUpdateRequested({required this.id, this.newTitle, this.newDescription});

  @override
  List<Object?> get props => [id, newTitle, newDescription];
}


class TodoClearCompletedRequested extends TodoEvent {}

class TodoOverviewFilterChanged extends TodoEvent {
  const TodoOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}
class TodoUndoDeletionRequested extends TodoEvent {
  const TodoUndoDeletionRequested();

  @override
  List<Object?> get props => [];
}
