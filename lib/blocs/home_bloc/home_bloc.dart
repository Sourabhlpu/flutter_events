import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_events/blocs/home_bloc/home_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/blocs/home_bloc/home_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';


class HomeBloc extends Bloc<HomeEvents, HomeState> {
  AppRepository repository;
  UserFireStore _userFs;
  StreamSubscription streamSubscriptionUpcoming;
  StreamSubscription streamSubscriptionRecommended;
  StreamSubscription streamSubscriptionAll;

  HomeBloc({@required this.repository})
      : _userFs = repository.getUserFsFromPrefs();

  @override
  HomeState get initialState => HomeState.initialState();

  @override
  Stream<HomeState> mapEventToState(HomeEvents event) async* {
    if (event is FetchEventList) {
      yield* _fetchAllEvents();
    }

    if (event is FetchRecommendedList) {
      yield* _fetchRecommendedEvents();
    }

    if (event is FetchUpcomingList) {
      yield* _fetchUpcomingList();
    }

    if (event is FavoriteButtonTapped) {
      yield* _manageFavorite(event.index, event.tabIndex);
    }

    if (event is ListLoadedEvent) {
      yield currentState.update(all: event.events, loadAll: false);
    }

    if (event is RecommendedListLoadedEvent) {
      yield currentState.update(
          recommended: event.events, loadingRecommended: false);
    }

    if (event is UpcomingListLoadedEvent) {
      yield currentState.update(upcoming: event.events, loadingUpcoming: false);
    }

    if (event is PopularListLoadedEvent) {
      yield currentState.update(popular: event.events, loadingPopular: false);
    }

    if (event is ListLoadingErrorEvent) {
      yield currentState.update(isError: true, error: event.error);
    }

    if (event is DetailsPageOpened) {
      yield currentState.update(
          selectedEvent: _getEventList(event.tabIndex)[event.index]);
    }

    if (event is DetailsPageClosed) {
      yield currentState.update(selectedEvent: null);
    }

    if (event is BookEventTapped) {
      yield* _manageBooking();
    }

    if (event is ShowAddCardDialog) {

      yield ShowAddCardDialogState(showDialog: true);
      //doing this show that this is reset to false and we can again open the dialog next time.
      // as in the bloc currentState and nextState are compared before yielding states.
      yield ShowAddCardDialogState(showDialog: false);

    }

    if(event is CardAdded)
      {

      }
  }

  Stream<HomeState> _fetchAllEvents() async* {
    yield currentState.update(loadAll: true);
    if (await AppUtils.checkNetworkAvailability()) {
      streamSubscriptionAll?.cancel();

      streamSubscriptionAll = repository
          .getEventsList(_userFs)
          .asStream()
          .handleError(_handleError)
          .listen((events) {
        dispatch(ListLoadedEvent(events: events));
      });
    } else {
      yield currentState.update(isError: true, error: 'No Internet');
    }
  }

  Stream<HomeState> _fetchRecommendedEvents() async* {
    yield currentState.update(loadingRecommended: true);
    if (await AppUtils.checkNetworkAvailability()) {
      streamSubscriptionRecommended?.cancel();

      streamSubscriptionRecommended = repository
          .getEventsList(_userFs)
          .asStream()
          .handleError(_handleError)
          .listen((events) {
        dispatch(RecommendedListLoadedEvent(
            events: _getRecommendedList(events, _userFs)));
      });
    } else {
      yield currentState.update(isError: true, error: 'No Internet');
    }
  }

  Stream<HomeState> _fetchUpcomingList() async* {
    yield currentState.update(loadingUpcoming: true);

    if (await AppUtils.checkNetworkAvailability()) {
      streamSubscriptionUpcoming?.cancel();

      streamSubscriptionUpcoming = repository
          .getUpcomingEvents(_userFs)
          .asStream()
          .handleError(_handleError)
          .listen((events) {
        dispatch(UpcomingListLoadedEvent(events: events));
      });
    } else {
      yield currentState.update(isError: true, error: 'No Internet');
    }
  }

  Stream<HomeState> _manageFavorite(int index, int tabIndex) async* {
    _changeFavoriteStatusInEventsList(index, tabIndex);

    List<Event> events = _getEventList(tabIndex);

    if (await AppUtils.checkNetworkAvailability()) {
      if (events[index].isFavorite) {
        repository
            .addFavorite(events[index], _userFs)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index, tabIndex);
        });
      } else {
        repository
            .removeFavorite(events[index].id, _userFs)
            .then((_) {})
            .catchError(() {
          _changeFavoriteStatusInEventsList(index, tabIndex);
        });
      }
    } else {
      _handleError("No Internet");
      _changeFavoriteStatusInEventsList(index, tabIndex);
    }
  }

  Stream<HomeState> _manageBooking() async* {

    repository.isCardSaved(_userFs).then((isCardSaved) {
      if (isCardSaved) {
        //show a dialog to confirm payment with the card number;

      } else {
        // show a dialog to enter card details;
        dispatch(ShowAddCardDialog());

      }
    });
  }

  List<Event> _getEventList(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return currentState.recommended;
        break;
      case 1:
        return currentState.upcoming;
        break;
      case 2:
        return currentState.popular;
        break;
      case 3:
        return currentState.all;
        break;
    }
  }

  // as objects from built value gen are immutable, we create a new object with the
  // toggled fav value at an index. Add that to the events list and then remove the old one.\

  _changeFavoriteStatusInEventsList(int index, int tabIndex) {
    var events = _getEventList(tabIndex);

    var eventNew = events[index]
        .rebuild((event) => event..isFavorite = !events[index].isFavorite);

    events.insert(index, eventNew);
    events.removeAt(index + 1);

    _dispatchUpdatedList(tabIndex, events);
  }

  _dispatchUpdatedList(int tabIndex, List<Event> events) {
    switch (tabIndex) {
      case 0:
        dispatch(RecommendedListLoadedEvent(events: List.from(events)));
        break;
      case 1:
        dispatch(UpcomingListLoadedEvent(events: List.from(events)));
        break;
      case 2:
        dispatch(PopularListLoadedEvent(events: List.from(events)));
        break;
      case 3:
        dispatch(ListLoadedEvent(events: List.from(events)));
        break;
    }
  }

  void _handleError(String error) {
    dispatch(ListLoadingErrorEvent(error: error.toString()));
  }

  _getRecommendedList(List<Event> events, UserFireStore userFs) {
    events.retainWhere((event) {
      return event.eventType.any((type) {
        return userFs.interests.contains(type);
      });
    });

    return events;
  }
}
