import 'package:flutter/material.dart';
import 'package:flutter_events/models/event.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/ui/widgets/card_item_home.dart';
import 'package:flutter_events/ui/widgets/loading_info.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_events/blocs/home_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1));
    _bloc = BlocProvider.of<HomeBloc>(context);

  }
  @override
  Widget build(BuildContext context) {
    _onCardItemTapped(int index, Events event) {
      print("card $index tapped");
      Navigator.pushNamed(context, '/event_details', arguments: event);
    }

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
              tabs: [
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
              ],
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.grey,
                    ),
                    title: Text(
                      'Home',
                      style: TextStyle(color: Colors.grey),
                    )),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Explore',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.ticketAlt, color: Colors.grey),
                  title: Text(
                    'My Tickets',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    FontAwesomeIcons.userCircle,
                    color: Colors.grey,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ]),
          body: LoadingInfo(
            isLoading: _bloc.isLoading,
            child: TabBarView(children: [
              Tab(
                child: StreamBuilder(
                  initialData: List<Events>(),
                  stream: _bloc.eventList,
                  builder: (context, AsyncSnapshot<List<Events>> snapshots) {

                    if(snapshots.hasData && snapshots.data.length > 0)
                      {
                        return ListView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (BuildContext context, int index) {
                              return CardListItem(
                                  snapshots.data[index], _onCardItemTapped, index, _bloc);
                            });
                      }

                      else
                        {
                          return Container();
                        }

                  }
                ),
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
          )),
    );
  }
}
