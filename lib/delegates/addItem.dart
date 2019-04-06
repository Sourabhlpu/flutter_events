enum SuccessType{
  successSign,
  successSignup,
  uploadImage
}
abstract class AddItemDelegate {
  void onSuccess(SuccessType type);
  void onError(String message);
}