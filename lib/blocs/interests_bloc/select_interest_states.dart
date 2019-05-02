import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:meta/meta.dart';

abstract class SelectInterestStates extends Equatable
{
  SelectInterestStates([List props = const[]]) : super([props]);
}

class Uninitialized extends SelectInterestStates{


  @override
  String toString() => "uninitialized";
}

class Loading extends SelectInterestStates{


  @override
  String toString() => "loading";
}

class ListLoaded extends SelectInterestStates{

  final List<Interest> interests;

  ListLoaded({@required this.interests}) : super([interests]);

  @override
  String toString() => "list loaded";


}

class InterestSaved extends SelectInterestStates{


  @override
  String toString() => "interests saved";
}

class GenericError extends SelectInterestStates{

  String error;

  GenericError({@required this.error}) : super([error]);

  @override
  String toString() => "error: $error";


}