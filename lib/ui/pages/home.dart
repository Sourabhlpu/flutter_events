import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/ui/pages/profile.dart';
import 'package:flutter_events/ui/widgets/card_item_home.dart';
import 'package:flutter_events/ui/widgets/loading_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_events/blocs/home_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements AddItemDelegate {
  HomeBloc _bloc;
  BuildContext _snackbarContext;
  int _currentBottomBarIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = BlocProvider.of<HomeBloc>(context);
    _bloc.addItem(this);
  }

  _onCardItemTapped(int index, Event event, BuildContext context) {
    Navigator.pushNamed(context, '/event_details', arguments: event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentBottomBarIndex,
            type: BottomNavigationBarType.fixed,
            onTap: ((index) {
              setState(() {
                _setCurrentBottomBarIndex(index);
              });
            }),
            items: _getBottomNavigationBarItems()),
        body: _getBody());
  }

  List<Widget> _getTabs() {
    return [
      Tab(
        text: 'Recommended',
      ),
      Tab(
        text: 'Upcoming',
      ),
      Tab(
        text: 'Popular',
      ),
      Tab(
        text: 'All',
      )
    ];
  }

  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            'Home',
            style: TextStyle(color: Colors.grey),
          )),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.search,
        ),
        title: Text(
          'Explore',
          style: TextStyle(),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.ticketAlt),
        title: Text(
          'My Tickets',
          style: TextStyle(),
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(
          FontAwesomeIcons.userCircle,
        ),
        title: Text(
          'Profile',
          style: TextStyle(),
        ),
      ),
    ];
  }

  _setCurrentBottomBarIndex(int index) {
    _currentBottomBarIndex = index;
  }

  @override
  void onError(String message) {
    // TODO: implement onError
    final snackbar = SnackBar(content: Text(message));

    Scaffold.of(_snackbarContext).showSnackBar(snackbar);
    print(message);
  }

  @override
  void onSuccess(SuccessType type) {
    // TODO: implement onSuccess
  }

  _getBody() {
    if (_currentBottomBarIndex == 3) {
      return ProfilePage();
    } else {
      return _getHomeForBottomNav();
    }
  }

  _getHomeForBottomNav() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Welcome',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: _getTabs(),
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: LoadingInfo(
          isLoading: false,
          child: TabBarView(children: [
            Tab(
              child: StreamBuilder(
                  initialData: List<Event>(),
                  stream: _bloc.eventList,
                  builder: (context, AsyncSnapshot<List<Event>> snapshots) {
                    _snackbarContext = context;

                    if (snapshots.hasData && snapshots.data.length > 0) {
                      return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: snapshots.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CardListItem(snapshots.data[index],
                                _onCardItemTapped, index, _bloc);
                          });
                    } else {
                      return Container();
                    }
                  }),
            ),
            Tab(
              child: Center(
                child: Text('upcoming'),
              ),
            ),
            Tab(
              child: Center(
                child: Text('popular'),
              ),
            ),
            Tab(
              child: Center(
                child: Text('all'),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
