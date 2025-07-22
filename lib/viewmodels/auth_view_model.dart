import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  AuthStatus _status = AuthStatus.uninitialized;
  String? _errorMessage;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _authService.currentUser;

  AuthViewModel({required AuthService authService}) : _authService = authService {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> login({required String email, required String password}) async {
    _setStatus(AuthStatus.loading);

    try {
      await _authService.signInWithEmail(email.trim(), password.trim());
      _errorMessage = null;
      _setStatus(AuthStatus.authenticated);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> register({required String email, required String password}) async {
    _setStatus(AuthStatus.loading);

    try {
      await _authService.registerWithEmail(email.trim(), password.trim());
      _errorMessage = null;
      _setStatus(AuthStatus.authenticated);
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseErrorMessage(e);
      _setStatus(AuthStatus.error);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _setStatus(AuthStatus.unauthenticated);
  }

  void _onAuthStateChanged(User? user) {
    _setStatus(user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated);
  }

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Your password is too weak.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
