import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/events/auth_events.dart';
import 'package:flutter_events/models/serializers.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/auth_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';

class AuthBloc extends Bloc<AuthenticationEvents, AuthenticationStates> {
  final AppRepository repository;
  final ApplicationBloc applicationBloc;
  StreamSubscription signinSubscription;
  StreamSubscription signupSubscription;
  StreamSubscription googleSinginSubscription;

  AuthBloc({@required this.repository, @required this.applicationBloc});

  @override
  AuthenticationStates get initialState => InitialState();

  @override
  void dispose() {
    super.dispose();
    signinSubscription.cancel();
    signupSubscription.cancel();
  }

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
      yield SigninSuccess(shouldInterests: event.shouldShowInterests);
    }

    if (event is SignupSuccessEvent) {
      yield SignupSuccess();
    }

    if (event is SignInWithGooglePressed) {}
  }

  _handleAuthError(error) {
    if (error is PlatformException) {
      final _error = error as PlatformException;
      dispatch(AuthErrorEvent(error: _error.message));
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
          repository.getUserFromDb(firebaseUser.email).then((userFirestore) {
            //applicationBloc.userFs = userFirestore;
            repository.saveUserFsToPrefs(userFirestore);
            dispatch(SigninSuccessEvent(
                shouldShowInterests:
                    _shouldShowInterestsScreen(userFirestore)));
          });
        });
      }
    } else {
      yield AuthError(error: "No Internet");
    }
  }

  Stream<AuthenticationStates> _mapSignInWithGooglToState() async* {
    yield Loading();

    if (await AppUtils.checkNetworkAvailability()) {
      googleSinginSubscription = repository
          .signinWithGoogle()
          .asStream()
          .handleError(_handleAuthError)
          .listen((googleSignInAccount) {
        User user = User(
            name: googleSignInAccount.displayName,
            email: googleSignInAccount.email);

        repository.addUserToRemoteDb(user).then((doesUserExist) {});
      });
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
        repository.addUserToRemoteDb(user).then((value) {
          repository.setPrefsBool("showInterestsSelection", true);
          dispatch(SignupSuccessEvent());
        });
      });
    } else {
      yield AuthError(error: "No Internet");
    }
  }

  _shouldShowInterestsScreen(UserFireStore userFs) {

    bool showInterests = userFs.interests == null || (userFs != null && userFs.interests.isEmpty);

    repository.setPrefsBool("showInterestsSelection", showInterests);

    return showInterests;
  }
}
