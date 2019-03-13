
class Interest{
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
  }


}