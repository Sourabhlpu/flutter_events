import 'dart:async';
import 'dart:collection';

import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/Interest.dart';
import 'package:flutter_events/models/events.dart';
import 'package:flutter_events/repository/app_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc implements BlocBase{

  List<Events> events;

  Stream<List<Events>> get eventList => _eventListController.stream;
  final _eventListController = BehaviorSubject<List<Events>>();


  Sink<int> get addFavorite => _favoriteController.sink;
  final _favoriteController = BehaviorSubject<int>();


  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: true);




  @override
  void dispose() {
    // TODO: implement dispose
    _eventListController.close();
    _isLoadingSubject.close();
  }

  HomeBloc()
  {
    _fetchArticles();
    _manageFavorites();
  }


  _fetchArticles() async{
     events = await repository.getEventsList();
    _isLoadingSubject.add(false);
    _eventListController.sink.add(events);
  }

  _manageFavorites() {

    _favoriteController.stream.listen((index){

      _addFavorite(index);
    });
  }

  _addFavorite(int index)
  {

   var eventNew = events[index]
       .rebuild((event) => event..isFavorite = !events[index].isFavorite);
   
   events.insert(index, eventNew);
   events.removeAt(index + 1);


    _eventListController.sink.add(events);
  }



}