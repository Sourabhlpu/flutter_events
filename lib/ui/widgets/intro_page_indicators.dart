import 'package:flutter/material.dart';

class CircularPageIndicators extends StatelessWidget {
  final int currentPage;

  CircularPageIndicators({this.currentPage = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularIndicator(
         currentPage == 0,
        ),
        SizedBox(
          width: 4,
        ),
        CircularIndicator(
          currentPage == 1,
        ),
        SizedBox(
          width: 4,
        ),
        CircularIndicator(
          currentPage == 2,
        )
      ],
    );
  }
}

class CircularIndicator extends StatelessWidget {
  final bool _isSelected;

  CircularIndicator(this._isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected ? Color(0xFFED5D66) : Colors.transparent,
          border: Border.all(color: Colors.grey[500])),
    );
  }
}
