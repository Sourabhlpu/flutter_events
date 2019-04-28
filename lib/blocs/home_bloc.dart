import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/events/home_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/home_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  AppRepository repository;
  UserFireStore _userFs;
  StreamSubscription streamSubscription;

  HomeBloc({@required this.repository})
      : _userFs = repository.getUserFsFromPrefs();

  @override
  HomeState get initialState => HomeStateUninitialized();

  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is FetchEventList) {
      yield* _fetchEvents();
    }

    if (event is ListLoadedEvent) {
      yield ListLoaded(events: event.events);
    }

    if (event is ListLoadingErrorEvent) {
      yield ListLoadingError(error: event.error);
    }

    if (event is FavoriteButtonTapped) {
      yield* _manageFavorite(event.index);
    }
  }

  Stream<HomeState> _fetchEvents() async* {
    yield Loading();
    if (await AppUtils.checkNetworkAvailability()) {
      streamSubscription?.cancel();

      streamSubscription = repository
          .getEventsList(_userFs)
          .asStream()
          .handleError(_handleError)
          .listen((events) {
        dispatch(ListLoadedEvent(events: events));
      });
    } else {
      yield ListLoadingError(error: 'No Internet');
    }
  }

  _manageFavorite(int index) async* {
    _changeFavoriteStatusInEventsList(index);

    List<Event> events = _getEventList();

    if (await AppUtils.checkNetworkAvailability()) {
      if (events[index].isFavorite) {
        repository
            .addFavorite(events[index], _userFs)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index);
        });
      } else {
        repository
            .removeFavorite(events[index].id, _userFs)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index);
        });
      }
    } else {
      _handleError("No Internet");
      _changeFavoriteStatusInEventsList(index);
    }
  }

  List<Event> _getEventList() {
    List<Event> events = [];

    if (currentState is ListLoaded) {
      events = (currentState as ListLoaded).events;
    }

    return events;
  }

  // as objects from built value gen are immutable, we create a new object with the
  // toggled fav value at an index. Add that to the events list and then remove the old one.\

  _changeFavoriteStatusInEventsList(int index) {
    var events = _getEventList();

    var eventNew = events[index]
        .rebuild((event) => event..isFavorite = !events[index].isFavorite);

    events.insert(index, eventNew);
    events.removeAt(index + 1);

    dispatch(ListLoadedEvent(events: List.from(events)));
  }

  void _handleError(String error) {
    dispatch(ListLoadingErrorEvent(error: error.toString()));
  }

/*List<Event> events;

  FirebaseUser _user;

  UserFireStore _userFs;

  AddItemDelegate _delegate;

  ApplicationBloc _applicationBloc;

  //this stream is for streaming the list of events to the home screen
  Stream<List<Event>> get eventList => _eventListController.stream;
  final _eventListController = BehaviorSubject<List<Event>>();

  //this streams is for adding/removing favorites
  Sink<int> get addFavorite => _favoriteController.sink;
  final _favoriteController = BehaviorSubject<int>();

  //for showing the loading state
  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>.seeded((true));

  @override
  void dispose() {
    // TODO: implement dispose
    _eventListController.close();
    _isLoadingSubject.close();
  }

  HomeBloc(ApplicationBloc bloc) {

    _applicationBloc = bloc;
    _manageFavorites();

    _user = ApplicationBloc.user;

    _applicationBloc.userFirestore.listen((userFs) {
      _userFs = userFs;
      _fetchEvents();
    });
  }

  */ /*
   * here we fetch the events from the firestore
   */ /*
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

  */ /*
   * adding favorites to the events list
   */ /*
  _addFavorite(int index) async {
    _changeFavoriteStatusInEventsList(index);

    if (await AppUtils.checkNetworkAvailability()) {
      if (events[index].isFavorite) {
        repository
            .addFavorite(events[index], _user)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index);
        });
      } else {
        repository
            .removeFavorite(events[index].id, _user)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index);
        });
      }
    } else {
      _delegate.onError("No Internet");
      _changeFavoriteStatusInEventsList(index);
    }
  }

  // as objects from built value gen are immutable, we create a new object with the
  // toggled fav value at an index. Add that to the events list and then remove the old one.
  _changeFavoriteStatusInEventsList(int index) {
    var eventNew = events[index]
        .rebuild((event) => event..isFavorite = !events[index].isFavorite);

    events.insert(index, eventNew);
    events.removeAt(index + 1);

    _eventListController.add(events);
  }

  */ /*
   * method to handle the add sinks for the interests page(individual interest tile tap, final submission)
   */ /*
  void addItem(AddItemDelegate delegate) {
    _delegate = delegate;
  }*/
}
