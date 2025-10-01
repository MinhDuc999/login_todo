import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/home/home_cubit.dart';
import 'package:login_todo/bloc/home/home_state.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/bloc/todo_bloc/todo_event.dart';
import 'package:login_todo/presentations/pages/stats_page.dart';
import 'package:login_todo/presentations/pages/todo_overview_page.dart';
import 'package:login_todo/presentations/widgets/overview_filter_button.dart';
import 'package:login_todo/presentations/widgets/overview_option_button.dart';
import 'package:login_todo/presentations/widgets/tab_button.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(TodoLoadRequested());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _add() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    if (title.isEmpty) return;
    context.read<TodoBloc>().add(TodoAddRequested(title, desc));
    _titleController.clear();
    _descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          TodoOverviewFilterButton(),
          TodoOverviewOptionButton()
        ],
      ),
      body: IndexedStack(
        index: selectedTab.index,
        children: const [
          TodoOverviewPage(),
          StatsPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _add();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Add Todo"),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.todos,
              icon: const Icon(Icons.list_rounded),
            ),
            HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.stats,
              icon: const Icon(Icons.show_chart_rounded),
            ),
          ],
        ),
      ),

    );
  }
}
