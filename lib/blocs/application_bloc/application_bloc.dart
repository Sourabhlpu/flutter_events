import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:flutter_events/blocs/application_bloc/bloc.dart';

class ApplicationBloc extends Bloc<ApplicationEvents, ApplicationStates> {
  FirebaseUser user;
  UserFireStore userFs;
  GoogleSignInAccount googleSignInAccount;
  final AppRepository repository;
  StreamSubscription authStateSubscription;
  StreamSubscription googleAuthStateSubscription;

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
    return (user != null || repository.getBoolFromPrefs("isGoogleAuthenticated"));
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

  @override
  void dispose() {
    authStateSubscription.cancel();
    googleAuthStateSubscription.cancel();
  }


}
