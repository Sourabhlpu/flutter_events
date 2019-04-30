import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/auth_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/events/select_interest_events.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/select_interest_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class InterestsBloc extends Bloc<SelectInterestEvents, SelectInterestStates> {
  final AppRepository repository;
  final ApplicationBloc applicationBloc;
  final FirebaseUser _user;
  List<Interest> _interests;
  StreamSubscription subscription;

  InterestsBloc({@required this.repository, @required this.applicationBloc})
      : _user = applicationBloc.user;

  @override
  // TODO: implement initialState
  get initialState => Uninitialized();

  @override
  Stream<SelectInterestStates> mapEventToState(
      SelectInterestEvents event) async* {
    // TODO: implement mapEventToState

    if (event is FetchList) {
      yield* _fetchInterests();
    }

    if (event is InterestTapped) {
      yield* _handleInterestSelection(event.index);
    }

    if (event is GenericErrorEvent) {
      yield GenericError(error: "No Internet");
    }

    if (event is ListLoadedEvent) {
      yield ListLoaded(interests: event.interests);
    }

    if (event is LetsStartTapped) {
      yield* _handleLetsStart();
    }

    if (event is InterestsSavedEvent) {
      yield InterestSaved();
    }
  }

  Stream<SelectInterestStates> _fetchInterests() async* {
    yield Loading();

    if (await AppUtils.checkNetworkAvailability()) {
      subscription?.cancel();

      subscription = repository
          .fetchInterests()
          .asStream()
          .handleError(_handleError)
          .listen((interests) {
        _interests = interests;
        dispatch(ListLoadedEvent(interests: interests));
      });
    } else {
      yield GenericError(error: "No Internet");
      if (_interests != null) {
        yield ListLoaded(interests: _interests);
      }
    }
  }

  _getSavedInterestList() {
    List<String> savedInterests = List<String>();

    for (Interest interest in _interests) {
      if (interest.isSelected) {
        savedInterests.add(interest.interestName);
      }
    }

    return savedInterests;
  }

  _handleError(error) {
    dispatch(GenericErrorEvent(error: error.toString()));
  }

  Stream<SelectInterestStates> _handleInterestSelection(int index) async* {
    List<Interest> interests = List.from(_interests);

    Interest interest = _interests[index].rebuild(
        (interest) => interest.isSelected = !_interests[index].isSelected);

    interests.insert(index, interest);
    interests.removeAt(index + 1);

    yield ListLoaded(interests: interests);

    _interests = interests;
  }

  Stream<SelectInterestStates> _handleLetsStart() async* {
    List<String> savedList = _getSavedInterestList();

    if (savedList.isEmpty) {
      yield GenericError(error: "Select at least one interest");
      if (_interests != null) {
        yield ListLoaded(interests: _interests);
      }
    } else {
      if (await AppUtils.checkNetworkAvailability()) {

        UserFireStore userFireStore = repository.getUserFsFromPrefs();
        repository
            .saveInterests(savedList, userFireStore.email)
            .catchError(_handleError)
            .whenComplete(() {
          repository.setPrefsBool("showInterestsSelection", false);

          repository.getUserFromDb(userFireStore.email).then((userFs) {
            repository.saveUserFsToPrefs(userFs);
            dispatch(InterestsSavedEvent());
          });
        });
      } else {
        yield GenericError(error: "No Internet");
        if (_interests != null) {
          yield ListLoaded(interests: _interests);
        }
      }
    }
  }
}
