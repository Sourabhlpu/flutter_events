import 'package:built_collection/built_collection.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_events/blocs/bloc.dart';
import 'package:flutter_events/blocs/create_event_bloc.dart';
import 'package:flutter_events/models/event_types.dart';
import 'package:flutter_events/models/events/event.dart';
import 'package:flutter_events/ui/widgets/add_splash.dart';
import 'package:flutter_events/ui/widgets/horizontal_list_with_title.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import '../widgets/primary_btn.dart';

class CreateEventForm extends StatefulWidget {
  final CreateEventBloc createEventBoc;

  CreateEventForm({@required this.createEventBoc});

  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  List<EventTypes> _eventTypes;

  String _imageUrl;

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
  FocusNode focusNodeTitle;

  FocusNode focusNodeLocation;
  FocusNode focusNodeStartDate;
  FocusNode focusNodeStartTime;
  FocusNode focusNodeEndDate;
  FocusNode focusNodeEndTime;
  FocusNode focusNodeAmount;
  FocusNode focusNodeDescription;
  CreateEventBloc get _createEventBloc => widget.createEventBoc;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
        bloc: _createEventBloc,
        listener: (context, state) {
          if (state is CreateEventFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CreateEventEvents, CreateEventStates>(
            bloc: _createEventBloc,
            builder: (BuildContext context, CreateEventStates state) {
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
                          _setUploadImageText(state),
                          _createUploadImageButton(state)
                        ],
                      ),
                    ),
                    PrimaryGradientButton('Create Event', _createEvent, false)
                  ],
                ),
              );
            }));
  }

  @override
  void initState() {
    _createEventBloc.dispatch(FetchEventType());
    focusNodeTitle = FocusNode();
    focusNodeLocation = FocusNode();
    focusNodeStartDate = FocusNode();
    focusNodeEndDate = FocusNode();
    focusNodeStartTime = FocusNode();
    focusNodeEndTime = FocusNode();
    focusNodeAmount = FocusNode();
    focusNodeDescription = FocusNode();
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
      maxLength: 50,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      focusNode: focusNodeTitle,
      controller: _titleTextFieldController,
      decoration: inputDecoration('Title'),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) return 'Please enter a name for the event';
      },
      onFieldSubmitted: (_) {
        _shiftFocusNode(context, focusNodeTitle, focusNodeLocation);
      },
    );
  }

  _buildLocationField(CreateEventStates state) {
    if (state is LocationSelected) {
      _locationFieldController.text = state.location;
    }
    return AddSplash(
      onTap: () {
        _createEventBloc.dispatch(LocationTapped());
      },
      child: TextFormField(
        enabled: true,
        controller: _locationFieldController,
        focusNode: focusNodeLocation,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) return 'Please select a location';
        },
        decoration: inputDecoration('Location',
            icon: Icon(
              Icons.location_on,
              size: 16,
            )),
        onFieldSubmitted: (_) {
          _shiftFocusNode(context, focusNodeLocation, focusNodeStartDate);
        },
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
        focusNode: focusNodeStartDate,
        textInputAction: TextInputAction.next,
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
        onFieldSubmitted: (_) {
          _shiftFocusNode(context, focusNodeStartDate, focusNodeStartTime);
        },
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
        focusNode: focusNodeStartTime,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) return 'Please enter start time';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.clock,
              size: 16,
            )),
        onFieldSubmitted: (_) {
          _shiftFocusNode(context, focusNodeStartTime, focusNodeEndDate);
        },
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
        focusNode: focusNodeEndDate,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) return 'Please enter end date';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.calendar,
              size: 16,
            )),
        onFieldSubmitted: (_) {
          _shiftFocusNode(context, focusNodeEndDate, focusNodeEndTime);
        },
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
        focusNode: focusNodeEndTime,
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value.isEmpty) return 'Please enter end time';
        },
        decoration: inputDecoration(title,
            icon: Icon(
              FontAwesomeIcons.clock,
              size: 16,
            )),
        onFieldSubmitted: (_) {
          _shiftFocusNode(context, focusNodeEndTime,
              _showEntryFeesField ? focusNodeAmount : focusNodeDescription);
        },
      ),
    );
  }

  _buildAmountTextField(String title, BuildContext context) {
    return TextFormField(
      maxLines: 1,
      controller: _entryFeesTextFieldController,
      focusNode: focusNodeAmount,
      decoration: inputDecoration(title),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) return 'Please enter entry fees';
      },
    );
  }

  _buildDescriptionTextField(String title, BuildContext context) {
    return TextFormField(
      maxLength: 500,
      maxLines: null,
      focusNode: focusNodeDescription,
      textInputAction: TextInputAction.done,
      controller: _descriptionTextFieldController,
      keyboardType: TextInputType.multiline,
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

  _createUploadImageButton(CreateEventStates state) {
    if (state is UploadingImage) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _createEventBloc.dispatch(AddCoverImageTapped());
        },
      );
    }
  }

  _formatTimeOfDay(TimeOfDay timeOfDay) {
    String period = timeOfDay.period == DayPeriod.am ? "am" : "pm";

    return timeOfDay.hourOfPeriod.toString() +
        ":" +
        timeOfDay.minute.toString() +
        period;
  }

  _onEventTypeTapped(int index) {
    _createEventBloc.dispatch(EventTypePressed(index: index));
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
    } else if (_eventTypes != null && _eventTypes.isNotEmpty) {
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
      _text = p.basename(state.localFileName);
      _imageUrl = state.imageUrl;
    } else if (state is UploadingImage) {
      _text = "uploading...";
    } else {
      _text = "Add Cover Image";
    }

    return Text(
      _text,
      style: TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  _shiftFocusNode(BuildContext context, FocusNode currentFocusNode,
      FocusNode nextFocusNode) {
    currentFocusNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocusNode);
  }

  @override
  void dispose() {
    focusNodeTitle.dispose();
    focusNodeLocation.dispose();
    focusNodeStartTime.dispose();
    focusNodeEndTime.dispose();
    focusNodeStartDate.dispose();
    focusNodeEndDate.dispose();
    focusNodeAmount.dispose();
    focusNodeDescription.dispose();
  }


}
