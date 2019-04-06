import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:meta/meta.dart';

abstract class CreateEventStates extends Equatable{

  CreateEventStates([List props = const[]]) : super(props);
}

class CreateEventInitial extends CreateEventStates{

  @override
  String toString() => "createEventInitial";
}

class CreateEventLoading extends CreateEventStates{


  @override
  String toString() => "loading";
}

class CreateEventSuccess extends CreateEventStates{


  @override
  String toString() => "createEventSuccess";
}

class CreateEventFailure extends CreateEventStates{

  final String error;

  CreateEventFailure({@required this.error}) : super([error]);


  @override
  String toString() => "CreateEventFailure {error : $error}";
}

class ListFetched extends CreateEventStates{

  final List<EventTypes> eventType;

  ListFetched({@required this.eventType});

  @override
  String toString() => "List fetched {$eventType}";


}

class UploadingImage extends CreateEventStates{


  @override
  String toString() => "uploading image";
}

class ImageUploaded extends CreateEventStates{

  final File file;

  ImageUploaded({@required this.file});
  @override
  String toString() => "image uploaded";
}

class ImageUploadFailed extends CreateEventStates{


  @override
  String toString() => "upload image failed";
}

class EventTypeSelected extends CreateEventStates{

  final List<EventTypes> eventType;

  EventTypeSelected({this.eventType});

  @override
  String toString() => "event type selected";
}

class EventTypeUnelected extends CreateEventStates{

  final List<EventTypes> eventType;

  EventTypeUnelected({this.eventType});

  @override
  String toString() => "event type selected";
}