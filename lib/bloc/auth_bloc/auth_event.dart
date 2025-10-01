abstract class AuthEvent{}

class AuthLogInRequested extends AuthEvent{
  final String email;
  final String password;

  AuthLogInRequested({required this.email,required this.password});
}

class AuthLogOutRequested extends AuthEvent{}
class AuthCheckRequested extends AuthEvent{}
class AuthStateChanged extends AuthEvent {
  final bool isLoggedIn;
  AuthStateChanged(this.isLoggedIn);
}