import 'package:equatable/equatable.dart';

abstract class ApplicationEvents extends Equatable{
  ApplicationEvents([List props = const[]]) : super([props]);
}

class AppStarted extends ApplicationEvents{


  @override
  String toString() => "App has started";
}