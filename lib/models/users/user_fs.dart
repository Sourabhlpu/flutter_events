import 'package:built_value/serializer.dart';
import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'user_fs.g.dart';
/*class UserFireStore
{
  final String name;
  final String email;
  final String phone;
  final List<dynamic> interests;
  final List<dynamic> favorites;

  UserFireStore(this.name, this.email, this.phone, this.interests, this.favorites);

  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'phone' : phone,
    'interests' : interests,
    'favorites' : favorites
  };


  UserFireStore.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        interests = json['interests'],
        favorites = json['favorites'];

}*/

abstract class UserFireStore implements Built<UserFireStore, UserFireStoreBuilder> {

  static Serializer<UserFireStore> get serializer => _$userFireStoreSerializer;

   @nullable
   String get name;
   @nullable
   String get email;
   @nullable
   String get phone;
   @nullable
   BuiltList<String> get interests;
   @nullable
   BuiltList<String> get favorites;
   @nullable
   bool get hasPayment;

  UserFireStore._();
  factory UserFireStore([updates(UserFireStoreBuilder b)]) = _$UserFireStore;
}
