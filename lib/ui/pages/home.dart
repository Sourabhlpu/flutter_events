import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc/bloc.dart';
import 'package:flutter_events/blocs/home_bloc/bloc.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/ui/pages/profile.dart';
import 'package:flutter_events/ui/widgets/card_item_home.dart';
import 'package:flutter_events/ui/widgets/loading_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  final HomeBloc bloc;
  final AppRepository repository;
  final ApplicationBloc applicationBloc;

  HomePage({@required this.repository, @required this.applicationBloc})
      : bloc = HomeBloc(repository: repository) {}

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _currentBottomBarIndex = 0;
  TabController _tabController;

  HomeBloc _bloc;

  @override
  void initState() {
    _bloc = widget.bloc;
    _tabController = TabController(length: _getTabs().length, vsync: this);
    _bloc.dispatch(FetchRecommendedList());
    _bloc.dispatch(FetchUpcomingList());
    _bloc.dispatch(FetchPopularList());
    _bloc.dispatch(FetchEventList());
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

  _getBody() {
    if (_currentBottomBarIndex == 3) {
      return ProfilePage();
    } else {
      return _getHomeForBottomNav();
    }
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

  _getHomeForBottomNav() {
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Welcome',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: _getTabs(),
            controller: _tabController,
            isScrollable: true,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: BlocListener(
            bloc: _bloc,
            listener: (context, HomeState state) {
              if (state.isError) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if(state.selectedEvent != null)
                {
                  _openEventDetailsScreen(state.selectedEvent);
                }
            },
            child: BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, HomeState state) {
                  return TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      _getTab(state.loadingRecommended, state.recommended, 0),
                      _getTab(state.loadingUpcoming, state.upcoming, 1),
                      _getTab(state.loadingPopular, state.popular, 2),
                      _getTab(state.loadAll, state.all, 3)
                    ],
                  );
                })),
      );
  }

  Tab _getTab(bool isLoading, List<Event> events, int tabIndex) {
    return Tab(
      child: LoadingInfo(
          isLoading: isLoading,
          child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                return CardListItem(
                    events[index], _onCardItemTapped, tabIndex, index, _bloc);
              })),
    );
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

  _onCardItemTapped(int index, Event event, BuildContext context) {

    _bloc.dispatch(DetailsPageOpened(index: index, tabIndex: _tabController.index));

  }

  _setCurrentBottomBarIndex(int index) {
    _currentBottomBarIndex = index;
  }

  _openEventDetailsScreen(Event selectedEvent) async
  {

    await Navigator.pushNamed(
      context,
      '/event_details',
      arguments: selectedEvent,
    );

    _bloc.dispatch(DetailsPageClosed());

  }
}
