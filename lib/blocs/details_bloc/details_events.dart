import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DetailsEvent extends Equatable {
  DetailsEvent([List props = const []]) : super([props]);
}

class BookEventTapped extends DetailsEvent {
  @override
  String toString() => "book event tapped";
}

class ShowAddCardDialog extends DetailsEvent {
  String toString() => "show add card dialog";
}

class CardTokenAdded extends DetailsEvent {
  final String token;

  CardTokenAdded({@required this.token}) : super([token]);

  String toString() => "card added ";
}

class PaymentAdded extends DetailsEvent {
  final String cardNumber;

  PaymentAdded({this.cardNumber}) : super([cardNumber]);

  String toString() => "payment added ";
}

class ShowBottomDialog extends DetailsEvent {
  final String cardNumber;

  ShowBottomDialog({this.cardNumber}) : super([cardNumber]);

  String toString() => "show bottom dialog";
}

class ChargeCard extends DetailsEvent {
  final String amount;

  ChargeCard({@required this.amount}) : super([amount]);

  String toString() => "charge card";
}
