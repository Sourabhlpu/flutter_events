import 'package:built_collection/built_collection.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events/blocs/create_event_bloc.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/ui/widgets/add_splash.dart';
import 'package:flutter_events/ui/widgets/horizontal_list_with_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_places_picker/google_places_picker.dart';
import '../widgets/primary_btn.dart';
import 'package:meta/meta.dart';
import 'package:flutter_events/blocs/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

class CreateEventForm extends StatefulWidget {
  final CreateEventBloc createEventBoc;

  CreateEventForm({@required this.createEventBoc}){
    createEventBoc.dispatch(FetchEventType());
  }
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  List<EventTypes> _eventTypes;

  String _imageUrl;

  CreateEventBloc get _createEventBloc => widget.createEventBoc;

  final _formKey = GlobalKey<FormState>();
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

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventEvents, CreateEventStates>(
        bloc: _createEventBloc,
        builder: (BuildContext context, CreateEventStates state) {
          if (state is CreateEventFailure) {
            _onWidgetDidBuild(() {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildTitleFormField(),
                ),
                _setEventTypeList(state),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildLocationField(state),
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
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          value: _showEntryFeesField,
                          onChanged: (value) {
                            setState(() {
                              _showEntryFeesField = value;
                            });
                          }),
                      _showEntryFeesField
                          ? Padding(
                              padding: const EdgeInsets.only(left: 0, right: 4),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _setUploadImageText(state),
                      _createUploadImageButton(state)
                    ],
                  ),
                ),
                PrimaryGradientButton('Create Event', _createEvent, false)
              ],
            ),
          );
        });
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

  _buildLocationField(CreateEventStates state) {

    if(state is LocationSelected)
      {
        _locationFieldController.text = state.location;

      }
    return AddSplash(
      onTap: ()  {

        _createEventBloc.dispatch(LocationTapped());
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

  _createEvent() {
    if (_formKey.currentState.validate()) {
      String title = _titleTextFieldController.text;

      List<String> selectedEventTypes = _eventTypes
          .where((eventType) => eventType.isSelected)
          .toList()
          .map((eventType) => eventType.interestName)
          .toList();

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
        ..eventType = BuiltList<String>.from(selectedEventTypes).toBuilder()
        ..location = location
        ..startDate = startDate
        ..startTime = startTime
        ..endDate = endDate
        ..endTime = endTime
        ..entryFees = fees
        ..about = description
        ..image = _imageUrl);

      _createEventBloc.dispatch(CreateEventPressed(event: event));
    }
  }

  _formatTimeOfDay(TimeOfDay timeOfDay) {
    String period = timeOfDay.period == DayPeriod.am ? "am" : "pm";

    return timeOfDay.hourOfPeriod.toString() +
        ":" +
        timeOfDay.minute.toString() +
        period;
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _createUploadImageButton(CreateEventStates state) {
    if (state is UploadingImage) {
      return CircularProgressIndicator();
    } else if(state is CreateEventInitial || state is ImageUploaded || state is ListFetched) {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _createEventBloc.dispatch(AddCoverImageTapped());
        },
      );
    }
    else return Container();
  }

  _setEventTypeList(CreateEventStates state) {
    if (state is CreateEventInitial) {
      return Container();
    } else if (state is ListFetched) {
      _eventTypes = state.eventType;
      return HorizontalListWithTitle(
        title: 'Event Type',
        list: state.eventType,
        isListExpandable: false,
        onTap: _onEventTypeTapped,
      );
    } else if (state is EventTypeToggled) {
      _eventTypes = state.eventType;
      return HorizontalListWithTitle(
        title: 'Event Type',
        list: state.eventType,
        isListExpandable: false,
        onTap: _onEventTypeTapped,
      );
    }
    else if (_eventTypes != null && _eventTypes.isNotEmpty) {
      return HorizontalListWithTitle(
        title: 'EventType',
        list: _eventTypes,
        isListExpandable: false,
        onTap: _onEventTypeTapped,
      );
    }
  }

  _setUploadImageText(CreateEventStates state) {
    String _text;

    if (state is ImageUploaded) {
      _text = p.basename(state.fileName);
    } else {
      _text = "Add Cover Image";
    }

    return Text(
      _text,
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  _onEventTypeTapped(int index) {

    _createEventBloc.dispatch(EventTypePressed(index: index));
  }
}
