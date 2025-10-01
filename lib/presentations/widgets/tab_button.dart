import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/home/home_cubit.dart';
import 'package:login_todo/bloc/home/home_state.dart';

class HomeTabButton extends StatelessWidget {
  const HomeTabButton({super.key,
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;


  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color: groupValue != value
          ? null
          : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
