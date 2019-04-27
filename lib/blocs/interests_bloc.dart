import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/auth_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/events/select_interest_events.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:flutter_events/states/select_interest_states.dart';
import 'package:flutter_events/utils/app_utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class InterestsBloc extends Bloc<SelectInterestEvents, SelectInterestStates> {
  final AppRepository repository;
  final ApplicationBloc applicationBloc;
  final FirebaseUser _user;
  List<Interest> _interests;
  StreamSubscription subscription;

  InterestsBloc({@required this.repository, @required this.applicationBloc})
      : _user = applicationBloc.user;

  @override
  // TODO: implement initialState
  get initialState => Uninitialized();

  @override
  Stream<SelectInterestStates> mapEventToState(
      SelectInterestEvents event) async* {
    // TODO: implement mapEventToState

    if (event is FetchList) {
      yield* _fetchInterests();
    }

    if (event is InterestTapped) {
      yield* _handleInterestSelection(event.index);
    }

    if (event is GenericErrorEvent) {
      yield GenericError(error: "No Internet");
    }

    if (event is ListLoadedEvent) {
      yield ListLoaded(interests: event.interests);
    }

    if (event is LetsStartTapped) {
      yield* _handleLetsStart();
    }

    if (event is InterestsSavedEvent) {
      yield InterestSaved();
    }
  }

  Stream<SelectInterestStates> _fetchInterests() async* {
    yield Loading();

    if (await AppUtils.checkNetworkAvailability()) {
      subscription?.cancel();

      subscription = repository
          .fetchInterests()
          .asStream()
          .handleError(_handleError)
          .listen((interests) {
            _interests = interests;
        dispatch(ListLoadedEvent(interests: interests));
      });
    } else {
      yield GenericError(error: "No Internet");
    }
  }

  Stream<SelectInterestStates> _handleLetsStart() async* {
    List<String> savedList = _getSavedInterestList();

    if (savedList.isEmpty)
      yield GenericError(error: "Select at least one interest");
    else {
      if (await AppUtils.checkNetworkAvailability())
        repository
            .saveInterests(savedList, _user)
            .catchError(_handleError)
            .whenComplete(() {
          dispatch(InterestsSavedEvent());
        });
      else {
        yield GenericError(error: "No Internet");
      }
    }
  }

  Stream<SelectInterestStates> _handleInterestSelection(int index) async* {

    List<Interest> interests = List.from(_interests);

    Interest interest = _interests[index].rebuild(
        (interest) => interest.isSelected = !_interests[index].isSelected);

    interests.insert(index, interest);
    interests.removeAt(index + 1);

    yield ListLoaded(interests: interests);
  }



  _getSavedInterestList() {

    List<String> savedInterests = List<String>();

    for (Interest interest in _interests) {
      if (interest.isSelected) {
        savedInterests.add(interest.interestName);
      }
    }

    return savedInterests;
  }


  _handleError(error) {
    dispatch(GenericErrorEvent(error: error.toString()));
  }

  /*List<Interest> _interests;

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
  final _isLoadingSubject = BehaviorSubject<bool>.seeded((false));

  InterestsBloc() {
    _initializeFbUser();
    _fetchInterests();
    _interestSelection();
    _initInterestBtnStream();
  }

  */ /*
   * we need the user to save the interests to a particular user table in our firestore db
   */ /*
  void _initializeFbUser() {
    //_user = ApplicationBloc.user;
  }

  */ /*
   * start fetching the list of interests from the firestore db
   */ /*
  void _fetchInterests() async {
    _isLoadingSubject.add(true);

    bool isNetworkAvailable = await AppUtils.checkNetworkAvailability();
    if (isNetworkAvailable) {

      _interests = await repository.fetchInterests();
      _interestListController.sink.add(UnmodifiableListView(_interests));
      _isLoadingSubject.add(false);
     */ /*
      repository.fetchInterests().then((interests) {
        _interests = interests;
        _interestListController.sink.add(UnmodifiableListView(_interests));
        _isLoadingSubject.add(false);
      }).catchError((_handleError));*/ /*
    } else {
      _delegate.onError("No Internet");
      _isLoadingSubject.add(false);
    }
  }

  */ /*
   * this method is called when the an individual interest tile is clicked. It toggles
   * the selection at an index and then it is added to the stream that streams the list of interests
   */ /*
  void _interestSelection() {
    _interestSelectionController.stream.listen((index) {

      var interest = _interests[index].rebuild((interest) => interest.isSelected = !_interests[index].isSelected);

      _interests.insert(index, interest);
      _interests.removeAt(index + 1);

      _interestListController.add(UnmodifiableListView(_interests));
    });
  }

  */ /*
   * this method is for handling of the final submission of the interests to save it to the
   * firestore user document.
   */ /*
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

  */ /*
   * method to handle the add sinks for the interests page(individual interest tile tap, final submission)
   */ /*
  void addItem(var item, AddItemDelegate delegate, AddSinkType type) {
    _delegate = delegate;
    if (type == AddSinkType.interestType)
      interestSelection.add(item);
    else if (type == AddSinkType.saveInterests) interestBtn.add(item);
  }

  _handleError(Error error) {
    _delegate.onError(error.toString());
  }*/
}
