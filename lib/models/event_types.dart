import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class EventTypes extends Equatable {
  final String interestName;
  final bool isSelected;

  EventTypes({@required this.interestName, @required this.isSelected});

  EventTypes copyWith({String eventType, bool isSelected}) {
    return EventTypes(
        interestName: eventType ?? this.interestName,
        isSelected: isSelected ?? isSelected);
  }
}
