import 'package:flutter/material.dart';
import '../widgets/add_splash.dart';

class ProfilePage extends StatelessWidget {
  List<String> _interests = [
    'technology',
    'music',
    'food',
    'science',
    'cars',
    'nature',
    'culture',
    'social',
    'animals',
    'sports'
  ];

  List<String> _profileActions = [
    'My Events',
    'Organise event',
    'List your space',
    'FAQ',
    "About Let's Meet",
    'Sign out'
  ];

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
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      NetworkImage('https://picsum.photos/200/300'),
                ),
                title: Text(
                  'Sourabh Pal',
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
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your Interests',
                style: TextStyle(fontFamily: 'AvenirLight', fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Container(
                height: 30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _interests.length,
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
                          : _buildInterestButton(_interests[index]);
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2 * _profileActions.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index.isEven) {
                      double realProfileActionListIndex = index / 2;
                      return AddSplash(
                        onTap: (){

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                              _profileActions[realProfileActionListIndex.toInt()]),
                        ),
                      );
                    } else
                      return Divider(
                        height: 1,
                        color: Colors.grey,
                      );
                  }),
            )
          ],
        ),
      ),
    );
  }

  _buildInterestButton(String interest) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AddSplash(
        onTap: (){},
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
}
