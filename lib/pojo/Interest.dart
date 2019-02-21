
class Interest{
  String _interestName;
  String _interestImage;
  bool _isSelected;

  Interest(this._interestImage, this._interestName, this._isSelected);

  bool get isSelected => _isSelected;

  String get interestImage => _interestImage;

  String get interestName => _interestName;


}