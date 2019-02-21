import 'package:flutter/material.dart';
import 'package:flutter_events/src/app_bloc.dart';
import 'package:flutter_events/pojo/Interest.dart';

class Interests extends StatefulWidget {
  final EventsBloc _bloc;

  Interests(this._bloc);

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._bloc.listenToInterests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Interests',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: widget._bloc.interestList,
          initialData: List<Interest>(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Interest>> snapshots) {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshots.data.length,
                padding: const EdgeInsets.only(left: 8, right: 8),
                itemBuilder: (context, position) {
                  return Stack(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: FadeInImage.assetNetwork(
                                placeholder: 'images/placeholder.png',
                                image:
                                    'https://navimumbai.com/wp-content/uploads/2018/04/tech.jpg',
                              height: 140,
                              fit: BoxFit.fill, ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(snapshots.data[position].interestName),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Checkbox(value: true, onChanged: (_){

                        }),
                      )
                    ],
                  );
                });
          }),
    );
  }
}
