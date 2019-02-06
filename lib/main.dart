import 'package:flutter/material.dart';

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
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 3,
          child: TabBarView(children: [
            Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Image.asset('images/discover.png'),
                  ),
                )),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(padding: EdgeInsets.only(top: 20.0),
                child: Image.asset('images/create.png'),),
              )
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(padding: EdgeInsets.only(top: 20.0), child: Image.asset('images/book.png'),),
              )
            ),
          ])),
    );
  }
}
