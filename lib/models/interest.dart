import 'package:built_value/serializer.dart';
import 'package:built_value/built_value.dart';

part 'interest.g.dart';
/*class Interest{
  String _interestName;
  String _interestImage;
  bool _isSelected;
  String _id;

  Interest(this._interestImage, this._interestName, this._isSelected, this._id);

  Map<String, dynamic> toJson() => {
    'interestName': _interestName,
    'interestImage': _interestImage
  };

  bool get isSelected => _isSelected;

  String get interestImage => _interestImage;

  String get interestName => _interestName;

  String get interestId => _id;

  set setIsSelected(bool value) {
    _isSelected = value;
  }*/

abstract class Interest implements Built<Interest, InterestBuilder> {

  static Serializer<Interest> get serializer => _$interestSerializer;

  @nullable
  String get interestName;
  @nullable
  String get  interestImage;
  @nullable
  bool get isSelected;
  @nullable
  String get id;
  Interest._();
  factory Interest([updates(InterestBuilder b)]) = _$Interest;
}


