import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/blocs/interests_bloc.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/events/select_interest_events.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/select_interest_states.dart';
import 'package:flutter_events/ui/widgets/interest_grid_item.dart';
import 'package:flutter_events/ui/widgets/loading_info.dart';
import 'package:flutter_events/ui/widgets/primary_btn.dart';

class Interests extends StatefulWidget {
  final ApplicationBloc applicationBloc;
  final AppRepository repository;
  final InterestsBloc bloc;

  Interests({@required this.repository, @required this.applicationBloc})
      : bloc = InterestsBloc(
            repository: repository, applicationBloc: applicationBloc) {
    bloc.dispatch(FetchList());
  }

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {

  InterestsBloc get _bloc => widget.bloc;

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
        body: BlocListener(
          bloc: _bloc,
          listener: (BuildContext context, SelectInterestStates state) {
            if (state is GenericError) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ));
            }

            if (state is InterestSaved) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: BlocBuilder(
              bloc: _bloc,
              builder: (BuildContext context, SelectInterestStates state) {
                return LoadingInfo(
                  isLoading: state is Loading,
                  child: Stack(
                    children: <Widget>[
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                  mainAxisSpacing: 16.0,
                                  crossAxisSpacing: 16.0),
                          itemCount:
                              state is ListLoaded ? state.interests.length : 0,
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 16.0, bottom: 65),
                          itemBuilder: (context, position) {
                            if (state is ListLoaded) {
                              return InterestGridItem(
                                  state.interests[position].interestImage,
                                  state.interests[position].interestName,
                                  _onInterestTapped,
                                  state.interests[position].isSelected,
                                  position);
                            }
                            return Container();
                          }),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: PrimaryGradientButton(
                            "Let's Start!", _onButtonClicked, true),
                      )
                    ],
                  ),
                );
              }),
        ));
  }

  void _onButtonClicked() {
    _bloc.dispatch(LetsStartTapped());
  }

  void _onInterestTapped(int position) {
    _bloc.dispatch(InterestTapped(index: position));
  }
}
