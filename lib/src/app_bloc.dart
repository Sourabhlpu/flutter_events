import 'package:flutter/services.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/src/user.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_events/pojo/Interest.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:collection';

enum CurrentHome {
  noPage,
  introPage,
  interestsPage,
  authPage,
}

enum AddSinkType { signIn, signUp, interestType, saveInterests }

class EventsBloc {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Firestore _firestore = Firestore.instance;

  FirebaseUser user;

  List<Interest> _interests;

  AddItemDelegate _delegate;

  Sink<User> get doSignup => _signupController.sink;
  final _signupController = StreamController<User>();

  Sink<User> get doSignin => _signinController.sink;
  final _signinController = StreamController<User>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  Sink<bool> get shouldShowIntro => _shouldShowIntroSubject.sink;
  final _shouldShowIntroSubject = StreamController<bool>();

  Stream<CurrentHome> get currentHome => _currentHomeController.stream;
  final _currentHomeController =
      BehaviorSubject<CurrentHome>(seedValue: CurrentHome.noPage);

  Stream<UnmodifiableListView<Interest>> get interestList =>
      _interestListController.stream;
  final _interestListController =
      BehaviorSubject<UnmodifiableListView<Interest>>();

  Sink<int> get interestSelection => _interestSelectionController.sink;
  final _interestSelectionController = StreamController<int>();

  Sink<bool> get interestBtn => _interestsBtnController.sink;
  final _interestsBtnController = StreamController<bool>();

  SharedPreferences prefs;

  EventsBloc() {
    _initPrefs();

    _listenSignIn();

    _listenSignup();

    _shouldShowIntroSubject.stream.listen((showIntro) {});

    _listenFirebaseAuth();
  }

  bool _getBoolFromPrefs(String key) {
    return prefs.getBool(key);
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.get('shouldShowIntro') == null) {
      prefs.setBool('shouldShowIntro', true);
    }
  }

  void setPrefsBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  void listenToInterests() {
    _isLoadingSubject.add(true);
    _firestore
        .collection('interests')
        .getDocuments()
        .asStream()
        .listen((snapshot) {
      _interests = snapshot.documents
          .map((document) => Interest(
              document['interestImage'], document['interestName'], false))
          .toList();

      _interestListController.sink.add(UnmodifiableListView(_interests));
      _isLoadingSubject.add(false);
    });
  }

  void initSelectInterestsStreams() {
    _interestSelectionController.stream.listen((index) {
      _interests[index].setIsSelected = !_interests[index].isSelected;

      _interestListController.add(UnmodifiableListView(_interests));
    });
  }

  void initInterestBtnStream() {
    _interestsBtnController.stream.listen((value) {
      bool _isInterestSelected = false;


      for (Interest interest in _interests) {
        if (interest.isSelected) {
          _isInterestSelected = true;
          return;
        } else {
          _isInterestSelected = false;
        }
      }

      if (!_isInterestSelected)
        _delegate.onError("Select atleast one interest");
      else
        {
          //_firestore.collection("user").document()
        }
    });
  }

  void _listenFirebaseAuth() {
    _firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser != null) {
         user = firebaseUser;
        _currentHomeController.add(CurrentHome.interestsPage);
      } else {
        if (_getBoolFromPrefs('shouldShowIntro')) {
          _currentHomeController.add(CurrentHome.introPage);
        } else {
          _currentHomeController.add(CurrentHome.authPage);
        }
      }
    }).onError(_handleAuthError);
  }

  void _listenSignIn() {
    _signinController.stream.listen((user) async {
      _isLoadingSubject.add(true);

      bool _networkAvailable = await _checkNetworkAvailability();
      if (_networkAvailable) {
        if (user.email.isEmpty && user.phoneNumber.isNotEmpty) {
          _firestore
              .collection('user')
              .where('phone', isEqualTo: user.phoneNumber)
              .getDocuments();
        } else {
          _firebaseAuth
              .signInWithEmailAndPassword(
                  email: user.email, password: user.password)
              .catchError(_handleAuthError);
        }
      } else {
        /*_isNetworkAvailableSubject.add(false);*/
        _isLoadingSubject.add(false);
        _delegate.onError("No Internet");

        //throw Exception('No Internet');
      }
    });
  }

  void _listenSignup() {
    _signupController.stream.listen((user) async {
      _isLoadingSubject.add(true);

      bool _networkAvailable = await _checkNetworkAvailability();

      if (_networkAvailable) {
        _firebaseAuth
            .createUserWithEmailAndPassword(
                email: user.email, password: user.password)
            .catchError(_handleAuthError)
            .then((firebaseUser) {
          _isLoadingSubject.add(false);
          _firestore.collection('user').document().setData({
            'email': user.email,
            'phone': user.phoneNumber,
            'name': user.name
          });
        });
      } else {
        _delegate.onError("No Internet");
        _isLoadingSubject.add(false);
      }
    });
  }

  void _handleAuthError(error) {
    print(error);
    _isLoadingSubject.add(false);
    if (error is PlatformException) {
      final _error = error as PlatformException;
      _delegate.onError(_error.message);
    }
  }

  Future<bool> _checkNetworkAvailability() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.

      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      return false;
    }
  }

  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;

    if (type == AddSinkType.signIn)
      doSignin.add(item);
    else if (type == AddSinkType.signUp)
      doSignup.add(item);
    else if (type == AddSinkType.interestType)
      interestSelection.add(item);
    else if (type == AddSinkType.saveInterests) interestBtn.add(item);
  }

  void disposeAuthStreams() {
    _signupController.close();
    _signinController.close();
  }

  void disposeInterestStreams() {
    _interestListController.close();
    _interestSelectionController.close();
    _interests = null;
  }
}
