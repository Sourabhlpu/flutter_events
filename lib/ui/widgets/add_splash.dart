import 'package:flutter/material.dart';

class AddSplash extends StatelessWidget {
  final Widget child;
  final Function onTap;

  AddSplash({@required this.child, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  onTap: onTap,
                ))),
      ],
    );
  }
}
