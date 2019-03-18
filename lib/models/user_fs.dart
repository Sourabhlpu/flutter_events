class UserFireStore
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

}
