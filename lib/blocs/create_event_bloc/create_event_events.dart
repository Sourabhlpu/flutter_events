import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

  final String title;
  final String location;
  final String fees;
  final String description;

  CreateEventPressed({
    @required this.title,
    @required this.location,
    @required this.fees,
    @required this.description
  }) : super([title, location, fees, description]);

  @override
  String toString() => "create event pressed";

}

class EventTypePressed extends CreateEventEvents{

  final int index;

  EventTypePressed({@required this.index}) : super([index]);

  @override
  String toString() => "event type tapped";

}

class LocationTapped extends CreateEventEvents{


  @override
  String toString() => "location tapped";
}

class ImageUploadedEvent extends CreateEventEvents{

  final String url;
  final String fileName;

  ImageUploadedEvent({@required this.url, @required this.fileName}) : super([url, fileName]);

  @override
  String toString() => "image uploaded";


}

class UploadingImageEvent extends CreateEventEvents{

  final double percent;

  UploadingImageEvent({@required this.percent}) : super([percent]);

  @override
  String toString() => "uploading image percent: $percent";


}

class StartDateSelected extends CreateEventEvents{

  final DateTime startDate;


  StartDateSelected({@required this.startDate}) : super([startDate]);

  @override
  String toString() => "start date tapped";

}

class StartTimeSelected extends CreateEventEvents{

  final TimeOfDay startTime;

  StartTimeSelected({@required this.startTime}) : super([startTime]);
  @override
  String toString() => "start time tapped";
}

class EndDateSelected extends CreateEventEvents{

  final DateTime endDate;


  EndDateSelected({@required this.endDate}) : super([endDate]);

  @override
  String toString() => "end date tapped";
}

class EndtTimeSelected extends CreateEventEvents{

  final TimeOfDay endTime;

  EndtTimeSelected({@required this.endTime}) : super([endTime]);
  @override
  String toString() => "end time tapped";
}