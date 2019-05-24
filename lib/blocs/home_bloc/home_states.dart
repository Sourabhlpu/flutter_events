import 'package:equatable/equatable.dart';
import 'package:flutter_events/models/events/event.dart';

enum LoadingType {
  notLoading,
  notLoadingRecommended,
  notLoadingUpcoming,
  notLoadingPopular,
  loadingRecommended,
  loadingUpcoming,
  loadingPopular,
  loadingAll,
}

class HomeState extends Equatable {
  bool initial;
  bool loadingRecommended;
  bool loadingUpcoming;
  bool loadingPopular;
  bool loadAll;
  bool isError;
  String error;
  Event selectedEvent;
  List<Event> recommended;
  List<Event> upcoming;
  List<Event> popular;
  List<Event> all;

  HomeState([List props = const []]) : super([props]);

  HomeState.updateConstructor(
      {this.initial = false,
      this.loadingRecommended = false,
      this.loadingUpcoming = false,
      this.loadingPopular = false,
      this.loadAll = false,
      this.error = "",
      this.isError = false,
      this.selectedEvent,
      this.recommended = const [],
      this.upcoming = const [],
      this.popular = const [],
      this.all = const []})
      : super([
          initial,
          loadingRecommended,
          loadingUpcoming,
          loadingPopular,
          loadAll,
          error,
          selectedEvent,
          recommended,
          upcoming,
          popular,
          all
        ]);

  HomeState copyWith({
    bool initial,
    bool loadingRecommended,
    bool loadingUpcoming,
    bool loadingPopular,
    bool loadAll,
    bool isError,
    String error,
    Event selectedEvent,
    List<Event> recommended,
    List<Event> upcoming,
    List<Event> popular,
    List<Event> all,
  }) {
    return HomeState.updateConstructor(
        initial: initial ?? this.initial,
        loadingRecommended: loadingRecommended ?? this.loadingRecommended,
        loadingUpcoming: loadingUpcoming ?? this.loadingUpcoming,
        loadingPopular: loadingPopular ?? this.loadingPopular,
        loadAll: loadAll ?? this.loadAll,
        isError: isError ?? this.isError,
        error: error ?? this.error,
        selectedEvent:
            selectedEvent, // this can be null when we go back to the home page from the details page
        recommended: recommended ?? this.recommended,
        upcoming: upcoming ?? this.upcoming,
        popular: popular ?? this.popular,
        all: all ?? this.all);
  }

  HomeState update({
    bool initial,
    bool loadingRecommended,
    bool loadingUpcoming,
    bool loadingPopular,
    bool loadAll,
    bool isError,
    String error,
    Event selectedEvent,
    List<Event> recommended,
    List<Event> upcoming,
    List<Event> popular,
    List<Event> all,
  }) {
    return copyWith(
        initial: initial,
        loadingRecommended: loadingRecommended,
        loadingPopular: loadingPopular,
        loadingUpcoming: loadingUpcoming,
        loadAll: loadAll,
        isError: isError,
        error: error,
        selectedEvent: selectedEvent,
        recommended: recommended,
        upcoming: upcoming,
        popular: popular,
        all: all);
  }

  factory HomeState.initialState() {
    return HomeState.updateConstructor(initial: true, isError: false);
  }
}

class ShowAddCardDialogState extends HomeState {

  final bool showDialog;

  ShowAddCardDialogState({this.showDialog = false}) : super([showDialog]);


  @override
  String toString() => "show add card dialog";
}
