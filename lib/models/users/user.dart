import 'package:equatable/equatable.dart';

class User extends Equatable
{
  final String name;
  final String email;
  final String phoneNumber;
  final String password;


  User({this.name, this.email, this.phoneNumber, this.password}) : super([name, email, phoneNumber, password]);

}