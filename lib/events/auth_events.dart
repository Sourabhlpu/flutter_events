import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:meta/meta.dart';

class AuthenticationEvents extends Equatable{

  AuthenticationEvents([List props = const[]]) : super([props]);
}

class LoginButtonPressed extends AuthenticationEvents{
  final User user;

  LoginButtonPressed({@required this.user}) : super([user]);

  @override
  String toString() => "Login pressed";


}

class SignupPressed extends AuthenticationEvents{
  final User user;

  SignupPressed({@required this.user}) : super([user]);

  @override
  String toString() => "Signup pressed";

}

class AuthErrorEvent extends AuthenticationEvents{

  final String error;

  AuthErrorEvent({@required this.error}) : super([error]);

  @override
  String toString() => "Auth error event";


}

class SigninSuccessEvent extends AuthenticationEvents{


  @override
  String toString() => "Sign in success event";
}

class SignupSuccessEvent extends AuthenticationEvents{


  @override
  String toString() => "Signup success event";
}