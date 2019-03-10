import 'package:flutter/material.dart';

class IconWhiteBackground extends StatelessWidget {
  final IconData _iconData;

  IconWhiteBackground(this._iconData);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: IconButton(
          color: Theme.of(context).primaryColor,
          iconSize: 16,
          icon: Icon(_iconData),
          onPressed: () {},
        ),
      ),
    );
  }
}
