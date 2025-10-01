import 'package:login_todo/domain/repositories/auth/auth_repository.dart';

class AuthService{
  AuthRepository authRepository;
  AuthService({required this.authRepository});

  Future<void> logIn(String email, String password) => authRepository.logIn(email, password);
  Future<void> logOut() => authRepository.logOut();
  Stream<bool> get userChanges => authRepository.userChanges;
}