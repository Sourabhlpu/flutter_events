import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/serializers.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/api_provider.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';

class AppRepository {
  final FirebaseAuth firebaseAuth;
  final Firestore firestore;

  CollectionReference refUser;
  CollectionReference refEvents;

  SharedPreferences prefs;

  final apiProvider = ApiProvider();

  AppRepository({@required this.firebaseAuth, @required this.firestore})
      : refUser = firestore.collection("user"),
        refEvents = firestore.collection("events") {
    _initPrefs();
  }

  bool getBoolFromPrefs(String key) {

    return prefs.getBool(key);
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.get('shouldShowIntro') == null) {
      prefs.setBool('shouldShowIntro', true);
    }

    if(prefs.get('showInterestsSelection') == null) {

      prefs.setBool('showInterestsSelection', false);
    }
  }

  void setPrefsBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  void setPrefString(String key, String value){
    prefs.setString("userFirestore", value);
  }

  void saveUserFsToPrefs(UserFireStore userFs)
  {

    Map userFsMap = standardSerializers.serializeWith(
        UserFireStore.serializer, userFs);

    String userFsString = json.encode(userFsMap);

    prefs.setString('userFs', userFsString);

  }

  UserFireStore getUserFsFromPrefs()
  {
    String userFs = prefs.get('userFs');

    Map userFsMap = json.decode(userFs);

    return standardSerializers.deserializeWith(UserFireStore.serializer, userFsMap);
  }


  Future<FirebaseUser> signInWithEmailPassword(User user) =>
      apiProvider.signInWithEmailPassword(user);

  Future<FirebaseUser> signUpWithEmailPassword(User user) =>
      apiProvider.signUpUser(user);

  Future<void> addUserToRemoteDb(User user) =>
      apiProvider.addUserToFirestore(user);

  Future<UnmodifiableListView<Interest>> fetchInterests() =>
      apiProvider.fetchInterests();

  Future<void> saveInterests(List<String> interests, FirebaseUser user) =>
      apiProvider.saveInterests(interests, user);

  Future<List<Event>> getEventsList(UserFireStore userFs) =>
      apiProvider.getEventsList(userFs);

  Future<void> addFavorite(Event event, UserFireStore user) =>
      apiProvider.addFavorite(event, user);

  Future<void> removeFavorite(String eventId, UserFireStore user) =>
      apiProvider.removeFavorite(eventId, user);

  Future<UserFireStore> getUserFromDb(String email) =>
      apiProvider.getUserFromFirestore(email);

  Stream<StorageTaskEvent> uploadFile(File file) =>
      apiProvider.uploadImage(file);

  Future<void> createEvent(Event event) => apiProvider.createEvent(event);

  Future<GoogleSignInAccount> signinWithGoogle() => apiProvider.signInWithGoogle();
}

