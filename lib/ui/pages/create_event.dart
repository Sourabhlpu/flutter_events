import 'package:flutter/material.dart';


class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Create Event',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        )
    );
  }
}
