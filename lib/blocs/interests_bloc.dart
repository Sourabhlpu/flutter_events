import 'dart:async';
import 'dart:collection';

import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/Interest.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:rxdart/rxdart.dart';

class InterestsBloc implements BlocBase {
  List<Interest> _interests;

  AddItemDelegate _delegate;

  Sink<int> get interestSelection => _interestSelectionController.sink;
  final _interestSelectionController = StreamController<int>();

  Sink<bool> get interestBtn => _interestsBtnController.sink;
  final _interestsBtnController = StreamController<bool>();

  Stream<UnmodifiableListView<Interest>> get interestList => _interestListController.stream;
  final _interestListController = BehaviorSubject<UnmodifiableListView<Interest>>();

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

  InterestsBloc()
  {
    _listenToInterests();
    _initSelectInterestsStreams();
    _initInterestBtnStream();
  }

  void _listenToInterests() {
    _isLoadingSubject.add(true);
    AppRepository.firestore
        .collection('interests')
        .getDocuments()
        .asStream()
        .listen((snapshot) {
      _interests = snapshot.documents
          .map((document) => Interest(
              document['interestImage'], document['interestName'], false))
          .toList();

      _interestListController.sink.add(UnmodifiableListView(_interests));
      _isLoadingSubject.add(false);
    });
  }

  void _initSelectInterestsStreams() {
    _interestSelectionController.stream.listen((index) {
      _interests[index].setIsSelected = !_interests[index].isSelected;

      _interestListController.add(UnmodifiableListView(_interests));
    });
  }

  void _initInterestBtnStream() {
    _interestsBtnController.stream.listen((value) {
      bool _isInterestSelected = false;

      for (Interest interest in _interests) {
        if (interest.isSelected) {
          _isInterestSelected = true;
          return;
        } else {
          _isInterestSelected = false;
        }
      }

      if (!_isInterestSelected)
        _delegate.onError("Select atleast one interest");
      else {
        //_firestore.collection("user").document()
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

  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;
    if (type == AddSinkType.interestType)
      interestSelection.add(item);
    else if (type == AddSinkType.saveInterests) interestBtn.add(item);
  }
}
