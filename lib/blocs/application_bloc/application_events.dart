import 'package:equatable/equatable.dart';

abstract class ApplicationEvents extends Equatable {
  ApplicationEvents([List props = const []]) : super([props]);
}

class AppStarted extends ApplicationEvents {
  @override
  String toString() => "App has started";
}

class UserAuthenticatedEvent extends ApplicationEvents {

  final bool showInterestsScreen;

  UserAuthenticatedEvent({this.showInterestsScreen}) : super([showInterestsScreen]);
  @override
  String toString() => "user authenticated event";
}

class UserUnauthenticatedEvent extends ApplicationEvents {
  final bool showIntro;

  UserUnauthenticatedEvent({this.showIntro}) : super([showIntro]);

  @override
  String toString() => "user un authenticated event; showIntro: $showIntro";
}


class IntroScreenButtonTapped extends ApplicationEvents{


  @override
  String toString() => "intro screen button tapped";
}
