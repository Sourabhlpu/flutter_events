import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/serializers.dart';
import 'package:flutter_events/models/users/user.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:google_sign_in/google_sign_in.dart';

class ApiProvider {
   final FirebaseAuth firebaseAuth;
   final Firestore firestore;
   final FirebaseStorage firebaseStorage;
   final GoogleSignIn googleSignIn;

   final CollectionReference refUser;
   final CollectionReference refEvents;

  ApiProvider({
    @required this.firebaseAuth,
    @required this.firestore,
    @required this.firebaseStorage,
    this.googleSignIn
  }) : refUser = firestore.collection("user"),
        refEvents = firestore.collection("events");

  Future<GoogleSignInAccount> signInWithGoogle() {
    googleSignIn.signIn();
  }



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

  Future<UnmodifiableListView<Interest>> fetchInterests() {
    List<Interest> interests = List<Interest>();

    return firestore.collection("interests").getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) {
        //adding an id to the interest and then also adding isSelected as false as in
        // built value the initialization of value is not easy.
        Map<String, dynamic> addFieldsToInterests = {
          'id': document.documentID,
          'isSelected': false
        };
        document.data.addAll(addFieldsToInterests);

        Interest interst = standardSerializers.deserializeWith(
            Interest.serializer, document.data);
        interests.add(interst);
      });

      return UnmodifiableListView<Interest>(interests);
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
    List<Event> events = List<Event>();

    return refEvents.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((snapshot) {
        Map<String, dynamic> map = {'id': snapshot.documentID};
        snapshot.data.addAll(map);

        if (userFs.favorites != null &&
            userFs.favorites.contains(snapshot.documentID))
          snapshot.data['isFavorite'] = true;
        Event event = standardSerializers.deserializeWith(
            Event.serializer, snapshot.data);
        events.add(event);
      });
      return events;
    });
  }

  Future<void> saveInterests(List<String> interests, String  email) {
    Map<String, dynamic> data = {'interests': interests};
    return refUser.document(email).setData(data, merge: true);
  }

  Future<bool> addUserToFirestore(User user) {
    return refUser.document(user.email).get().then((document) {
      if (!document.exists) {
        refUser.document(user.email).setData({
          'name': user.name,
          'email': user.email,
          'phoneNumber': user.phoneNumber
        }).then((_) {
          return Future.value(true);
        });
      } else
        return Future.value(false);
    });
  }

  Future<void> addFavorite(Event event, UserFireStore user) {
    List<String> eventId = [event.id];

    return refUser
        .document(user.email)
        .updateData({'favorites': FieldValue.arrayUnion(eventId)});
  }

  Future<void> removeFavorite(String eventId, UserFireStore user) {
    List<String> event = List<String>();
    event.add(eventId);
    return refUser.document(user.email).updateData(
        {'favorites': FieldValue.arrayRemove(event)}).catchError((error) {
      print(error.toString());
    });
  }

  Future<UserFireStore> getUserFromFirestore(String email) {
    return refUser.document(email).get().then((snapshots) {
      return standardSerializers.deserializeWith(
          UserFireStore.serializer, snapshots.data);
    }).catchError((error) {
      print(error);
    });

    /*   refUser.document(email).get().then((snapshots) {
      //return standardSerializers.deserializeWith(UserFireStore.serializer, snapshots.data);
       print(snapshots.data);

    }).catchError((error){

      print(error);
     });*/
  }

  Stream<StorageTaskEvent> uploadImage(File imageFile) {
    final StorageReference ref = firebaseStorage
        .ref()
        .child('event_images/' + p.basename(imageFile.path));

    return ref.putFile(imageFile).events;
  }

  Future<void> createEvent(Event event) {
    return refEvents
        .document()
        .setData(standardSerializers.serializeWith(Event.serializer, event));
  }
}
