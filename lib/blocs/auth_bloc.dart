import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:rxdart/rxdart.dart';

class AuthBloc implements BlocBase {
  //this is the sink that tells to do the sign up when the user presses the signup btn
  Sink<User> get doSignup => _signupController.sink;
  final _signupController = StreamController<User>();

  //this is the sink that tells to do the sign in when the user presses the signin btn
  Sink<User> get doSignin => _signinController.sink;
  final _signinController = StreamController<User>();

  // the stream to manage the showing of loader when the we are hitting the api.
  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  /*
   * an interface that allows callback to the widget that is adding sinks to sign in and signiup
   * to handle the success and errors, when then navigates or shows errors respectively.
   */
  AddItemDelegate _delegate;

  AuthBloc() {
    _listenSignIn();
    _listenSignup();
  }

  @override
  void dispose() {
    _signinController.close();
    _signupController.close();
    _isLoadingSubject.close();
  }

  /*
  * this method is listening to the signin stream. When the user taps on the signin btn this method gets called.
   */
  void _listenSignIn() {
    _signinController.stream.listen((user) async {
      _isLoadingSubject.add(true);

      if (await _checkNetworkAvailability()) {
        if (user.email.isEmpty && user.phoneNumber.isNotEmpty) {
          //TODO ADD PHONE AUTHENTICATION
        } else {
          _signinWithEmail(user);
        }
      } else {
        _isLoadingSubject.add(false);
        _delegate.onError("No Internet");

        //throw Exception('No Internet');
      }
    });
  }

  /*
   * this method calls the repository to sign in a user
   */
  void _signinWithEmail(User user) {
    repository.signInWithEmailPassword(user).then((firebaseUser) {
      _handleSAuthSuccess(firebaseUser, SuccessType.successSign);
    }).catchError(_handleAuthError);
  }

  void _signupWithEmailPassword(User user) async {
    _isLoadingSubject.add(true);
    if (await _checkNetworkAvailability()) {
      repository.signUpWithEmailPassword(user).then((firebaseUser) {
        _isLoadingSubject.add(false);
        _handleSAuthSuccess(firebaseUser, SuccessType.successSignup);

        //after the user is signed up successfully we need to add the user to the
        // user document in the firestore database.
        repository.addUserToRemoteDb(user).catchError(_handleAuthError);
      }).catchError(_handleAuthError);
    } else {
      _delegate.onError("No Internet");
      _isLoadingSubject.add(false);
    }
  }

  /*
   * similar to signin here we are listening to the signup stream and this method
   * gets called when user taps on signup btn.
   */
  void _listenSignup() {
    _signupController.stream.listen((user) async {
      _signupWithEmailPassword(user);
    });
  }

  /*
   * this method handles the error on the sign and signup methods and sends a callback
   * to the calling widget i.e. auth page to show the authentication errors
   */
  void _handleAuthError(error) {
    _isLoadingSubject.add(false);
    if (error is PlatformException) {
      final _error = error as PlatformException;
      _delegate.onError(_error.message);
    }
  }

  /*
   * this method handles the auth success and then passes the success type(sign in or signup)
   * to  the delegate to navigate to the right pages
   */
  _handleSAuthSuccess(FirebaseUser value, SuccessType type) {
    _isLoadingSubject.add(false);
    _delegate.onSuccess(type);
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

  /*
   * this method is called when we want to add to sinks and initialize the callback.
   * here the sign in and signup sinks are added.
   */
  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;

    if (type == AddSinkType.signIn)
      doSignin.add(item);
    else if (type == AddSinkType.signUp) doSignup.add(item);
  }
}
