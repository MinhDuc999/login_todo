import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_state.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state){
          if(state is AuthAuthenticated) return const HomePage();
          if(state is AuthUnauthenticated || state is AuthFailure) return const LoginPage();
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
