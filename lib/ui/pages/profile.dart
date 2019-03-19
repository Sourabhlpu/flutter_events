import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/utils/transparent_route.dart';
import '../widgets/add_splash.dart';
import 'package:flutter_events/models/users/user_fs.dart';

class ProfilePage extends StatefulWidget {
  List<dynamic> _interests = [];

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
        child: StreamBuilder(
            stream: _applicationBloc.userFirestore,
            builder: (context, AsyncSnapshot<UserFireStore> snapshot) {
              if (snapshot.hasData) {
                widget._interests = snapshot.data.interests;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildUserImageTile(snapshot.data),
                  _getHorizontalDivider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Your Interests',
                      style: TextStyle(fontFamily: 'AvenirLight', fontSize: 12),
                    ),
                  ),
                  _buildHorizontalInterestsList(),
                  _buildProfileActionList()
                ],
              );
            }),
      ),
    );
  }

  _buildInterestButton(String interest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AddSplash(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.grey, width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              interest,
              style: TextStyle(fontFamily: 'AvenirLight', fontSize: 14),
            ),
          )),
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

  _buildHorizontalInterestsList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget._interests.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return index == 0
                  ? Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xFFDF69DD),
                                const Color(0xFFED5D66)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: Center(
                          child: IconButton(
                              icon: Icon(Icons.add),
                              iconSize: 15,
                              color: Colors.white,
                              onPressed: () {})),
                    )
                  : _buildInterestButton(widget._interests[index - 1]);
            }),
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
                onTap: (){
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
