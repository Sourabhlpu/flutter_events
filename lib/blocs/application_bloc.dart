import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/events/application_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/application_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc extends Bloc<ApplicationEvents, ApplicationStates> {
  FirebaseUser user;
  UserFireStore userFs;
  final AppRepository repository;
  StreamSubscription authStateSubscription;

  ApplicationBloc({@required this.repository});

  set userFirestore(UserFireStore userFs) {
    this.userFs = userFs;
  }

  @override
  // TODO: implement initialState
  get initialState => Initializing();

  @override
  Stream<ApplicationStates> mapEventToState(ApplicationEvents event) async* {
    // TODO: implement mapEventToState
    if (event is AppStarted) {
      _getAuthStatus();
    }

    if (event is UserAuthenticatedEvent) {
      yield UserAuthenticated(showInterestsScreen: event.showInterestsScreen);
    }

    if (event is UserUnauthenticatedEvent) {
      yield UserUnauthenticated(showIntro: event.showIntro);
    }

    if (event is IntroScreenButtonTapped) {
      _setPreference('shouldShowIntro', false);
    }
  }

  _getAuthStatus() {
    authStateSubscription?.cancel();

    authStateSubscription = repository.firebaseAuth.onAuthStateChanged
        .handleError(onError)
        .listen((firebaseUser) {
      user = firebaseUser;

      _setLandingPage();
      authStateSubscription?.cancel();
    });
  }

  _setLandingPage() {
    if (currentState is Initializing && _isUserAuthenticated()) {
      _openHomePage();
    } else if (currentState is Initializing) {
      dispatch(UserUnauthenticatedEvent(showIntro: _shouldShowIntroPage()));
    }
  }

  _openHomePage() {
    dispatch(UserAuthenticatedEvent(
        showInterestsScreen: _shouldShowInterestsPage()));
  }

  bool _isUserAuthenticated() {
    return user != null;
  }

  _getUserFromFirestore() async {
    repository.getUserFromDb(user.email).then((userFs) {
      userFirestore = userFs;
      _openHomePage();
    });
  }

  bool _shouldShowIntroPage() {
    return _getBoolFromPreference('shouldShowIntro');
  }

  bool _getBoolFromPreference(String key) {
    return repository.getBoolFromPrefs(key);
  }

  _setPreference(String key, var value) {
    repository.setPrefsBool(key, value);
  }

  _shouldShowInterestsPage() {
    return repository.getBoolFromPrefs("showInterestsSelection");
  }

  UserFireStore getUserFirestore()
  {
    return repository.getUserFsFromPrefs();
  }
}
