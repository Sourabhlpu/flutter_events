import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:flutter_events/blocs/home_bloc/home_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/blocs/home_bloc/home_states.dart';
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
        dispatch(ListLoadedEvent(events: _getRecommendedList(events, _userFs)));
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

  _getRecommendedList(List<Event> events, UserFireStore userFs)
  {

    events.retainWhere((event) {
      return event.eventType.any((type) {
        return userFs.interests.contains(type);
      });
    });

    return events;

  }
}
