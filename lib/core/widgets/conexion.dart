import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetStatusWidget extends StatefulWidget {
  @override
  _InternetStatusWidgetState createState() => _InternetStatusWidgetState();
}

class _InternetStatusWidgetState extends State<InternetStatusWidget> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = false;

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          hasInternet = true;
        }
      } on SocketException catch (_) {
        hasInternet = false;
      }
    }

    setState(() {
      isConnected = hasInternet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.wifi : Icons.wifi_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            isConnected ? 'Conectado a Internet' : 'Sin conexión',
            style: TextStyle(
              color: isConnected ? Colors.green[900] : Colors.red[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
