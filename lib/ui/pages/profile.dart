import 'package:built_collection/src/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/utils/transparent_route.dart';
import '../widgets/add_splash.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import '../widgets/horizontal_list_with_title.dart';
import 'package:flutter_events/models/interests/interest.dart';

class ProfilePage extends StatefulWidget {
  List<String> _profileActions = [
    'My Events',
    'Organise event',
    'List your space',
    'FAQ',
    "About Let's Meet",
    'Sign out'
  ];

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  ApplicationBloc _applicationBloc;

  _getInterestsList(BuiltList<String> interests) {
    return interests
        .map((interest) => Interest((b) => b
          ..interestName = interest
          ..isSelected = false))
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _applicationBloc = BlocProvider.of<ApplicationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildUserImageTile(_applicationBloc.userFs),
            _getHorizontalDivider(),
            HorizontalListWithTitle(
                title: 'Interests',
                list: _getInterestsList(_applicationBloc.getUserFirestore().interests),  //todo remove this and use streams to fetch the list later
                isListExpandable: true),
            _buildProfileActionList()
          ],
        ),
      ),
    );
  }

  _openImageDialog(BuildContext c) {
    Navigator.push(
        context,
        new TransparentRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                    width: 200,
                    height: 200,
                    child: Hero(
                      tag: 'tag',
                      child: Image.network(
                        'https://picsum.photos/200/300',
                        width: 200,
                        height: 200,
                        fit: BoxFit.fill,
                      ),
                    )),
              );
            }));
  }

  _buildUserImageTile(UserFireStore data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      child: ListTile(
        onTap: () {
          _openImageDialog(context);
        },
        contentPadding: const EdgeInsets.all(8.0),
        leading: Hero(
          tag: 'tag',
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://picsum.photos/200/300'),
          ),
        ),
        title: Text(
          data == null ? '' : data.name,
          style: TextStyle(fontFamily: 'AvenirMedium'),
        ),
        subtitle: Text(
          'Upload photo',
          style: TextStyle(
              color: Colors.pinkAccent,
              fontFamily: 'AvenirLight',
              fontSize: 12),
        ),
      ),
    );
  }

  _getHorizontalDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  _buildProfileActionList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2 * widget._profileActions.length - 1,
          itemBuilder: (BuildContext context, int index) {
            if (index.isEven) {
              double realProfileActionListIndex = index / 2;
              return AddSplash(
                onTap: () {
                  _handleProfileActionTap(index, context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(widget
                      ._profileActions[realProfileActionListIndex.toInt()]),
                ),
              );
            } else
              return Divider(
                height: 1,
                color: Colors.grey,
              );
          }),
    );
  }

  _handleProfileActionTap(int index, BuildContext context) {
    if (index.isEven && index == 2) {
      _openCreateEventPage(context);
    }
  }

  _openCreateEventPage(BuildContext context) {
    Navigator.pushNamed(context, '/create_event');
  }
}
