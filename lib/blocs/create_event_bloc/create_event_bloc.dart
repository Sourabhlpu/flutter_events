import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_events/blocs/application_bloc/application_bloc.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter_events/blocs/create_event_bloc/bloc.dart';
import 'package:date_format/date_format.dart';
import 'package:path/path.dart' as p;

class CreateEventBloc extends Bloc<CreateEventEvents, CreateEventStates> {
  final ApplicationBloc applicationBloc;
  final AppRepository repository;
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool isListChanged;
  List<EventTypes> _eventTypes = [];

  bool _isEventTypeSelected;

  CreateEventBloc({@required this.applicationBloc, @required this.repository})
      : assert(applicationBloc != null),
        assert(repository != null);

  @override
  get initialState => CreateEventStates.initialState();

  @override
  Stream<CreateEventStates> mapEventToState(CreateEventEvents event) async* {
    if (event is FetchEventType) {
      //todo return a list of event types as streams

      //yield ListFetched(eventType: _getEventTypeList());
      yield currentState.update(
          eventTypes: _getEventTypeList(), isError: false);
    }

    if (event is CreateEventPressed) {
      yield currentState.update(isLoading: true);

      Event _event = _getEvent(event);

      if (_validateEvent(_event) != null) {
        yield currentState.update(
            error: _validateEvent(_event), isError: true, isLoading: false);
      } else {
        try {
          repository.createEvent(_event);
          yield CreateEventStates.createEventSuccess();
        } catch (error) {
          yield currentState.update(
              error: _validateEvent(_event), isError: true, isLoading: false);
        }
      }
    }

    if (event is AddCoverImageTapped) {
      try {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        yield (currentState.update(
            localImageName: p.basename(image.path),
            isError: false,
            isUploadingImage: true));
        Stream<StorageTaskEvent> taskEvent = repository.uploadFile(image);
        _listenToUploadEvents(taskEvent, p.basename(image.path));
      } catch (error) {
        yield currentState.update(error: error.toString(), isError: true);
      }
    }

    if (event is EventTypePressed) {
      _toggleEventSelection(event);
      yield currentState.update(
          eventTypes: List.from(_eventTypes), isError: false);
      //yield EventTypeTapped();
    }

    if (event is LocationTapped) {
      try {
        Place p = await PluginGooglePlacePicker.showAutocomplete(
            mode: PlaceAutocompleteMode.MODE_FULLSCREEN);

        yield currentState.update(location: p.name, isError: false);
      } catch (error) {
        yield currentState.update(error: error.toString(), isError: true);
      }
    }

    if (event is ImageUploadedEvent) {
      yield currentState.update(
          imageUrl: event.url,
          localImageName: event.fileName,
          isUploadingImage: false,
          isError: false);
    }

    if (event is UploadingImageEvent) {
      yield currentState.update(isUploadingImage: true, isError: false);
    }

    if (event is StartDateSelected) {
      startDate = event.startDate;
      yield currentState.update(
          startDate: AppUtils.formatDates(event.startDate), isError: false);
    }

    if (event is EndDateSelected) {
      endDate = event.endDate;
      yield currentState.update(
          endDate: AppUtils.formatDates(event.endDate), isError: false);
    }

    if (event is StartTimeSelected) {
      startTime = event.startTime;
      yield currentState.update(
          startTime: AppUtils.formatTime(event.startTime), isError: false);
    }

    if (event is EndtTimeSelected) {
      endTime = event.endTime;
      yield currentState.update(
          endTime: AppUtils.formatTime(event.endTime), isError: false);
    }
  }

  _getEventTypeList() {
    _eventTypes.add(EventTypes(interestName: 'Business', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Science', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Technology', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Music', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Food', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Dance', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Business', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Social', isSelected: false));
    _eventTypes.add(EventTypes(interestName: 'Pets', isSelected: false));

    return _eventTypes;
  }

  _toggleEventSelection(EventTypePressed event) {
    String eventTypeName = _eventTypes[event.index].interestName;
    bool isSelected = _eventTypes[event.index].isSelected;
    EventTypes eventType =
        EventTypes(interestName: eventTypeName, isSelected: !isSelected);
    _eventTypes.insert(event.index, eventType);
    _eventTypes.removeAt(event.index + 1);
  }

  _listenToUploadEvents(
      Stream<StorageTaskEvent> taskEvent, String localImagePath) {
    taskEvent.listen((event) async {
      if (event.type == StorageTaskEventType.success) {
        String imageUrl = await event.snapshot.ref.getDownloadURL();
        dispatch(ImageUploadedEvent(url: imageUrl, fileName: localImagePath));
      }
    });
  }

  _validateEvent(Event event) {
    if (currentState.isUploadingImage)
      return "Please wait while the image is uploading";
    if (!_isEventTypeSelected)
      return "Please select event type";
    else if (event.image == null || event.image.isEmpty)
      return "Please select an image";
    else
      return null;
  }

  _getEvent(CreateEventPressed e) {
    Event event = Event((b) => b
      ..title = e.title
      ..eventType = BuiltList<String>.from(_getSelectedEvents()).toBuilder()
      ..location = e.location
      ..startDate = AppUtils.getDateInEpoch(startDate, startTime).toString()
      ..endDate = AppUtils.getDateInEpoch(endDate, endTime).toString()
      ..entryFees = e.fees
      ..about = e.description
      ..by = repository.getUserFsFromPrefs().name
      ..isFavorite = false
      ..image = currentState.imageUrl);

    return event;
  }

  List<String> _getSelectedEvents() {
    List<String> selectedEvents = currentState.eventTypes
        .where((eventType) => eventType.isSelected)
        .toList()
        .map((eventType) => eventType.interestName)
        .toList();

    _setIsEventTypeSelected(selectedEvents);
    return selectedEvents;
  }

  _setIsEventTypeSelected(List<String> selectedEvents) {
    _isEventTypeSelected = selectedEvents.length > 0;
  }
}
