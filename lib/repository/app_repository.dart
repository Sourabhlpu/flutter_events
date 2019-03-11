import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_events/models/events.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_events/models/serializers.dart';

class AppRepository {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;



  CollectionReference refUser = firestore.collection("users");
  CollectionReference refEvents = firestore.collection("events");
  SharedPreferences prefs;
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

  Future<FirebaseUser> signInWithEmailPassword(User user) {
    return firebaseAuth.signInWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  Future<FirebaseUser> signInWithPhoneNumber(User user) {
    //refUser
  }

  signUpUser(User user) {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((user) {});
  }

  Future<List<Events>> getEventsList() async {
    List<Events> events = List<Events>();

    return await refEvents.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((snapshot) {
        Events event = standardSerializers.deserializeWith(Events.serializer, snapshot.data);
        events.add(event);
      });
      return events;
    });
  }

  void addFavorite(Events event)
  {

  }
}

AppRepository repository = AppRepository();
