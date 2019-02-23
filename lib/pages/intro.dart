import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/widgets/primary_btn.dart';
import 'package:flutter_events/widgets/intro_screen.dart';
import 'package:flutter_events/widgets/intro_page_indicators.dart';
import 'package:flutter_events/src/app_bloc.dart';


class IntroPage extends StatefulWidget {
  final EventsBloc _bloc;

  IntroPage(this._bloc);
  @override
  State createState() => IntroPageState();
}


class IntroPageState extends State<IntroPage> {
  final PageController _pagecontroller = new PageController(initialPage: 0);
  int _currentPage = 0;

  void _openAuthScreen()
  {
    widget._bloc.setPrefsBool('shouldShowIntro', false);
    Navigator.pushReplacementNamed(context, '/auth');

  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        body: Stack(
          children: <Widget>[
            PageView(
                controller: _pagecontroller,
                onPageChanged: (int i) {
                  setState(() {
                    _currentPage = i;
                  });
                },
                children: [
                  IntroPageItem('images/discover.png', 'Discover Event',
                      'There are many variations of passages of Lorem ipsum available'),
                  IntroPageItem('images/create.png', 'Create Event',
                      'There are many variations of passages of Lorem ipsum available'),
                  IntroPageItem('images/book.png', 'Book Events',
                      'There are many variations of passages of Lorem ipsum available'),
                ]),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CircularPageIndicators(
                      currentPage: _currentPage,
                    ),
                    SizedBox(
                      width: 0,
                      height: 8.0,
                    ),
                    PrimaryGradientButton('Get Started', _openAuthScreen)
                  ],
                )),

            /*Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryGradientButton('Get Started')),*/
          ],
        ));
  }
}