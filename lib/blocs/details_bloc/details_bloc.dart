import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_events/models/users/user_fs.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';

import 'details_events.dart';
import 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final AppRepository repository;
  final UserFireStore _userFs;
  StreamSubscription streamSubscriptionAddPayment;
  StreamSubscription chargeSubscription;

  DetailsBloc({@required this.repository})
      : _userFs = repository.getUserFsFromPrefs();
  @override
  // TODO: implement initialState
  DetailsState get initialState => DetailsState();

  @override
  Stream<DetailsState> mapEventToState(DetailsEvent event) async* {
    // TODO: implement mapEventToState

    if (event is BookEventTapped) {

      yield* _manageBooking();
    }
    if (event is CardTokenAdded) {
      yield* _mapCardAddedToState(event.token);
    }

    if(event is ShowAddCardDialog)
      {
        yield currentState.update(isError: false, showAddCardDialog: true);

        //so that the dialog is not shown again and again whenever the widget is rebuilt
        yield currentState.update(isError: false, showAddCardDialog: false);
      }

    if (event is PaymentAdded) {

      yield currentState.update(isError: false, showBottomDialog: true, cardNumber: event.cardNumber);

      //so that the dialog is not shown again and again whenever the widget is rebuilt
      yield currentState.update(isError: false, showBottomDialog: false);
    }
    
    if(event is ChargeCard)
      {
        yield* _mapChargeCardToState(event.amount);
      }
  }

  Stream<DetailsState> _mapCardAddedToState(String token) async* {
    yield currentState.update(isLoading: true);

    repository.addCardToken(token);

    if (await AppUtils.checkNetworkAvailability()) {
      streamSubscriptionAddPayment?.cancel();

      streamSubscriptionAddPayment = repository
          .addCardToken(token)
          .asStream()
          .handleError(_handleError)
          .listen((_) {
        _listenToAddPayments();
      });
    } else {
      yield currentState.update(isError: true, error: 'No Internet');
    }
  }

  _listenToAddPayments() {
    repository.firestore
        .collection("user")
        .document(_userFs.email)
        .collection("payment")
        .document(_userFs.email)
        .snapshots()
        .listen((snapshot) {

          String lastFour = snapshot.data["card"]["last4"];
      dispatch(PaymentAdded(cardNumber: "XXXX-XXXX-XXXX-$lastFour"));
    });
  }

  Stream<DetailsState> _manageBooking() async* {

    repository.isCardSaved(_userFs).then((isCardSaved) {
      if (isCardSaved) {
        //show a dialog to confirm payment with the card number;

        dispatch(PaymentAdded(cardNumber: "XXXX-XXXX-XXXX-424242"));

      } else {
        // show a dialog to enter card details;
        dispatch(ShowAddCardDialog());

      }
    });
  }

  void _handleError(String error) {
    //dispatch(DetailsEvent(error: error.toString()));
  }

  Stream<DetailsState> _mapChargeCardToState(String amount) async* {

    chargeSubscription?.cancel();
    repository.chargeUser(amount);
  }
}
