import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_event.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import 'package:login_todo/models/todos/todo_model.dart';
import '../../models/enums/overview_option.dart';

class TodoOverviewOptionButton extends StatelessWidget {
  const TodoOverviewOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodoBloc bloc) {
      final state = bloc.state;
      return state is TodosLoadSuccess ? state.todos : <TodoModel>[];
    });

    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;


    return PopupMenuButton<TodoOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      onSelected: (option) {
        switch (option) {
          case TodoOverviewOption.toggleAll:
              context.read<TodoBloc>().add(
                  TodoToggleAllRequested(),
              );
          case TodoOverviewOption.clearCompleted:
            context.read<TodoBloc>().add(
              TodoClearCompletedRequested(),
            );
          case TodoOverviewOption.logOut:
            context.read<AuthBloc>().add(AuthLogOutRequested());
        }
      },
      itemBuilder: (context){
        return [
          PopupMenuItem(
            value: TodoOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? 'Mark All Incomplete'
                  : 'Mark All Complete',
            ),
          ),
          PopupMenuItem(
            value: TodoOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: Text("Clear Completed"),
          ),
          PopupMenuItem(
            value: TodoOverviewOption.logOut,
            enabled: true,
            child: Text("LogOut"),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}