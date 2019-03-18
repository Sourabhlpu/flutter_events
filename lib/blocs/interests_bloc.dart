import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/auth_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/Interest.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class InterestsBloc implements BlocBase {
  List<Interest> _interests;

  AddItemDelegate _delegate;

  FirebaseUser _user;

  // this is the sink that is responsible for individual interest selection
  Sink<int> get interestSelection => _interestSelectionController.sink;
  final _interestSelectionController = StreamController<int>();

  // this sink is responsible for final submission of the interests
  Sink<bool> get interestBtn => _interestsBtnController.sink;
  final _interestsBtnController = StreamController<bool>();

  //this stream is responsible for streaming the list of interests once fetched from the db
  Stream<UnmodifiableListView<Interest>> get interestList =>
      _interestListController.stream;
  final _interestListController =
      BehaviorSubject<UnmodifiableListView<Interest>>();

  //the stream for showing the loader
  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  InterestsBloc() {
    _initializeFbUser();
    _fetchInterests();
    _interestSelection();
    _initInterestBtnStream();
  }

  /*
   * we need the user to save the interests to a particular user table in our firestore db
   */
  void _initializeFbUser() {
    _user = ApplicationBloc.user;
  }

  /*
   * start fetching the list of interests from the firestore db
   */
  void _fetchInterests() async {
    _isLoadingSubject.add(true);

    bool isNetworkAvailable = await AppUtils.checkNetworkAvailability();
    if (isNetworkAvailable) {

      _interests = await repository.fetchInterests();
      _interestListController.sink.add(UnmodifiableListView(_interests));
      _isLoadingSubject.add(false);
     /*
      repository.fetchInterests().then((interests) {
        _interests = interests;
        _interestListController.sink.add(UnmodifiableListView(_interests));
        _isLoadingSubject.add(false);
      }).catchError((_handleError));*/
    } else {
      _delegate.onError("No Internet");
      _isLoadingSubject.add(false);
    }
  }

  /*
   * this method is called when the an individual interest tile is clicked. It toggles
   * the selection at an index and then it is added to the stream that streams the list of interests
   */
  void _interestSelection() {
    _interestSelectionController.stream.listen((index) {
      _interests[index].setIsSelected = !_interests[index].isSelected;

      _interestListController.add(UnmodifiableListView(_interests));
    });
  }

  /*
   * this method is for handling of the final submission of the interests to save it to the
   * firestore user document.
   */
  void _initInterestBtnStream() {
    _interestsBtnController.stream.listen((value) async {
      bool _isInterestSelected = false;
      List<String> savedInterests = List<String>();

      for (Interest interest in _interests) {
        if (interest.isSelected) {
          _isInterestSelected = true;
          savedInterests.add(interest.interestName);
        }
      }

      if (!_isInterestSelected)
        _delegate.onError("Select atleast one interest");
      else {
        bool isNetworkAvailable = await AppUtils.checkNetworkAvailability();
        if (isNetworkAvailable)
          repository
              .saveInterests(savedInterests, _user)
              .catchError(_handleError);
        else {
          _delegate.onError("No Internet");
          _isLoadingSubject.add(false);
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _interestSelectionController.close();
    _interestsBtnController.close();
    _interestListController.close();
    _isLoadingSubject.close();
  }

  /*
   * method to handle the add sinks for the interests page(individual interest tile tap, final submission)
   */
  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;
    if (type == AddSinkType.interestType)
      interestSelection.add(item);
    else if (type == AddSinkType.saveInterests) interestBtn.add(item);
  }

  _handleError(Error error) {
    _delegate.onError(error.toString());
  }
}
