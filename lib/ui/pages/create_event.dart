import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/create_event_bloc.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/ui/pages/create_event_form.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateEvent extends StatefulWidget {
  final AppRepository appRepository;

  CreateEvent({@required this.appRepository}) : assert(appRepository != null);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  CreateEventBloc _createEventBloc;

  ApplicationBloc _applicationBloc;

  AppRepository get _appRepository => widget.appRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.angleLeft),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Create Event',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          return SingleChildScrollView(
              child: CreateEventForm(
            createEventBoc: _createEventBloc,
          ));
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _applicationBloc = BlocProvider.of<ApplicationBloc>(context);
    _createEventBloc = CreateEventBloc(
        applicationBloc: _applicationBloc, repository: _appRepository);
  }
}
