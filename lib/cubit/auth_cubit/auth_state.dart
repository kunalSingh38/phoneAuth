import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthErrorState {
  AuthInitialState(super.error);
}

class AuthLoadingState extends AuthState {}

class AuthCodeSentState extends AuthState {}

class AuthCodeVerificationState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final User firebaseuser;
  AuthLoggedInState(this.firebaseuser);
}

class AuthLoggedoutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

class AuthSplashScreen extends AuthState {}
