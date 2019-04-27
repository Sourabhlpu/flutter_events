import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AuthenticationStates extends Equatable {
  AuthenticationStates([List props = const []]) : super([props]);
}

class InitialState extends AuthenticationStates {
  @override
  String toString() => "initial state";
}

class Loading extends AuthenticationStates{


  @override
  String toString() => "Loading";
}

class SigninSuccess extends AuthenticationStates {
  @override
  String toString() => "logged in";
}

class SignupSuccess extends AuthenticationStates {

  @override
  String toString() => "Signed in";
}

class AuthError extends AuthenticationStates {
  String error;
  AuthError({@required this.error}): super([error]);

  @override
  String toString() => "Login error";
}
