import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_events/widgets/primary_btn.dart';
import 'package:flutter_events/widgets/intro_screen.dart';
import 'package:flutter_events/widgets/intro_page_indicators.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final PageController _pagecontroller = new PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
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
              IntroPage('images/discover.png', 'Discover Event',
                  'There are many variations of passages of Lorem ipsum available'),
              IntroPage('images/create.png', 'Create Event',
                  'There are many variations of passages of Lorem ipsum available'),
              IntroPage('images/book.png', 'Book Events',
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
                PrimaryGradientButton('Get Started')
              ],
            )),

        /*Align(
            alignment: Alignment.bottomCenter,
            child: PrimaryGradientButton('Get Started')),*/
      ],
    ));
  }
}
