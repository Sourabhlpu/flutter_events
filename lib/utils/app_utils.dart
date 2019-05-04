import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class AppUtils{
  static Future<bool> checkNetworkAvailability() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.

      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am connected to a wifi network.
      return false;
    }
  }


  static String formatDates(DateTime date) {

    return formatDate(date, [dd, " ", M, " ", yyyy]);
  }

  static String formatTime(TimeOfDay time) {
    String period = time.period == DayPeriod.am ? "am" : "pm";

    return time.hourOfPeriod.toString() + ":" + time.minute.toString() + period;
  }

  static int getDateInEpoch(DateTime date, TimeOfDay time)
  {
    DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    return dateTime.millisecondsSinceEpoch;
  }
  
  
}