import 'package:flutter/material.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/src/app_bloc.dart';
import 'package:flutter_events/pojo/Interest.dart';
import 'package:flutter_events/widgets/interest_grid_item.dart';
import 'dart:collection';
import 'package:flutter_events/widgets/loading_info.dart';

import 'package:flutter_events/widgets/primary_btn.dart';

class Interests extends StatefulWidget {
  final EventsBloc _bloc;

  Interests(this._bloc);

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> implements AddItemDelegate {

  BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget._bloc.listenToInterests();
    widget._bloc.initSelectInterestsStreams();
    widget._bloc.initInterestBtnStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Interests',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      body: LoadingInfo(
        isLoading: widget._bloc.isLoading,
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: widget._bloc.interestList,
                initialData: UnmodifiableListView<Interest>([]),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Interest>> snapshots) {
                  _context = context;
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0),
                      itemCount: snapshots.data.length,
                      padding:
                          const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 65),
                      itemBuilder: (context, position) {
                        print("grid position $position");
                        return InterestGridItem(
                            snapshots.data[position].interestImage,
                            snapshots.data[position].interestName,
                            _onInterestTapped,
                            snapshots.data[position].isSelected,
                            position
                        );
                      });
                }),

            Align(
              alignment: Alignment.bottomCenter,
              child: PrimaryGradientButton("Let's Start!", _onButtonClicked, true),
            )
          ],
        ),
      ),
    );
  }

  void _onInterestTapped(int position) {

    widget._bloc.addItem(position, this, AddSinkType.interestType);
    //widget._bloc.interestSelection.add(position);
  }

  void _onButtonClicked()
  {
    //Navigator.pushReplacementNamed(context, '/home');
    print('btn clicked');
    widget._bloc.addItem(true, this, AddSinkType.saveInterests);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget._bloc.disposeInterestStreams();
  }

  @override
  void onError(String message) {
    final snackbar = SnackBar(content: Text(message));

    Scaffold.of(_context).showSnackBar(snackbar);
  }

  @override
  void onSuccess() {
    // TODO: implement onSuccess
  }
}
