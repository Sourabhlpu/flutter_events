import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/events/event.dart';

abstract class HomeState extends Equatable {
  HomeState([List props = const []]) : super([props]);
}

class HomeStateUninitialized extends HomeState {
  @override
  String toString() => "Uninitialized";
}

class Loading extends HomeState {
  @override
  String toString() => "Loading";
}

class ListLoaded extends HomeState {
  List<Event> events;

  ListLoaded({this.events}) : super([events]);

  @override
  String toString() => "List loaded";
}

class ListLoadingError extends HomeState {
  String error;

  ListLoadingError({this.error}) : super([error]);

  @override
  String toString() => "Error in fetching list";
}
