import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/details_bloc/details_bloc.dart';
import 'package:flutter_events/blocs/details_bloc/details_state.dart';
import 'package:flutter_events/blocs/details_bloc/bloc.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/ui/widgets/icon_white_background.dart';
import 'package:flutter_events/ui/widgets/loading_info.dart';
import 'package:flutter_events/ui/widgets/primary_btn.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  final AppRepository repository;

  EventDetail({this.event, this.repository});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  DetailsBloc _bloc;

  @override
  void initState() {
    _bloc = DetailsBloc(repository: widget.repository);
    StripeSource.setPublishableKey(
        "pk_test_f7rLNAK3SmkvoX3mIvRkmul200627NR252");
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: BlocListener(
                  bloc: _bloc,
                  listener: (context, DetailsState state) {
                    if (state.showAddCardDialog) {
                      _addStripeSource();
                    }

                    if (state.showBottomDialog) {
                      //_showPaymentConfirmation(state.cardNumber);
                      _showPaymentDialog();
                    }
                  },
                  child: BlocBuilder(
                      bloc: _bloc,
                      builder: (BuildContext context, DetailsState state) {
                        return LoadingInfo(
                          isLoading: state.isLoading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _getTopImage(context),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0),
                                child: Text(
                                  'TECHNOLOGY',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirLight'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0),
                                child: Text(
                                  widget.event.title,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'AvenirMedium'),
                                  maxLines: 2,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Text(
                                  'By Sourabh Pal',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirLight'),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 16.0),
                                dense: true,
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Icon(FontAwesomeIcons.calendarAlt),
                                ),
                                title: Text(
                                  'Friday, January 16',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirMedium'),
                                ),
                                subtitle: Text(
                                  '10:30am - 2:00pm IST',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirLight'),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 16.0),
                                dense: true,
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Icon(Icons.location_on),
                                ),
                                title: Text(
                                  'Surface Design',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirMedium'),
                                ),
                                subtitle: Text(
                                  '4th floor, Some building in district center',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirLight'),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 16.0),
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
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 16.0),
                                child: Text(
                                  'About:',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'AvenirMedium'),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0,
                                    left: 16.0,
                                    right: 16,
                                    bottom: 100),
                                child: Text(
                                  'Show HN: Transfer files to mobile device by scanning a QR code from the terminal. Power 9 May Dent X86 Servers: Alibaba, Google, Tencent Test IBM Systems. Types of People Startups Should Hire, but Don’t',
                                  style: TextStyle(
                                      fontSize: 12, fontFamily: 'AvenirLight'),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
            ),
            Positioned(
                bottom: 4,
                left: 16,
                right: 16,
                child:
                    PrimaryGradientButton('BOOK NOW', _onBookNowTapped, false))
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
              image: widget.event.image),
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

  _onBookNowTapped() {
   // _bloc.dispatch(BookEventTapped());
    _showPaymentDialog();
  }

  _addStripeSource() {
    StripeSource.addSource().then((String token) {
      _bloc.dispatch(CardTokenAdded(token: token));
    });
  }

  _showPaymentConfirmation(String cardNumber) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.credit_card),
                title: new Text('Pay Using: '),
                subtitle: Text(cardNumber),
                trailing: IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () {
                      _bloc.dispatch(ChargeCard(amount: "2000"));
                    }),
              ),
            ],
          );
        });
  }

  _showPaymentDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {

          return
            FractionallySizedBox(
              heightFactor: 0.4,
              widthFactor: 0.95,
              child: Card(
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFF465A63),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Image.asset('images/card_image.png'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, left: 4, right: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text(
                              'Payment Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Kiona',
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'CARDHOLDER NAME',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: 'Kiona',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                'Sourabh Pal',
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontFamily: 'Kiona',
                                  fontWeight: FontWeight.w600,
                                      letterSpacing: 2.5
                              ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'CARD NUMBER',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: 'Kiona',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                'XXXX-XXXX-XXXX-4242',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: 'Kiona',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'AMOUNT',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontFamily: 'Kiona',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 4),
                              child: Text(
                                '\$20',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontFamily: 'Kiona',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  FlatButton(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    color: Colors.green,
                                    child: Text(
                                      'PAY',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                          fontFamily: 'Kiona',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 2.0
                                      ),
                                    ),

                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            ),
          );
          return Dialog(
              backgroundColor: const Color(0xFF465A63),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: FractionallySizedBox(
                heightFactor: 0.3,
                widthFactor: 1,
                child:
                Align(
                    alignment: Alignment(-1, -1),
                    child: Image.asset('images/card_image.png')),
              ),

         /*   child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 8.0,
                child: Container(

                    color: const Color(0xFF465A63)),
              ),
            ),*/
          );
        });
  }

  _onShareTapped(int index) {}

  _onFavoriteTapped(int index) {}
}
