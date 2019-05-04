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
      : bloc = HomeBloc(repository: repository) {
    bloc.dispatch(FetchEventList());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentBottomBarIndex = 0;

  HomeBloc get _bloc => widget.bloc;

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
        body: TabBarView(children: [
          Tab(
            child: BlocListener(
                bloc: _bloc,
                listener: (context, HomeState state) {

                  if (state is ListLoadingError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<HomeEvents, HomeState>(
                    bloc: _bloc,
                    builder: (BuildContext context, HomeState state) {


                      return LoadingInfo(
                        isLoading: state is Loading,
                        child: state is ListLoaded
                            ? ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: state.events.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CardListItem(state.events[index],
                                      _onCardItemTapped, index, _bloc);
                                })
                            : Container(),
                      );
                    })),
          ),
          Tab(
            child: BlocListener(
                bloc: _bloc,
                listener: (context, HomeState state) {

                  if (state is ListLoadingError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<HomeEvents, HomeState>(
                    bloc: _bloc,
                    builder: (BuildContext context, HomeState state) {


                      return LoadingInfo(
                        isLoading: state is Loading,
                        child: state is ListLoaded
                            ? ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.events.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CardListItem(state.events[index],
                                  _onCardItemTapped, index, _bloc);
                            })
                            : Container(),
                      );
                    })),
          ),
          Tab(
            child: BlocListener(
                bloc: _bloc,
                listener: (context, HomeState state) {

                  if (state is ListLoadingError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<HomeEvents, HomeState>(
                    bloc: _bloc,
                    builder: (BuildContext context, HomeState state) {


                      return LoadingInfo(
                        isLoading: state is Loading,
                        child: state is ListLoaded
                            ? ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.events.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CardListItem(state.events[index],
                                  _onCardItemTapped, index, _bloc);
                            })
                            : Container(),
                      );
                    })),
          ),
          Tab(
            child: BlocListener(
                bloc: _bloc,
                listener: (context, HomeState state) {

                  if (state is ListLoadingError) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${state.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: BlocBuilder<HomeEvents, HomeState>(
                    bloc: _bloc,
                    builder: (BuildContext context, HomeState state) {


                      return LoadingInfo(
                        isLoading: state is Loading,
                        child: state is ListLoaded
                            ? ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.events.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CardListItem(state.events[index],
                                  _onCardItemTapped, index, _bloc);
                            })
                            : Container(),
                      );
                    })),
          ),
        ]),
      ),
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
    Navigator.pushNamed(context, '/event_details', arguments: event);
  }


  _setCurrentBottomBarIndex(int index) {
    _currentBottomBarIndex = index;
  }
}
