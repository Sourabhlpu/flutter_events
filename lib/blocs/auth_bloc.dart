import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/models/user.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc implements BlocBase{

  Sink<User> get doSignup => _signupController.sink;
  final _signupController = StreamController<User>();

  Sink<User> get doSignin => _signinController.sink;
  final _signinController = StreamController<User>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  AddItemDelegate _delegate;

  AuthBloc()
  {
    _listenSignIn();
    _listenSignup();


  }


  @override
  void dispose() {
    // TODO: implement dispose
    _signinController.close();
    _signupController.close();
    _isLoadingSubject.close();
  }

  void _listenSignIn() {
    _signinController.stream.listen((user) async {
      _isLoadingSubject.add(true);

      bool _networkAvailable = await _checkNetworkAvailability();
      if (_networkAvailable) {
        if (user.email.isEmpty && user.phoneNumber.isNotEmpty) {
          AppRepository.firestore
              .collection('user')
              .where('phone', isEqualTo: user.phoneNumber)
              .getDocuments();
        } else {
          /*AppRepository.firebaseAuth
              .signInWithEmailAndPassword(
              email: user.email, password: user.password)
              .then((firebaseUser){
                _handleSignInSuccess(firebaseUser, SuccessType.successSign);
          })
              .catchError(_handleAuthError);*/

          _signinWithEmail(user);


        }
      } else {
        /*_isNetworkAvailableSubject.add(false);*/
        _isLoadingSubject.add(false);
        _delegate.onError("No Internet");

        //throw Exception('No Internet');
      }
    });
  }

  void _signinWithEmail(User user)
  {
    repository.signInWithEmailPassword(user).then((firebaseUser){
      _handleSignInSuccess(firebaseUser, SuccessType.successSign);
    })
        .catchError(_handleAuthError);
  }

  void _listenSignup() {
    _signupController.stream.listen((user) async {
      _isLoadingSubject.add(true);

      bool _networkAvailable = await _checkNetworkAvailability();

      if (_networkAvailable) {
        AppRepository.firebaseAuth
            .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
            .catchError(_handleAuthError)
            .then((firebaseUser) {
          _isLoadingSubject.add(false);
          _handleSignInSuccess(firebaseUser, SuccessType.successSignup);
          AppRepository.firestore.collection('user').document().setData({
            'email': user.email,
            'phone': user.phoneNumber,
            'name': user.name
          }).catchError(_handleAuthError);
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
  }


   _handleSignInSuccess(FirebaseUser value, SuccessType type) {

    _isLoadingSubject.add(false);
    _delegate.onSuccess(type);
  }
}