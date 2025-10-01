import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_todo/bloc/auth_bloc/auth_bloc.dart';
import 'package:login_todo/bloc/home/home_cubit.dart';
import 'package:login_todo/bloc/stats/stats_bloc.dart';
import 'package:login_todo/data/repositories/auth/auth_repository_impl.dart';
import 'package:login_todo/data/service/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/todo_bloc/todo_bloc.dart';
import '../data/repositories/todos/todo_repository_impl.dart';
import '../data/service/todos/todo_service.dart';
import '../domain/repositories/auth/auth_repository.dart';
import '../domain/repositories/todos/todo_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<FirebaseAuth>()),
  );

  getIt.registerLazySingleton<AuthService>(
        () => AuthService(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthBloc>(() => AuthBloc(getIt<AuthService>()),
    dispose: (bloc) => bloc.close(),
  );


  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(getIt<SharedPreferences>()));

  getIt.registerLazySingleton<TodoService>(() => TodoService(getIt<TodoRepository>()));

  getIt.registerLazySingleton<TodoBloc>(() => TodoBloc(getIt<TodoService>()));

  getIt.registerLazySingleton<HomeCubit>(() => HomeCubit());

  getIt.registerLazySingleton<StatsBloc>(() => StatsBloc(todoService: getIt<TodoService>()));

}