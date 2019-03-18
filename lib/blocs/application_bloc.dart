import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/models/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:rxdart/rxdart.dart';

enum CurrentHome { noPage, introPage, interestsPage, authPage, homePage }

enum AddSinkType { signIn, signUp, interestType, saveInterests }

class ApplicationBloc implements BlocBase {
  static FirebaseUser user;

  static UserFireStore userFs;



  AppRepository repository = new AppRepository();

  //This stream will decide what will be displayed as the home screen depending upon the auth status

  Stream<CurrentHome> get currentHome => _currentHomeController.stream;
  final _currentHomeController =
      BehaviorSubject<CurrentHome>(seedValue: CurrentHome.noPage);

  // This is the input sink to set the status of should show intro screen. This sets the preference value when the get started
  // button is clicked in the intro screens.
  Sink<bool> get shouldShowIntro => _shouldShowIntroSubject.sink;
  final _shouldShowIntroSubject = StreamController<bool>();

  Stream<FirebaseUser> get firebaseUser => _userController.stream;
  final _userController = BehaviorSubject<FirebaseUser>();

  Stream<UserFireStore> get userFirestore => _userFirestoreController.stream;
  final _userFirestoreController = BehaviorSubject<UserFireStore>();



  ApplicationBloc() {
    _onFirebaseAuthenticationChanged();
    _onGetStartedClickedFromIntro();
  }

  void _onGetStartedClickedFromIntro() {
    _shouldShowIntroSubject.stream.listen((value) {
      _setPreference('shouldShowIntro', value);
    });
  }

  /*
   * This method is listening to the auth status from firebase. When the status changes we show the home screen accordingly
   */
  void _onFirebaseAuthenticationChanged() {
    AppRepository.firebaseAuth.onAuthStateChanged.listen((firebaseUser) async {
      user = firebaseUser;
      _userController.add(firebaseUser);
      _getUserFromFirestore();

      _setLandingPage();
    });
  }

  _setLandingPage() {
    if (_isUserAuthenticated()) {
      _openHomePage();
    } else {
      if (_shouldShowIntroPage()) {
        _openIntroPage();
      } else
        _openAuthPage();
    }
  }

  _openHomePage() {
    _currentHomeController.add(CurrentHome.homePage);
  }

  _openAuthPage() {
    _currentHomeController.add(CurrentHome.authPage);
  }

  _openIntroPage() {
    _currentHomeController.add(CurrentHome.introPage);
  }

  bool _isUserAuthenticated() {
    return user != null;
  }

  bool _shouldShowIntroPage() {
    return _getBoolFromPreference('shouldShowIntro');
  }

  _setPreference(String key, var value) {
    repository.setPrefsBool(key, value);
  }

  bool _getBoolFromPreference(String key) {
    return repository.getBoolFromPrefs(key);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _currentHomeController.close();
    _shouldShowIntroSubject.close();
    _userFirestoreController.close();
    _userController.close();
  }

  _getUserFromFirestore() async {
    userFs = await repository.getUserFromDb(user);
    _userFirestoreController.add(userFs);
  }
}
