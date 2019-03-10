import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:rxdart/rxdart.dart';

enum CurrentHome {
  noPage,
  introPage,
  interestsPage,
  authPage,
  homePage
}

enum AddSinkType { signIn, signUp, interestType, saveInterests }

class ApplicationBloc implements BlocBase {

  FirebaseUser user;

  AppRepository repository = new AppRepository();



  //This stream will decide what will be displayed as the home screen depending upon the auth status

  Stream<CurrentHome> get currentHome => _currentHomeController.stream;
  final _currentHomeController = BehaviorSubject<CurrentHome>(seedValue: CurrentHome.noPage);

  Sink<bool> get shouldShowIntro => _shouldShowIntroSubject.sink;
  final _shouldShowIntroSubject = StreamController<bool>();

  ApplicationBloc()
  {
    _listenFirebaseAuth();

   _listenIntroBtn();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _currentHomeController.close();
    _shouldShowIntroSubject.close();

  }

  /*
   * This method is listening to the auth status from firebase. When the status changes we show the home screen accordingly
   */
  void _listenFirebaseAuth() {
    AppRepository.firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
        user = firebaseUser;
        _currentHomeController.add(CurrentHome.homePage);
      } else {
        if (repository.getBoolFromPrefs('shouldShowIntro')) {
          _currentHomeController.add(CurrentHome.introPage);
        } else {
          _currentHomeController.add(CurrentHome.authPage);
        }
      }
    });
  }


  void _listenIntroBtn()
  {

    _shouldShowIntroSubject.stream.listen((value){

      repository.setPrefsBool('shouldShowIntro', value);
    });

  }


 
}
