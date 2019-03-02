import 'package:flutter/material.dart';
import 'package:flutter_events/pojo/event.dart';

class HomePage extends StatefulWidget {
  final _bloc;

  HomePage(this._bloc);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
          body: TabBarView(children: [
            Tab(
              child: ListView.builder(
                  itemCount: events.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                            alignment: Alignment.topCenter,
                            placeholder: placeholder,
                            image: events[index].image,
                            fit: BoxFit.fill,
                            height: 200,
                          ),
                        ],
                      ),
                    );
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
          ])),
    );
  }
}
