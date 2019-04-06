import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/application_bloc.dart';
import 'package:flutter_events/blocs/bloc_provider.dart';
import 'package:flutter_events/blocs/create_event_bloc.dart';
import 'package:flutter_events/delegates/addItem.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../widgets/add_splash.dart';
import '../widgets/horizontal_list_with_title.dart';
import '../widgets/primary_btn.dart';
import '../widgets/loading_info.dart';

class CreateEvent extends StatefulWidget {
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> implements AddItemDelegate {
  TextEditingController _startDateTextFieldController =
      new TextEditingController();
  TextEditingController _endDateTextFieldController =
      new TextEditingController();
  TextEditingController _startTimeTextFieldController =
      new TextEditingController();
  TextEditingController _endTimeTextFieldController =
      new TextEditingController();
  TextEditingController _titleTextFieldController = new TextEditingController();
  TextEditingController _locationFieldController = new TextEditingController();
  TextEditingController _entryFeesTextFieldController =
      new TextEditingController();
  TextEditingController _descriptionTextFieldController =
      new TextEditingController();
  bool _showEntryFeesField = false;
  BuildContext contextSnackbar;

  File _image;

  final _formKey = GlobalKey<FormState>();

  CreateEventBloc _createEventBloc;

  List<Interest> _eventTypes;

  String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.angleLeft),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              }),
          elevation: 1,
          centerTitle: true,
          title: Text(
            'Create Event',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Builder(builder: (BuildContext context) {
          contextSnackbar = context;
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: LoadingInfo(
                isLoading: _createEventBloc.isLoading,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildTitleFormField(),
                    ),
                    StreamBuilder(
                        stream: _createEventBloc.interests,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Interest>> snapshot) {
                          if (snapshot.hasData) {
                            _eventTypes = snapshot.data;
                            return HorizontalListWithTitle(
                                'Event Type', _eventTypes, false);
                          } else
                            return Container();
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildLocationField(),
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: _buildStartDateField('Starts', context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: _buildStartTimeField('', context),
                          )
                        ]),
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: _buildEndDateField('Ends', context),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 8),
                            child: _buildEndTimeField('', context),
                          )
                        ]),
                        TableRow(children: [
                          SwitchListTile(
                              title: Text(
                                'Entry fees',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              value: _showEntryFeesField,
                              onChanged: (value) {
                                setState(() {
                                  _showEntryFeesField = value;
                                });
                              }),
                          _showEntryFeesField
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 0, right: 4),
                                  child: _buildAmountTextField('Rs', context),
                                )
                              : Container()
                        ])
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildDescriptionTextField('Description', context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _image == null
                                ? 'Add Cover Image'
                                : p.basename(_image.path),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          StreamBuilder<StorageTaskEvent>(
                              stream: _createEventBloc.storageTaskEvent,
                              builder: (context, snapshot) {
                                return _setImageUploadButton(snapshot);
                              })
                        ],
                      ),
                    ),
                    PrimaryGradientButton('Create Event', _createEvent, false)
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    _createEventBloc.uploadImage.add(image);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _createEventBloc = BlocProvider.of<CreateEventBloc>(context);
  }

  InputDecoration inputDecoration(String title,
      {Icon icon = const Icon(Icons.add, color: Colors.white)}) {
    return InputDecoration(
      suffixIcon: icon,
      labelText: title,
      labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: const Color(0xFFED5D66))),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey[400])),
    );
  }

  _buildAmountTextField(String title, BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: _entryFeesTextFieldController,
      decoration: inputDecoration(title),
    );
  }

  _buildDescriptionTextField(String title, BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: _descriptionTextFieldController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return 'Please enter a description';
      },
      decoration: inputDecoration(title),
    );
  }

  _buildEndDateField(String title, BuildContext context) {
    return AddSplash(
      onTap: () async {
        DateTime endDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2018),
          lastDate: DateTime(2030),
        );

        String _endDate = formatDate(endDate, [dd, " ", M, " ", yyyy]);
        _endDateTextFieldController.text = _endDate;
      },
      child: TextFormField(
        controller: _endDateTextFieldController,
        validator: (value) {
          if (value.isEmpty) return 'Please enter end date';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.calendar,
              size: 16,
            )),
      ),
    );
  }

  _buildEndTimeField(String title, BuildContext context) {
    return AddSplash(
      onTap: () async {
        TimeOfDay endTime = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());

        String _endTime = _formatTimeOfDay(endTime);
        _endTimeTextFieldController.text = _endTime;
      },
      child: TextFormField(
        controller: _endTimeTextFieldController,
        validator: (value) {
          if (value.isEmpty) return 'Please enter end time';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.clock,
              size: 16,
            )),
      ),
    );
  }

  _buildLocationField() {
    return AddSplash(
      onTap: () async {
        try {
          Place p = await PluginGooglePlacePicker.showAutocomplete(
              mode: PlaceAutocompleteMode.MODE_FULLSCREEN);
          setState(() {
            _locationFieldController.text = p.name;
          });
        } catch (error) {
          print(error);
        }
      },
      child: TextFormField(
        enabled: false,
        controller: _locationFieldController,
        validator: (value) {
          if (value.isEmpty) return 'Please select a location';
        },
        decoration: inputDecoration('Location',
            icon: Icon(
              Icons.location_on,
              size: 16,
            )),
      ),
    );
  }

  _buildStartDateField(String title, BuildContext context) {
    return AddSplash(
      onTap: () async {
        DateTime startDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2018),
          lastDate: DateTime(2030),
        );

        String _startDate = formatDate(startDate, [dd, " ", M, " ", yyyy]);
        _startDateTextFieldController.text = _startDate;
      },
      child: TextFormField(
        controller: _startDateTextFieldController,
        validator: (value) {
          if (value.isEmpty) return 'Please enter start date';
        },
        decoration: inputDecoration(
          title,
          icon: Icon(
            FontAwesomeIcons.calendar,
            size: 16,
          ),
        ),
      ),
    );
  }

  _buildStartTimeField(String title, BuildContext context) {
    return AddSplash(
      onTap: () async {
        TimeOfDay timeStart = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());

        String _startTime = _formatTimeOfDay(timeStart);
        _startTimeTextFieldController.text = _startTime;
      },
      child: TextFormField(
        controller: _startTimeTextFieldController,
        validator: (value) {
          if (value.isEmpty) return 'Please enter start time';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.clock,
              size: 16,
            )),
      ),
    );
  }

  _buildTitleFormField() {
    return TextFormField(
      maxLines: 1,
      controller: _titleTextFieldController,
      decoration: inputDecoration('Title'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return 'Please enter a name for the event';
      },
    );
  }

  _createEvent() {
    if (_formKey.currentState.validate()) {
      String title = _titleTextFieldController.text;

      List<Interest> selectedEvent =
          _eventTypes.where((event) => event.isSelected).toList();

      List<String> eventType =
          selectedEvent.map((event) => event.interestName).toList();

      String location = _locationFieldController.text;

      String startDate = _startDateTextFieldController.text;

      String startTime = _startTimeTextFieldController.text;

      String endDate = _endDateTextFieldController.text;

      String endTime = _endTimeTextFieldController.text;

      String fees = '';

      if (_showEntryFeesField) {
        fees = _endTimeTextFieldController.text;
      }

      String description = _descriptionTextFieldController.text;

      Event event = Event((b) => b
        ..title = title
        ..eventType = BuiltList<String>.from(eventType).toBuilder()
        ..location = location
        ..startDate = startDate
        ..startTime = startTime
        ..endDate = endDate
        ..endTime = endTime
        ..entryFees = fees
        ..about = description
        ..image = _imageUrl);

      _createEventBloc.addItem(event, this, AddSinkType.createEvent);
    }
  }

  _formatTimeOfDay(TimeOfDay timeOfDay) {
    String period = timeOfDay.period == DayPeriod.am ? "am" : "pm";

    return timeOfDay.hourOfPeriod.toString() +
        ":" +
        timeOfDay.minute.toString() +
        period;
  }

  @override
  void onError(String message) {
    // TODO: implement onError

    final snackbar = SnackBar(content: Text(message));

    Scaffold.of(contextSnackbar).showSnackBar(snackbar);
  }

  @override
  void onSuccess(SuccessType type) {
    // TODO: implement onSuccess
    if (type == SuccessType.uploadImage) {}
  }

  Widget _setImageUploadButton(AsyncSnapshot<StorageTaskEvent> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      if (snapshot.data.type == StorageTaskEventType.progress) {
        return CircularProgressIndicator();
      } else if (snapshot.data.type == StorageTaskEventType.success) {
        _setDownloadUrl(snapshot.data);

        return IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              getImage();
            });
      } else if (snapshot.data.type == StorageTaskEventType.failure) {
        return IconButton(
            icon: Icon(
              Icons.error_outline,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              getImage();
            });
      }
    } else
      return IconButton(
          icon: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () async {
            getImage();
          });
  }

  void _setDownloadUrl(StorageTaskEvent data) async {
    _imageUrl = await data.snapshot.ref.getDownloadURL();

    print(_imageUrl);
  }
}
