import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import '../../bloc/todo_bloc/todo_event.dart';
import '../../models/enums/todo_type.dart';

class TodoOverviewFilterButton extends StatelessWidget {
  const TodoOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter = context.select(
          (TodoBloc bloc) {
        final state = bloc.state;
        return state is TodosLoadSuccess ? state.filter : TodosViewFilter.all;
      },
    );

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      onSelected: (filter) {
        context.read<TodoBloc>().add(
          TodoOverviewFilterChanged(filter),
        );
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text("Show all"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text("Show active"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text("Show Complete"),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
