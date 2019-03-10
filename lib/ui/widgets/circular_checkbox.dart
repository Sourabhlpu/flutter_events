import 'package:flutter/material.dart';

class CircularCheckbox extends StatelessWidget {

  final bool _isSelected;

  CircularCheckbox(this._isSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          border: Border.all(color: Colors.white)),
    );
  }
}
