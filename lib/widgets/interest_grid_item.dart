import 'package:flutter/material.dart';
import 'package:flutter_events/widgets/circular_checkbox.dart';

class InterestGridItem extends StatelessWidget {
  final String _image;
  final String _title;
  final bool _isSelected;
  final Function _onItemTapped;
  final int _position;

  InterestGridItem(this._image, this._title, this._onItemTapped,
      this._isSelected, this._position);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
              child: FadeInImage.assetNetwork(
            placeholder: 'images/placeholder.png',
            image: _image,
            fit: BoxFit.fitWidth,
          )),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.9),
          child: CircularCheckbox(_isSelected),
        ),
        new Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  splashColor: Theme.of(context).primaryColor,
                  onTap: () {
                    _onItemTapped(_position);
                  },
                ))),
      ],
    );
  }
}
