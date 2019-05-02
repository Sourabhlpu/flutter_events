import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ApplicationStates extends Equatable {
  ApplicationStates([List props = const []]) : super([props]);
}

class Initializing extends ApplicationStates {
  @override
  String toString() => "initializing";
}

class UserUnauthenticated extends ApplicationStates {
  final bool showIntro;

  UserUnauthenticated({@required this.showIntro}) : super([showIntro]);

  @override
  String toString() => "user not authenticated, showIntro: $showIntro";
}

class UserAuthenticated extends ApplicationStates {

  final bool showInterestsScreen;

  UserAuthenticated({this.showInterestsScreen}) : super([showInterestsScreen]);
  @override
  String toString() => "user authenticated";
}

