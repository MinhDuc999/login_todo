import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_state.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/presentations/pages/edit_todo_page.dart';

class TodoOverviewPage extends StatelessWidget {
  const TodoOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listenWhen: (previous, current) =>
          previous.lastDeletedTodo != current.lastDeletedTodo &&
          current.lastDeletedTodo != null,
      listener: (context, state) {
        final deletedTodo = state.lastDeletedTodo!;
        final message = ScaffoldMessenger.of(context);
        message
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Đã xóa ${deletedTodo.title}'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  message.hideCurrentSnackBar();
                  context.read<TodoBloc>().add(TodoUndoDeletionRequested());
                },
              ),
            ),
          );
      },
      builder: (context, state) {
        if (state is TodosLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodosLoadFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is TodosLoadSuccess) {
          final todos = state.filteredTodos.toList();
          if (todos.isEmpty) {
            return const Center(child: Text('No todos'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final t = todos[index];
              return Dismissible(
                key: ValueKey(t.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<TodoBloc>().add(TodoDeleteRequested(t.id));
                  final message = ScaffoldMessenger.of(context);
                  message
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text('Đã xóa ${t.title}'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            context.read<TodoBloc>().add(TodoUndoDeletionRequested());
                          },
                        ),
                      ),
                    );
                },
                child: ListTile(
                  leading: Checkbox(
                    value: t.isCompleted,
                    onChanged: (_) =>
                        context.read<TodoBloc>().add(TodoToggleRequested(t.id)),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.title),
                      Text(t.description),
                    ],
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      EditTodoPage.route(initialTodo: t),
                    );
                    if (context.mounted) {
                      context.read<TodoBloc>().add(TodoLoadRequested());
                    }
                  },
                ),
              );
            },
          );

        }
        return const SizedBox.shrink();
      },
    );
  }
}
