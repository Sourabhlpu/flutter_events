import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_events/models/events/event.dart';


class AppRepository {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;

  CollectionReference refUser = firestore.collection("user");
  CollectionReference refEvents = firestore.collection("events");
  SharedPreferences prefs;

  final apiProvider = ApiProvider();

  AppRepository() {
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
  }

  void setPrefsBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  Future<FirebaseUser> signInWithEmailPassword(User user) =>
      apiProvider.signInWithEmailPassword(user);

  Future<FirebaseUser> signUpWithEmailPassword(User user) =>
      apiProvider.signUpUser(user);

  Future<void> addUserToRemoteDb(User user) => apiProvider.addUserToFirestore(user);

  Future<List<Interest>> fetchInterests() => apiProvider.fetchInterests();

  Future<void> saveInterests(List<String> interests, FirebaseUser user) => apiProvider.saveInterests(interests, user);

  Future<List<Event>> getEventsList(UserFireStore userFs) => apiProvider.getEventsList(userFs);

  Future<void> addFavorite(Event event, FirebaseUser user)  => apiProvider.addFavorite(event,user);

  Future<void> removeFavorite(String eventId, FirebaseUser user)  => apiProvider.removeFavorite(eventId,user);

  Future<UserFireStore> getUserFromDb(FirebaseUser user) => apiProvider.getUserFromFirestore(user);


}


AppRepository repository = AppRepository();
