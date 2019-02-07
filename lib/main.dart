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

class MyHomePage extends StatefulWidget {
  @override
  State createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final PageController _pagecontroller = new PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
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
              Container(
                color: Colors.white,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Image.asset(
                        'images/discover.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 80.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Discover Event',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'There are many variations of passages of Lorem ipsum available',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
              ),
              Container(
                color: Colors.white,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Image.asset(
                        'images/create.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 80.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Create New Event',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'There are many variations of passages of Lorem ipsum available',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
              ),
              Container(
                color: Colors.white,
                child: Column(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Image.asset(
                        'images/book.png',
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 80.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Book Event',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(width: 0.0, height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'There are many variations of passages of Lorem ipsum available',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
              ),
            ]),
        Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == 0
                              ? const Color(0xFFED5D66)
                              : Colors.transparent,
                          border: Border.all(color: Colors.grey[500])),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == 1
                              ? Color(0xFFED5D66)
                              : Colors.transparent,
                          border: Border.all(color: Colors.grey[500])),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == 2
                              ? Color(0xFFED5D66)
                              : Colors.transparent,
                          border: Border.all(color: Colors.grey[500])),
                    )
                  ],
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

class PrimaryGradientButton extends StatelessWidget {
  final String btnText;

  PrimaryGradientButton(this.btnText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(30.0),
          gradient: LinearGradient(
              colors: [const Color(0xFFDF69DD), const Color(0xFFED5D66)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: FlatButton(
        onPressed: () {
          print('get started');
        },
        child: Text(btnText),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }
}
