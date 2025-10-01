import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_todo/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<void> logIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> logOut() async{
    await _firebaseAuth.signOut();
  }

  @override
  Stream<bool> get userChanges => _firebaseAuth.authStateChanges().map((u) => u != null);
  
  
}