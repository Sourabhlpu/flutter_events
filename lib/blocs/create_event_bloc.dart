import 'dart:collection';
import 'dart:io';

import 'package:built_collection/src/list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_events/repository/app_repository.dart';

class CreateEventBloc implements BlocBase {
  Sink<File> get uploadImage => _addEventImageController.sink;
  final _addEventImageController = BehaviorSubject<File>();

  // the stream to manage the showing of loader when the we are hitting the api.
  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(sync: false);

  Stream<StorageTaskEvent> get storageTaskEvent =>
      _imageUploadController.stream;
  final _imageUploadController = BehaviorSubject<StorageTaskEvent>();

  Sink<Event> get createEvent => _createEventController.sink;
  final _createEventController = BehaviorSubject<Event>();

  Stream<List<Interest>> get interests => _interestListController.stream;
  final _interestListController = BehaviorSubject<List<Interest>>();

  AddItemDelegate _delegate;

  ApplicationBloc _applicationBloc;

  CreateEventBloc(ApplicationBloc appBloc) {
    _applicationBloc = appBloc;
    _startUpload();
    _listenToCreateEvent();

    _fetchInterests();
  }

  _startUpload() {
    _addEventImageController.listen((imageFile) async {
      if (await AppUtils.checkNetworkAvailability()) {
        repository.uploadFile(imageFile).listen((event) {
          _imageUploadController.add(event);
        }).onError((error) {
          print("event bloc" + error);
        });
      } else {
        _delegate.onError("No Internet");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isLoadingSubject.close();
    _imageUploadController.close();
    _interestListController.close();

  }

  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;

    if (type == AddSinkType.uploadImage) {
      _addEventImageController.add(item);
    } else if (type == AddSinkType.createEvent) {
      _createEventController.add(item);
    }
  }

  void _listenToCreateEvent() {
    _createEventController.listen((event) async {
      if (_validateEvent(event)) {
        if (await AppUtils.checkNetworkAvailability()) {
          _isLoadingSubject.add(true);
          repository.createEvent(event).then((_) {
            _isLoadingSubject.add(false);
          });
        } else {
          _delegate.onError("No Internet");
          _isLoadingSubject.add(false);
        }
      }
    });
  }

  _validateEvent(Event event) {
    bool isEventTypeSelected = _isEventTypeSelected(event.eventType);
    bool isImageSelected = _isImageSelected(event);
    if (isEventTypeSelected && isImageSelected) {
      return true;
    } else if (!isEventTypeSelected) {
      _delegate.onError("Please select an event type");
      return false;
    } else if (!isImageSelected) {
      _delegate.onError("Please select an image");
      return false;
    }
  }

  _isEventTypeSelected(BuiltList<String> eventType) {
    return eventType != null && eventType.isNotEmpty;
  }

  _isImageSelected(Event event) {
    return event.image != null && event.image.isNotEmpty;
  }

  /*
   * start fetching the list of interests from the firestore db
   */
  void _fetchInterests() async {
    _applicationBloc.interests.listen((unmodInterestList) {
      List<Interest> _interestListMutable =
          unmodInterestList.map((interest) => interest).toList();

      _interestListController.sink.add(_interestListMutable);
    });
  }
}
