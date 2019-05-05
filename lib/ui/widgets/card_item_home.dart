import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_events/blocs/home_bloc/home_bloc.dart';
import 'package:flutter_events/blocs/home_bloc/home_events.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/ui/widgets/add_splash.dart';
import 'package:flutter_events/ui/widgets/icon_white_background.dart';

class CardListItem extends StatelessWidget {
  Event _event;
  final Function _onCardTapped;
  final int _tabIndex;
  final int _index;
  final HomeBloc _bloc;


  CardListItem(this._event, this._onCardTapped, this._tabIndex, this._index, this._bloc);

  @override
  Widget build(BuildContext context) {
    DateTime _date = DateTime.fromMillisecondsSinceEpoch(
        num.parse(_event.startDate),
        isUtc: false);
    var date = formatDate(_date, [d, '\n', M]);
    // TODO: implement build
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () {
          _onCardTapped(_index, _event, context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                FadeInImage.assetNetwork(
                  alignment: Alignment.topCenter,
                  placeholder: 'images/placeholder.png',
                  image: _event.image,
                  fit: BoxFit.fill,
                  width: double.maxFinite,
                  height: 170,
                ),
                Positioned(
                  bottom: 4,
                  right: 8,
                  child: AddSplash(
                    child: _event.isFavorite
                        ? IconWhiteBackground(Icons.favorite)
                        : IconWhiteBackground(Icons.favorite_border),
                    onTap: () {
                      _addFavorite(_index, );
                    },
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${_event.title}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                        child: Text('${_event.location}'),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border(left: BorderSide(color: Colors.grey[300]))),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _addFavorite(int index) {
    _bloc.dispatch(FavoriteButtonTapped(index: index, tabIndex: _tabIndex));
  }
}
