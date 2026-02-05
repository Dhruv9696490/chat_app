import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> isConnected();
}

class ConnectionCheckerImple implements ConnectionChecker {  
  final InternetConnection internetConnection;

  ConnectionCheckerImple({required this.internetConnection});
  @override
  Future<bool> isConnected() {
    return internetConnection.hasInternetAccess;
  }
}
