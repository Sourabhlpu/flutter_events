import 'package:meta/meta.dart';

class DetailsState {
  final bool isLoading;
  final bool showAddCardDialog;
  final bool isError;
  final String error;
  final bool showBottomDialog;
  final String cardNumber;

  DetailsState({
    this.isLoading = false,
    this.showAddCardDialog = false,
    this.isError = false,
    this.error = "",
    this.showBottomDialog = false,
    this.cardNumber = ""
  });

  DetailsState copyWith({
    bool isLoading,
    bool showAddCardDialog,
    bool isError,
    String error,
    bool showBottomDialog,
    String cardNumber}) {

    return DetailsState(
        isLoading: isLoading ?? this.isLoading,
        showAddCardDialog: showAddCardDialog ?? this.showAddCardDialog,
        isError: isError ?? this.isError,
        error:  error ?? this.error,
        showBottomDialog: showBottomDialog ?? this.showBottomDialog,
        cardNumber: cardNumber ?? this.cardNumber
    );
  }

  DetailsState update({
    bool isLoading,
    bool showAddCardDialog,
    bool isError,
    String error,
    bool showBottomDialog,
    String cardNumber}) {
    return copyWith(
        isLoading: isLoading,
        showAddCardDialog: showAddCardDialog,
        isError: isError,
        error: error,
        showBottomDialog:  showBottomDialog,
        cardNumber: cardNumber
    );
  }
}
