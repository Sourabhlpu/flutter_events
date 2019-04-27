import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/events/auth_events.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/states/auth_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthenticationEvents, AuthenticationStates> {
  final AppRepository repository;
  StreamSubscription signinSubscription;
  StreamSubscription signupSubscription;

  AuthBloc({@required this.repository});

  @override
  AuthenticationStates get initialState => InitialState();

  @override
  Stream<AuthenticationStates> mapEventToState(
      AuthenticationEvents event) async* {
    if (event is LoginButtonPressed) {
      yield* _mapLoginPressedToState(event.user);
    }

    if (event is SignupPressed) {
      yield* _mapSignupPressedToState(event.user);
    }

    if (event is AuthErrorEvent) {
      yield AuthError(error: event.error);
    }

    if (event is SigninSuccessEvent) {
      yield SigninSuccess();
    }

    if (event is SignupSuccessEvent) {
      yield SignupSuccess();
    }
  }

  Stream<AuthenticationStates> _mapLoginPressedToState(User user) async* {
    yield Loading();
    if (await AppUtils.checkNetworkAvailability()) {
      if (user.email.isEmpty && user.phoneNumber.isNotEmpty) {
        //TODO ADD PHONE AUTHENTICATION
      } else {
        signinSubscription?.cancel();
        signinSubscription = repository
            .signInWithEmailPassword(user)
            .asStream()
            .handleError(_handleAuthError)
            .listen((firebaseUser) {
          repository.addUserToRemoteDb(user).whenComplete(() {
            dispatch(SigninSuccessEvent());
          });
        });
      }
    } else {
      yield AuthError(error: "No Internet");
    }
  }

  Stream<AuthenticationStates> _mapSignupPressedToState(User user) async* {
    yield Loading();

    if (await AppUtils.checkNetworkAvailability()) {
      signupSubscription?.cancel();
      signupSubscription = repository
          .signUpWithEmailPassword(user)
          .asStream()
          .handleError(_handleAuthError)
          .listen((firebaseUser) {
        repository.addUserToRemoteDb(user).whenComplete(() {
          dispatch(SignupSuccessEvent());
        });
      });
    } else {
      yield AuthError(error: "No Internet");
    }
  }

  _handleAuthError(error) {
    if (error is PlatformException) {
      final _error = error as PlatformException;
      dispatch(AuthErrorEvent(error: _error.message));
    }
  }

  @override
  void dispose() {
    super.dispose();
    signinSubscription.cancel();
    signupSubscription.cancel();
  }
}
