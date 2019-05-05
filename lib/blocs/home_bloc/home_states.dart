
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

  class HomeState {
    final bool initial;
    final bool loadingRecommended;
    final bool loadingUpcoming;
    final bool loadingPopular;
    final bool loadAll;
    final bool isError;
    final String error;
    final List<Event> recommended;
    final List<Event> upcoming;
    final List<Event> popular;
    final List<Event> all;

    HomeState(
        {this.initial = false,
          this.loadingRecommended = false,
          this.loadingUpcoming = false,
          this.loadingPopular = false,
          this.loadAll = false,
          this.error = "",
          this.isError = false,
          this.recommended = const [],
          this.upcoming = const [],
          this.popular = const [],
          this.all = const []});

    HomeState copyWith({
      bool initial,
      bool loadingRecommended,
      bool loadingUpcoming,
      bool loadingPopular,
      bool loadAll,
      bool isError,
      String error,
      List<Event> recommended,
      List<Event> upcoming,
      List<Event> popular,
      List<Event> all,
    }) {
      return HomeState(
          initial: initial ?? this.initial,
          loadingRecommended: loadingRecommended ?? this.loadingRecommended,
          loadingUpcoming: loadingUpcoming ?? this.loadingUpcoming,
          loadingPopular: loadingPopular ?? this.loadingPopular,
          loadAll: loadAll ?? this.loadAll,
          isError: isError ?? this.isError,
          error: error ?? this.error,
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
        recommended: recommended,
        upcoming: upcoming,
        popular: popular,
        all: all
      );
    }

    factory HomeState.initialState() {
      return HomeState(
          initial: true,
          isError: false);
    }
  }





  /*class HomeStateUninitialized extends HomeState {
    @override
    String toString() => "Uninitialized";
  }

  class Loading extends HomeState {
    @override
    String toString() => "Loading";
  }

  class ListLoaded extends HomeState {
    List<Event> events;

    ListLoaded({this.events}) : super([events]);

    @override
    String toString() => "List loaded";
  }

  class ListLoadingError extends HomeState {
    String error;

    ListLoadingError({this.error}) : super([error]);

    @override
    String toString() => "Error in fetching list";
  }*/
