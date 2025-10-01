abstract class AuthRepository{
  Future<void> logIn(String email, String password);
  Future<void> logOut();
  Stream<bool> get userChanges;
}
