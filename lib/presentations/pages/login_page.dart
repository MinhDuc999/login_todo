import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_event.dart';
import 'package:login_todo/bloc/auth_bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit(){
    final email = _email.text.trim();
    final pass = _pass.text;
    context.read<AuthBloc>().add(AuthLogInRequested(email: email, password: pass));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontSize: 28),),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthFailure){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state){
          if(state is AuthLoading) return const Center(child: CircularProgressIndicator(),);
          return Padding(padding: EdgeInsets.all(16),
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: _pass,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(onPressed: _submit, child: const Text('Login'))
                  ],
          )),
          );
        }),
    );
  }
}
