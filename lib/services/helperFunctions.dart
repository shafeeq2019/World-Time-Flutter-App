import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';



class HelperFunctions {
  static Future checkIntenetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  static Future showNoConnectionDialog(BuildContext context)  {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('No internet connection'),
        content: const Text('Please check your internet connection!'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
