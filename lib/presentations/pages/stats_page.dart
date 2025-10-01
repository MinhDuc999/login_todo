import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/stats/stats_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            key: const Key('statsView_completedTodos_listTile'),
            leading: const Icon(Icons.check_rounded),
            title: Text('Đã hoàn thành'),
            trailing: Text(
              '${state.completed}',
            ),
          ),
          ListTile(
            key: const Key('statsView_activeTodos_listTile'),
            leading: const Icon(Icons.radio_button_unchecked_rounded),
            title: Text('Chưa hoàn thành'),
            trailing: Text(
              '${state.active}',
            ),
          ),
        ],
      ),
    );
  }
}
