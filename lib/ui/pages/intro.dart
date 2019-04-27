import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/events/application_events.dart';
import 'package:flutter_events/ui/widgets/primary_btn.dart';
import 'package:flutter_events/ui/widgets/intro_screen.dart';
import 'package:flutter_events/ui/widgets/intro_page_indicators.dart';



class IntroPage extends StatefulWidget {
  @override
  State createState() => IntroPageState();
}


class IntroPageState extends State<IntroPage> {
  final PageController _pagecontroller = new PageController(initialPage: 0);
  int _currentPage = 0;


  void _openAuthScreen()
  {
    BlocProvider.of<ApplicationBloc>(context).dispatch(IntroScreenButtonTapped());

    Navigator.pushReplacementNamed(context, '/auth');

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
                    PrimaryGradientButton('Get Started', _openAuthScreen, false)
                  ],
                )),

            /*Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryGradientButton('Get Started')),*/
          ],
        ));
  }


}