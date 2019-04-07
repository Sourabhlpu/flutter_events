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

class AddCoverImageTapped extends CreateEventEvents {

  AddCoverImageTapped();

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

class LocationTapped extends CreateEventEvents{


  @override
  String toString() => "location tapped";
}

class ImageUploadedEvent extends CreateEventEvents{

  final String url;

  ImageUploadedEvent({@required this.url});

  @override
  String toString() => "image uploaded";


}

class UploadingImageEvent extends CreateEventEvents{

  final double percent;

  UploadingImageEvent({@required this.percent});

  @override
  String toString() => "uploading image percent: $percent";


}