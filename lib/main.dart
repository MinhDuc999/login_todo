import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/home/home_cubit.dart';
import 'package:login_todo/bloc/stats/stats_bloc.dart';
import 'package:login_todo/bloc/stats/stats_event.dart';
import 'package:login_todo/bloc/todo_bloc/todo_bloc.dart';
import 'package:login_todo/presentations/widgets/splash.dart';
import 'bloc/auth_bloc/auth_event.dart';
import 'core/injection.dart' as di;
import 'core/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
          ),
          BlocProvider(create: (_) => getIt<TodoBloc>()),
          BlocProvider(create: (_) => getIt<HomeCubit>()),
          BlocProvider(create: (_) => getIt<StatsBloc>()..add(StatsRequested())),
        ],
        child: const Splash(),
      ),
    );
  }
}
