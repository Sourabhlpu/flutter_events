import 'package:flutter/material.dart';

class IntroPageItem extends StatelessWidget {

  final String _imageAsset;
  final String _title;
  final String _subtitle;

  IntroPageItem(this._imageAsset, this._title, this._subtitle);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Image.asset(
              _imageAsset,
            ),
          ),
        ),
        SizedBox(width: 0.0, height: 80.0),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              _title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(width: 0.0, height: 25.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _subtitle,
            style:
            TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        )
      ]),
    );
  }
}
