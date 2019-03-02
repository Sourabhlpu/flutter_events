enum SuccessType{
  successSign,
  successSignup
}
abstract class AddItemDelegate {
  void onSuccess(SuccessType type);
  void onError(String message);
}