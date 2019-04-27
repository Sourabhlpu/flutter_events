import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/events/event.dart';

abstract class HomeEvents extends Equatable{

  HomeEvents([List props = const[]]) : super([props]);
}

class FetchEventList extends HomeEvents {


  @override
  String toString() => "Fetch home events list";
}

class ListLoadedEvent extends HomeEvents{

  final List<Event> events;

  ListLoadedEvent({this.events}) : super([events]);

  @override
  String toString() => "List fetched";
}

class ListLoadingErrorEvent extends HomeEvents
{
 final String error;

 ListLoadingErrorEvent({this.error}) : super([error]);

 @override
 String toString() => "error event";

}

class FavoriteButtonTapped extends HomeEvents{

  final int index;

  FavoriteButtonTapped({this.index}) : super([index]);

  @override
  String toString() => "fav button tapped";


}
