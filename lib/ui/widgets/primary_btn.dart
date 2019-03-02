import 'package:flutter/material.dart';

class PrimaryGradientButton extends StatelessWidget {
  final String btnText;
  final Function _btnAction;
  final bool _showShadow;

  PrimaryGradientButton(this.btnText, this._btnAction, this._showShadow);
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
              end: Alignment.centerRight),
      boxShadow: [BoxShadow(
        color: _showShadow? Theme.of(context).primaryColor : Colors.transparent,
        blurRadius: 20.0

      )]),
      child: FlatButton(
        onPressed: _btnAction,
        child: Text(btnText),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }
}