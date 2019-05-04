import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:meta/meta.dart';

class CreateEventStates {
  final bool isInitial;
  final bool isLoading;
  final bool isUploadingImage;
  final bool createEvenSuccess;
  final bool isError;
  final List<EventTypes> eventTypes;
  final String error;
  final String imageUrl;
  final String localImageName;
  final String location;
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;

  CreateEventStates(
      {this.isInitial = false,
      this.isLoading = false,
      this.isUploadingImage = false,
      this.createEvenSuccess = false,
      this.isError = false,
      this.error = "",
      this.eventTypes = const [],
      this.imageUrl = "",
      this.localImageName = "Add Cover Image",
      this.location = "",
      this.startDate = "",
      this.startTime = "",
      this.endDate = "",
      this.endTime = ""});

  CreateEventStates copyWith({
    bool isInitial,
    bool isLoading,
    bool isUploadingImage,
    bool createEventSuccess,
    bool isError,
    List<EventTypes> eventTypes,
    String error,
    String imageUrl,
    String localImageName,
    String location,
    String startDate,
    String startTime,
    String endDate,
    String endTime,
  }) {
    return CreateEventStates(
      isInitial: isInitial ?? this.isInitial,
      isLoading: isLoading ?? this.isLoading,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      createEvenSuccess: createEventSuccess ?? this.createEvenSuccess,
      isError: isError ?? this.isError,
      eventTypes: eventTypes ?? this.eventTypes,
      error: error ?? this.error,
      imageUrl: imageUrl ?? this.imageUrl,
      localImageName: localImageName ?? this.localImageName,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      endDate: endDate ?? this.endDate,
    );
  }

  CreateEventStates update({
    List<EventTypes> eventTypes,
    String error,
    bool isError,
    String imageUrl,
    String localImageName,
    String location,
    bool isUploadingImage,
    bool isLoading,
    String startDate,
    String startTime,
    String endDate,
    String endTime,
  }) {
    return copyWith(
        eventTypes: eventTypes,
        error: error,
        isError: isError,
        imageUrl: imageUrl,
        localImageName: localImageName,
        location: location,
        isUploadingImage: isUploadingImage,
        isLoading: isLoading,
        startDate: startDate,
        startTime: startTime,
        endDate: endDate,
        endTime: endTime);
  }


  factory CreateEventStates.initialState() {
    return CreateEventStates(
        isInitial: true,
        isLoading: false,
        createEvenSuccess: false,
        isError: false);
  }

  factory CreateEventStates.loading() {
    return CreateEventStates(
        isInitial: false,
        isLoading: true,
        createEvenSuccess: false,
        isError: false);
  }

  factory CreateEventStates.createEventSuccess() {
    return CreateEventStates(
        isInitial: false,
        isLoading: false,
        createEvenSuccess: true,
        isError: false);
  }

 /* factory CreateEventStates.error(String error) {
    return CreateEventStates(
        isInitial: false,
        isLoading: false,
        createEvenSuccess: false,
        isError: true,
        error: error);
  }*/
}

/*class CreateEventInitial extends CreateEventStates {
  @override
  String toString() => "createEventInitial";
}

class CreateEventLoading extends CreateEventStates {
  @override
  String toString() => "loading";
}

class CreateEventSuccess extends CreateEventStates {
  @override
  String toString() => "createEventSuccess";
}

class CreateEventFailure extends CreateEventStates {
  final String error;

  CreateEventFailure({@required this.error}) : super(error: error);

  @override
  String toString() => "CreateEventFailure {error : $error}";
}

class ListFetched extends CreateEventStates {
  final List<EventTypes> eventType;

  ListFetched({@required this.eventType}) : super(eventTypes: eventType);

  @override
  String toString() => "List fetched {$eventType}";
}

class UploadingImage extends CreateEventStates {
  final double percent;
  final String fileName;

  UploadingImage({@required this.percent, @required this.fileName})
      : super(localImageName: fileName);
  @override
  String toString() => "uploading image";
}

class ImageUploaded extends CreateEventStates {
  final String imageUrl;
  final String localFileName;

  ImageUploaded({@required this.imageUrl, @required this.localFileName})
      : super(imageUrl: imageUrl, localImageName: localFileName);
  @override
  String toString() => "image uploaded";
}

class ImageUploadFailed extends CreateEventStates {
  @override
  String toString() => "upload image failed";
}

class EventTypeToggled extends CreateEventStates {
  final List<EventTypes> eventType;

  EventTypeToggled({this.eventType}) : super(eventTypes: eventType);

  @override
  String toString() => "event type selected";
}

class EventTypeTapped extends CreateEventStates {
  @override
  String toString() => "Event type tapped";
}

class LocationSelected extends CreateEventStates {
  final String location;

  LocationSelected({@required this.location}) : super(location: location);

  @override
  String toString() => "event location: $location";
}*/
