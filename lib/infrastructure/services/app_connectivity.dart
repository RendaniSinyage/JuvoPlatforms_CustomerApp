import 'package:connectivity_plus/connectivity_plus.dart';

abstract class AppConnectivity {
  AppConnectivity._();

  static Future<bool> connectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }
}
