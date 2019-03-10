import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/auth_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/blocs/home_bloc.dart';
import 'package:flutter_events/blocs/interests_bloc.dart';
import 'package:flutter_events/models/event.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/ui/pages/event_details.dart';
import 'package:flutter_events/ui/pages/intro.dart';
import 'package:flutter_events/ui/pages/auth.dart';
import 'package:flutter_events/utils/custom_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_events/ui/pages/interests.dart';
import 'package:flutter_events/ui/pages/home.dart';

void main() {
  /* debugPaintSizeEnabled=true;*/
  runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));*/

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: customPrimaryColor,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings)
        {
          String routeName = settings.name;

          if(routeName == '/event_details')
            {
              if(settings.arguments is Events)
                {
                  Events event = settings.arguments as Events;
                  return MaterialPageRoute(builder: (BuildContext context) => EventDetail(event));
                }

            }

            return null;
        },
        routes: {
          '/auth': (context) => BlocProvider<AuthBloc>(
                bloc: AuthBloc(),
                child: Authentication(),
              ),
          '/interests': (context) => BlocProvider<InterestsBloc>(
                bloc: InterestsBloc(),
                child: Interests(),
              ),
          '/home': (context) => HomePage(),
        },
        home: _handleHomeScreen(context));
  }

  Widget _handleHomeScreen(BuildContext context) {
    return StreamBuilder<CurrentHome>(
      stream: BlocProvider.of<ApplicationBloc>(context).currentHome,
      initialData: CurrentHome.noPage,
      builder: (BuildContext context, AsyncSnapshot<CurrentHome> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == CurrentHome.introPage) {
            return IntroPage();
          } else if (snapshot.data == CurrentHome.authPage) {
            return BlocProvider<AuthBloc>(
              bloc: AuthBloc(),
              child: Authentication(),
            );
          } else if (snapshot.data == CurrentHome.interestsPage) {
            return BlocProvider<InterestsBloc>(
              bloc: InterestsBloc(),
              child: Interests(),
            );
          }
          else if(snapshot.data == CurrentHome.homePage)
            {
              return BlocProvider<HomeBloc>(
                bloc: HomeBloc(),
                child: HomePage(),
              );
            }
          else if (snapshot.data == CurrentHome.noPage) {
            return Container();
          }
        }
      },
    );
  }
}
