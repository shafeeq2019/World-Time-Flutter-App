import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_time/services/helperFunctions.dart';
import 'dart:convert';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future setupWorldTime() async {
    if (await HelperFunctions.checkIntenetConnection()) {
      final prefs = await SharedPreferences.getInstance();
      final location = prefs.getString('location') ?? 'Berlin';
      final url = prefs.getString('url') ?? 'Europe/Berlin';
      WorldTime instance =
          WorldTime(flag: 'germany.png', location: location, url: url);
      await instance.getTime();
      await instance.getWeather();
      //Navigator.pushNamed(context, '/home');
      // we push this route on top of the loading route, but we dont want to keep the loading routes underneath so :
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "location": instance.location,
        "flag": instance.flag,
        "time": instance.time,
        "isDaytime": instance.isDaytime,
        "url": instance.url,
        "weatherData": instance.weatherData
      });
    } else {
      HelperFunctions.showNoConnectionDialog(context).then((data) async {
        await setupWorldTime();
      });
    }
  }

  @override
  void initState() {
    super
        .initState(); // this says: run the original function at first (that we are overriding)
    setupWorldTime();
  }

  final spinkit = SpinKitSquareCircle(
    color: Colors.blue[900],
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(padding: EdgeInsets.all(50), child: spinkit));
  }
}
