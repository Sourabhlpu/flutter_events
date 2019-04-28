import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/events/application_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/application_states.dart';
import 'package:flutter_events/ui/pages/create_event.dart';
import 'package:flutter_events/ui/pages/event_details.dart';
import 'package:flutter_events/ui/pages/intro.dart';
import 'package:flutter_events/ui/pages/auth.dart';
import 'package:flutter_events/utils/custom_colors.dart';
import 'package:flutter_events/ui/pages/interests.dart';
import 'package:flutter_events/ui/pages/home.dart';
import 'package:google_places_picker/google_places_picker.dart';

void main() {
  /* debugPaintSizeEnabled=true;*/
  final Firestore firestore = Firestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  AppRepository repository =
      AppRepository(firebaseAuth: firebaseAuth, firestore: firestore);

  ApplicationBloc applicationBloc = ApplicationBloc(repository: repository);

  runApp(BlocProvider(
      child: MyApp(
        repository: repository,
        bloc: applicationBloc,
      ),
      bloc: applicationBloc));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final AppRepository repository;
  final ApplicationBloc bloc;

  MyApp({@required this.repository, this.bloc}) {
    bloc.dispatch(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));*/

    PluginGooglePlacePicker.initialize(
      androidApiKey: "AIzaSyAwXVF-Nlee02gd98JazpI75qWT2Hy4h7U",
      iosApiKey: "AIzaSyAwXVF-Nlee02gd98JazpI75qWT2Hy4h7U",
    );

    //_initializePlacePicker();

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          String routeName = settings.name;

          if (routeName == '/event_details') {
            if (settings.arguments is Event) {
              Event event = settings.arguments as Event;
              return MaterialPageRoute(
                  builder: (BuildContext context) => EventDetail(event));
            }
          }

          return null;
        },
        routes: {
          '/auth': (context) => Authentication(repository: repository, applicationBloc: bloc,),
          '/interests': (context) =>
              Interests(repository: repository, applicationBloc: bloc),
          '/home': (context) => HomePage(
                repository: repository,
                applicationBloc: bloc,
              ),
          '/create_event': (context) => CreateEvent(appRepository: repository)
        },
        home: _handleHomeScreen(context, bloc));
  }

  Widget _handleHomeScreen(BuildContext context, ApplicationBloc bloc) {
    return BlocBuilder<ApplicationEvents, ApplicationStates>(
      bloc: bloc,
      builder: (BuildContext context, ApplicationStates state) {
        if (state is UserUnauthenticated) {
          if (state.showIntro)
            return IntroPage();
          else
            return Authentication(repository: repository, applicationBloc: bloc,);
        }

        if (state is UserAuthenticated) {
          return state.showInterestsScreen
              ? Interests(repository: repository, applicationBloc: bloc)
              : HomePage(repository: repository, applicationBloc: bloc);
        }

        return Container();
      },
    );
  }
}
