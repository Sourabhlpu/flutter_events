import 'package:connectivity/connectivity.dart';

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
  
  
}