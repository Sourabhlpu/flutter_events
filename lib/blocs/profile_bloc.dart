import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/models/users/user_fs.dart';

class ProfileBloc{

  UserFireStore _userFireStore;

  ProfileBloc()
  {
    _getUserFirestore();
  }

  _getUserFirestore()
  {
    /*ApplicationBloc.userFirestore.listen((userFireStore){

      _userFireStore = userFireStore;
    });*/
  }
}