import 'package:flutter/material.dart';
import 'package:flutter_events/pages/intro.dart';
import 'package:flutter_events/pages/auth.dart';
import 'package:flutter_events/utils/custom_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/src/app_bloc.dart';
import 'package:flutter_events/pages/interests.dart';

void main() {
  EventsBloc eventsBloc = EventsBloc();
  runApp(MyApp(eventsBloc));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final EventsBloc _bloc;

  MyApp(this._bloc);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/auth': (context) => Authentication(_bloc),
          '/interests': (context) => Interests(_bloc),
        },
        home: _handleHomeScreen());
  }

  Widget _handleHomeScreen() {
    return StreamBuilder<CurrentHome>(
      stream: _bloc.currentHome,
      initialData: CurrentHome.noPage,
      builder: (BuildContext context, AsyncSnapshot<CurrentHome> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == CurrentHome.introPage) {
            return IntroPage(_bloc);
          } else if (snapshot.data == CurrentHome.authPage) {
            return Authentication(_bloc);
          } else if (snapshot.data == CurrentHome.interestsPage) {
            return Interests(_bloc);
          }
          else if(snapshot.data == CurrentHome.noPage)
            {
              return Container();
            }
        }
      },
    );
  }
}
