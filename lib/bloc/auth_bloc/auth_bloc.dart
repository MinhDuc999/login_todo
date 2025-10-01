import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_todo/bloc/auth_bloc/auth_event.dart';
import 'package:login_todo/bloc/auth_bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/data/service/auth/auth_service.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<bool>? _authSubscription;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthLogInRequested>(_onLogInRequested);
    on<AuthLogOutRequested>(_onLogOutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    _startAuthListener();
  }

  void _startAuthListener() {
    _authSubscription = _authService.userChanges.listen((isLoggedIn) {
      add(AuthStateChanged(isLoggedIn));
    });
  }

  Future<void> _onLogInRequested(
      AuthLogInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await _authService.logIn(event.email, event.password);
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Lỗi đăng nhập"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogOutRequested(
      AuthLogOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    await _authService.logOut();
  }

  Future<void> _onCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    final user = await _authService.userChanges.first;
    if (user) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onAuthStateChanged(
      AuthStateChanged event,
      Emitter<AuthState> emit,
      ) {
    if (event.isLoggedIn) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}