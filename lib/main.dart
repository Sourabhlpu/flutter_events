import 'package:flutter/material.dart';
import 'package:flutter_events/pages/intro.dart';
import 'package:flutter_events/pages/auth.dart';
import 'package:flutter_events/utils/custom_colors.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

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
        '/': (context) => IntroPage(),
        '/auth': (context) => Authentication()
      },
    );
  }
}
