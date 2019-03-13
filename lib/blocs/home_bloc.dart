import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/Interest.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/models/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc implements BlocBase {

  List<Events> events;

  FirebaseUser _user;

  UserFs _userFs;

  AddItemDelegate _delegate;

  //this stream is for streaming the list of events to the home screen
  Stream<List<Events>> get eventList => _eventListController.stream;
  final _eventListController = BehaviorSubject<List<Events>>();

  //this streams is for adding/removing favorites
  Sink<int> get addFavorite => _favoriteController.sink;
  final _favoriteController = BehaviorSubject<int>();

  //for showing the loading state
  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: true);

  @override
  void dispose() {
    // TODO: implement dispose
    _eventListController.close();
    _isLoadingSubject.close();
  }

  HomeBloc() {
    _manageFavorites();

    _user = ApplicationBloc.user;
    _userFs = ApplicationBloc.userFs;

    _fetchEvents();
  }

  /*
   * here we fetch the events from the firestore
   */
  _fetchEvents() async {
    bool isNetworkAvailable = await AppUtils.checkNetworkAvailability();

    if (isNetworkAvailable) {
      events = await repository.getEventsList(_userFs);
      _isLoadingSubject.add(false);
      _eventListController.sink.add(events);
    } else {
      _isLoadingSubject.add(false);
      _delegate.onError("No Internet");
    }
  }

  _manageFavorites() {
    _favoriteController.stream.listen((index) {
      _addFavorite(index);
    });
  }

  /*
   * adding favorites to the events list
   */
  _addFavorite(int index) async {

    // as objects from built value gen are immutable, we create a new object with the
    // toggled fav value at an index. Add that to the events list and then remove the old one.
    var eventNew = events[index]
        .rebuild((event) => event..isFavorite = !events[index].isFavorite);

    events.insert(index, eventNew);
    events.removeAt(index + 1);

    bool isNetworkAvailable = await AppUtils.checkNetworkAvailability();

    if (isNetworkAvailable) {
      repository.addFavorite(eventNew, _user).then((_) {
        _eventListController.sink.add(events);
      });
    } else {
      _delegate.onError("No Internet");
    }
  }

  /*
   * method to handle the add sinks for the interests page(individual interest tile tap, final submission)
   */
  void addItem(AddItemDelegate delegate) {
    _delegate = delegate;
  }
}