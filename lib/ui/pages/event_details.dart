import 'package:flutter/material.dart';
import 'package:flutter_events/models/event.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/ui/widgets/icon_white_background.dart';
import 'package:flutter_events/ui/widgets/primary_btn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventDetail extends StatefulWidget {
  final Events _event;

  EventDetail(this._event);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getTopImage(context),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                    child: Text(
                      'TECHNOLOGY',
                      style: TextStyle(fontSize: 12, fontFamily: 'AvenirLight'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                    child: Text(
                      widget._event.title,
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'AvenirMedium'),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                    child: Text(
                      'By Sourabh Pal',
                      style: TextStyle(fontSize: 12, fontFamily: 'AvenirLight'),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    dense: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(FontAwesomeIcons.calendarAlt),
                    ),
                    title: Text(
                      'Friday, January 16',
                      style:
                          TextStyle(fontSize: 12, fontFamily: 'AvenirMedium'),
                    ),
                    subtitle: Text(
                      '10:30am - 2:00pm IST',
                      style: TextStyle(fontSize: 12, fontFamily: 'AvenirLight'),
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    dense: true,
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Icon(Icons.location_on),
                    ),
                    title: Text(
                      'Surface Design',
                      style:
                          TextStyle(fontSize: 12, fontFamily: 'AvenirMedium'),
                    ),
                    subtitle: Text(
                      '4th floor, Some building in district center',
                      style: TextStyle(fontSize: 12, fontFamily: 'AvenirLight'),
                    ),
                  ),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                    dense: true,
                    leading: Icon(FontAwesomeIcons.ticketAlt),
                    title: RichText(
                      text: TextSpan(
                        text: 'Rs ',
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'AvenirLight',
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '500',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'AvenirLight',
                                  color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                    child: Text(
                      'About:',
                      style:
                          TextStyle(fontSize: 14, fontFamily: 'AvenirMedium'),
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 16.0, right: 16, bottom: 100),
                    child: Text(
                      'Show HN: Transfer files to mobile device by scanning a QR code from the terminal. Power 9 May Dent X86 Servers: Alibaba, Google, Tencent Test IBM Systems. Types of People Startups Should Hire, but Don’t',
                      style: TextStyle(fontSize: 12, fontFamily: 'AvenirLight'),
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 4,
                left: 16,
                right: 16,
                child: PrimaryGradientButton(
                    'BOOK NOW', _onBookNowTapped, false))
          ],
        ),
      ),
    );
  }

  Stack _getTopImage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: FadeInImage.assetNetwork(
              fit: BoxFit.fitWidth,
              width: double.infinity,
              height: 200,
              placeholder: 'images/placeholder.png',
              image: widget._event.image),
        ),
        Positioned(
          child: Material(
            shape: CircleBorder(),
            color: Colors.transparent,
            child: IconButton(
                splashColor: Colors.grey[100],
                icon: Icon(
                  FontAwesomeIcons.angleLeft,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Material(
            shape: CircleBorder(),
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                IconWhiteBackground(Icons.share),
                SizedBox(
                  width: 4,
                ),
                IconWhiteBackground(Icons.favorite_border)
              ],
            ),
          ),
        )
      ],
    );
  }

  _onBookNowTapped() {}

  _onShareTapped(int index){}

  _onFavoriteTapped(int index){}
}
