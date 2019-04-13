import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/auth_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/blocs/create_event_bloc.dart';
import 'package:flutter_events/blocs/home_bloc.dart';
import 'package:flutter_events/blocs/interests_bloc.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/ui/pages/create_event.dart';
import 'package:flutter_events/ui/pages/event_details.dart';
import 'package:flutter_events/ui/pages/intro.dart';
import 'package:flutter_events/ui/pages/auth.dart';
import 'package:flutter_events/utils/custom_colors.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_events/ui/pages/interests.dart';
import 'package:flutter_events/ui/pages/home.dart';
import 'package:google_places_picker/google_places_picker.dart';

void main() {
  /* debugPaintSizeEnabled=true;*/
  runApp(BlocProvider<ApplicationBloc>(
    bloc: ApplicationBloc(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  AppRepository _repository = AppRepository();

  @override
  Widget build(BuildContext context) {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.white, //or set color with: Color(0xFF0000FF)
    ));*/

    PluginGooglePlacePicker.initialize(
      androidApiKey: "AIzaSyAwXVF-Nlee02gd98JazpI75qWT2Hy4h7U",
      iosApiKey: "AIzaSyAwXVF-Nlee02gd98JazpI75qWT2Hy4h7U",
    );

    var bloc = BlocProvider.of<ApplicationBloc>(context);

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
          '/auth': (context) => Authentication(repository: repository),
          '/interests': (context) => BlocProvider<InterestsBloc>(
                bloc: InterestsBloc(),
                child: Interests(),
              ),
          '/home': (context) => BlocProvider<HomeBloc>(
                bloc: HomeBloc(bloc),
                child: HomePage(),
              ),
          '/create_event': (context) => CreateEvent(appRepository: _repository)
        },
        home: _handleHomeScreen(context, bloc));
  }

  Widget _handleHomeScreen(BuildContext context, ApplicationBloc bloc) {
    return StreamBuilder<CurrentHome>(
      stream: BlocProvider.of<ApplicationBloc>(context).currentHome,
      initialData: CurrentHome.noPage,
      builder: (BuildContext context, AsyncSnapshot<CurrentHome> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == CurrentHome.introPage) {
            return IntroPage();
          } else if (snapshot.data == CurrentHome.authPage) {
            return Authentication(repository: repository);
          } else if (snapshot.data == CurrentHome.interestsPage) {
            return BlocProvider<InterestsBloc>(
              bloc: InterestsBloc(),
              child: Interests(),
            );
          } else if (snapshot.data == CurrentHome.homePage) {
            return BlocProvider<HomeBloc>(
              bloc: HomeBloc(bloc),
              child: HomePage(),
            );
          } else if (snapshot.data == CurrentHome.noPage) {
            return Container();
          }
        }
      },
    );
  }
}
