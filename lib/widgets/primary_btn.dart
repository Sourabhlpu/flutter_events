import 'package:flutter/material.dart';

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