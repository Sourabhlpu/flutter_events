import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/blocs/interests_bloc.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/ui/widgets/interest_grid_item.dart';
import 'dart:collection';
import 'package:flutter_events/ui/widgets/loading_info.dart';

import 'package:flutter_events/ui/widgets/primary_btn.dart';

class Interests extends StatefulWidget {


  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> implements AddItemDelegate {

  BuildContext _context;

  InterestsBloc _bloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bloc = BlocProvider.of<InterestsBloc>(context);

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
        isLoading: _bloc.isLoading,
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: _bloc.interestList,
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
                      itemCount:  snapshots.data.length,
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

   _bloc.addItem(position, this, AddSinkType.interestType);
    //widget._bloc.interestSelection.add(position);
  }

  void _onButtonClicked()
  {
    Navigator.pushReplacementNamed(context, '/home');
    print('btn clicked');
    _bloc.addItem(true, this, AddSinkType.saveInterests);
  }


  @override
  void onError(String message) {
    final snackbar = SnackBar(content: Text(message));

    Scaffold.of(_context).showSnackBar(snackbar);
  }

  @override
  void onSuccess(SuccessType type) {
    // TODO: implement onSuccess
  }
}
