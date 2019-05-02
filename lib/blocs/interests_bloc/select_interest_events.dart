import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:meta/meta.dart';

abstract class SelectInterestEvents extends Equatable {
  SelectInterestEvents([List props = const []]) : super([props]);
}

class FetchList extends SelectInterestEvents {
  @override
  String toString() => "fetch list";
}

class InterestTapped extends SelectInterestEvents {
  final int index;

  InterestTapped({@required this.index}) : super([index]);

  @override
  String toString() => "interest tapped";
}

class LetsStartTapped extends SelectInterestEvents {
  @override
  String toString() => "lets start tapped";
}

class InterestsSavedEvent extends SelectInterestEvents{


  @override
  String toString() => "Interests list saved";
}

class ListLoadedEvent extends SelectInterestEvents {
  List<Interest> interests;

  ListLoadedEvent({@required this.interests}) : super([interests]);

  @override
  String toString() => "list loaded";
}

class GenericErrorEvent extends SelectInterestEvents {
  String error;

  GenericErrorEvent({@required this.error}) : super([error]);

  @override
  String toString() => "error: $error";
}


