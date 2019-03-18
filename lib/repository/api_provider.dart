import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/models/Interest.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/models/serializers.dart';
import 'package:flutter_events/models/user.dart';
import 'package:flutter_events/models/user_fs.dart';

class ApiProvider {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;

  CollectionReference refUser = firestore.collection("user");
  CollectionReference refEvents = firestore.collection("events");

  Future<FirebaseUser> signInWithEmailPassword(User user) {
    return firebaseAuth.signInWithEmailAndPassword(
        email: user.email, password: user.password);
  }

  Future<FirebaseUser> signUpUser(User user) {
    return firebaseAuth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((user) {});
  }

  Future<List<Interest>> fetchInterests() {

    List<Interest> interests = List<Interest>();



    return firestore.collection("interests").getDocuments().then((snapshot){
      snapshot.documents.forEach((document){
        interests.add(Interest(document['interestImage'],
            document['interestName'], false, document.documentID));
      });

      return interests;
    });




  /*  return firestore.collection('interests').getDocuments().then((snapshot){
      return snapshot.documents
          .map((document) => Interest(document['interestImage'],
          document['interestName'], false, document.documentID))
          .toList();
    }).catchError((error){
      print(error);
    });*/
 /*   firestore
        .collection('interests')
        .getDocuments()
        .asStream()
        .listen((snapshot) {

      return snapshot.documents
          .map((document) => Interest(document['interestImage'],
              document['interestName'], false, document.documentID))
          .toList();
    });*/
  }

  getEventsList(UserFireStore userFs) {
    List<Events> events = List<Events>();

    return  refEvents.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((snapshot) {
        Map<String, String> map = {'id': snapshot.documentID};
        snapshot.data.addAll(map);

        if(userFs.favorites != null && userFs.favorites.contains(snapshot.documentID))
          snapshot.data['isFavorite'] = true;
        Events event = standardSerializers.deserializeWith(Events.serializer, snapshot.data);
        events.add(event);
      });
      return events;
    });
  }

  Future<void> saveInterests(List<String> interests, FirebaseUser user) {

    Map<String, dynamic> data = {
      'interests' : interests
    };
    return refUser.document(user.email).setData(data, merge: true);
  }

  Future<void> addUserToFirestore(User user) {
   return  refUser.document(user.email).setData({
      'name' : user.name,
      'email': user.email,
      'phoneNumber': user.phoneNumber
    });
  }

  Future<void> addFavorite(Events event, FirebaseUser user) {

    List<String> eventId = [event.id];

    return refUser.document(user.email).updateData({
      'favorites': FieldValue.arrayUnion(eventId)
    });
  }

  Future<void> removeFavorite(String eventId, FirebaseUser user)
  {
    List<String> event = List<String>();
    event.add(eventId);
   return  refUser.document(user.email).updateData({
      'favorites': FieldValue.arrayRemove(event)
    }).catchError((error){
      print(error.toString());
   });
  }

  Future<UserFireStore> getUserFromFirestore(FirebaseUser user) {

    return refUser.document(user.email).get().then((snapshots){

      return UserFireStore.fromJson(snapshots.data);
    });
  }
}
