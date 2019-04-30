import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:meta/meta.dart';
import 'dart:async';

class CreateEventBloc extends Bloc<CreateEventEvents, CreateEventStates> {
  final ApplicationBloc applicationBloc;
  final AppRepository repository;
  bool isListChanged;
  List<EventTypes> _eventTypes = [];

  CreateEventBloc({@required this.applicationBloc, @required this.repository})
      : assert(applicationBloc != null),
        assert(repository != null);

  @override
  get initialState => CreateEventInitial();

  @override
  Stream<CreateEventStates> mapEventToState(CreateEventEvents event) async* {

    if (event is FetchEventType) {
      //todo return a list of event types as streams

      yield ListFetched(eventType: _getEventTypeList());
    }
    if (event is CreateEventPressed) {

      if (_validateEvent(event.event) != null) {
        yield CreateEventFailure(error: _validateEvent(event.event));
      } else {
        yield CreateEventLoading();

        try {
          repository.createEvent(event.event);
          yield CreateEventSuccess();
        } catch (error) {
          yield CreateEventFailure(error: error.toString());
        }
      }
    }
    if (event is AddCoverImageTapped) {

      try {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        yield (UploadingImage(fileName: image.path));
        Stream<StorageTaskEvent> taskEvent = repository.uploadFile(image);
        _listenToUploadEvents(taskEvent, image.path);
      } catch (error) {
        yield CreateEventFailure(error: error.toString());
      }
    }

    if (event is EventTypePressed) {
      _toggleEventSelection(event);
      yield EventTypeToggled(eventType: List.from(_eventTypes));
      //yield EventTypeTapped();
    }

    if (event is LocationTapped) {
      try {
        Place p = await PluginGooglePlacePicker.showAutocomplete(
            mode: PlaceAutocompleteMode.MODE_FULLSCREEN);

        yield LocationSelected(location: p.name);
      } catch (error) {
        yield CreateEventFailure(error: error.toString());
      }
    }

    if (event is ImageUploadedEvent) {
      yield ImageUploaded(imageUrl: event.url, localFileName: event.fileName);
    }

    if (event is UploadingImageEvent) {
      yield UploadingImage(percent: event.percent);
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

  _listenToUploadEvents(Stream<StorageTaskEvent> taskEvent, String localImagePath) {
    taskEvent.listen((event) async {
      if (event.type == StorageTaskEventType.success) {
        String imageUrl = await event.snapshot.ref.getDownloadURL();
        dispatch(ImageUploadedEvent(url: imageUrl, fileName: localImagePath));
      }
    });
  }

  _validateEvent(Event event) {

    if(currentState is UploadingImage)
      return "Please wait while the image is uploading";
    if (event.eventType.isEmpty)
      return "Please select event type";
    else if (event.image == null || event.image.isEmpty)
      return "Please select an image";
    else
      return null;
  }
}
