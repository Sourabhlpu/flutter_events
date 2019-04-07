import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    // TODO: implement mapEventToState

    if (event is FetchEventType) {
      //todo return a list of event types as streams

      yield ListFetched(eventType: _getEventTypeList());
    }
    if (event is CreateEventPressed) {
      //todo hit backend to create event
      yield CreateEventLoading();

      try {
        repository.createEvent(event.event);
        yield CreateEventSuccess();
      } catch (error) {
        yield CreateEventFailure(error: error.toString());
      }
    }
    if (event is AddCoverImageTapped) {
      //todo upload image to the firestore server

      try {
        File image = await ImagePicker.pickImage(source: ImageSource.gallery);
        //yield UploadingImage();
        Stream<StorageTaskEvent> taskEvent = repository.uploadFile(image);
        _listenToUploadEvents(taskEvent);
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
      yield ImageUploaded(fileName: event.url);
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

  _updateEventTypeList(int index, EventTypes eventType) {
    _eventTypes.insert(index, eventType);
    _eventTypes.removeAt(index + 1);
  }

  _openLocationPicker() async {
    try {
      Place p = await PluginGooglePlacePicker.showAutocomplete(
          mode: PlaceAutocompleteMode.MODE_FULLSCREEN);
    } catch (error) {
      print(error);
    }
  }

  _listenToUploadEvents(Stream<StorageTaskEvent> taskEvent) {
    taskEvent.listen((event) async {
      if (event.type == StorageTaskEventType.success) {
        String imageUrl = await event.snapshot.ref.path;
        dispatch(ImageUploadedEvent(url: imageUrl));
      }

      if (event.type == StorageTaskEventType.progress) {
        double percent =
            (event.snapshot.bytesTransferred / event.snapshot.totalByteCount) * 100 ;

        dispatch(UploadingImageEvent(percent: percent));
      }
    });
  }
}
