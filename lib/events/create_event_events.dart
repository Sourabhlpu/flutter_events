import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:meta/meta.dart';

abstract class CreateEventEvents extends Equatable{

  CreateEventEvents([List props = const[]]) : super([props]);
}


class FetchEventType extends CreateEventEvents{


  @override
  String toString() => "fetchEvents";
}

class UploadImage extends CreateEventEvents {

  UploadImage();

  @override
  String toString() => "uploadImage";
}

class CreateEventPressed extends CreateEventEvents{

  final Event event;

  CreateEventPressed({@required this.event}) : super([event]);

  @override
  String toString() => "$event";

}

class EventTypePressed extends CreateEventEvents{

  final int index;

  EventTypePressed({@required this.index});

  @override
  String toString() => "event type tapped";

}