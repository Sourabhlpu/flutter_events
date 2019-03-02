import 'package:flutter/material.dart';

class PrimaryWhiteButton extends StatelessWidget {
  final String btnText;
  final Function _btnAction;

  PrimaryWhiteButton(this.btnText, this._btnAction);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(30.0),
          border: Border.all(color: Colors.blue[600], width: 1.0, style: BorderStyle.solid)
          ),
      child: FlatButton(
        onPressed: _btnAction,
        child: Text(btnText),
        textColor: Colors.blue[600],
        padding: EdgeInsets.symmetric(vertical: 15.0),
      ),
    );
  }
}