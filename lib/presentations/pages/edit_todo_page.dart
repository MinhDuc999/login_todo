import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/todo_deit/edit_todo_bloc.dart';
import 'package:login_todo/bloc/todo_deit/edit_todo_event.dart';
import 'package:login_todo/bloc/todo_deit/edit_todo_state.dart';
import 'package:login_todo/data/service/todos/todo_service.dart';
import 'package:login_todo/models/enums/todo_edit.dart';
import 'package:login_todo/models/todos/todo_model.dart';
import '../../core/injection.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({TodoModel? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (_) => EditTodoBloc(
          service: getIt<TodoService>(),
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) {
        Navigator.of(context).pop();
      },
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    return Scaffold(
      appBar: AppBar(title: Text("Sửa Todo")),
      floatingActionButton: FloatingActionButton(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditTodoBloc>().add(const EditSubmit()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [_TitleField(), _DescriptionField()]),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Tiêu đề",
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTitle(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Mô tả",
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [LengthLimitingTextInputFormatter(300)],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditDescription(value));
      },
    );
  }
}
