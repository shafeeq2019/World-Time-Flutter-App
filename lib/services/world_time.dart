import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
   String? location; //location name for the UI
   String? time; // the time in that location
   String? flag; // URL to an asset flag icon
   String? url; //location url for API endpoint
   bool? isDaytime;
   static final _endPoint = "http://worldtimeapi.org/api/timezone";

  // Constructor
  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    // Future is like promise in JS, void means that i will return void but only when the function is fully complete
    try {
      var url_path = Uri.parse('$_endPoint/$url');
      Response response = await get(url_path);
      Map data = jsonDecode(response.body);
      DateTime now = DateTime.parse(data["datetime"]);
      int offset = int.parse(data["utc_offset"].substring(1,3));
      String operator = data["utc_offset"].substring(0,1);
      if (operator == "+") {
        now = now.add(new Duration(hours: offset));
      }
      else if (operator == "-") {
        now = now.subtract(new Duration(hours: offset));
      }
      //Set time property
      time = DateFormat.jm().format(now);
      isDaytime = now.hour > 6 && now.hour < 20 ? true: false;
    }
    catch(e) {
      print(e);
      time = "could not get time data";
    }
  }

   static Future<List<WorldTime>> getCountriesList() async {
     var url_path = Uri.parse(_endPoint);
     Response response = await get(url_path);
     List data = jsonDecode(response.body);
     List<WorldTime> countryList = data.map((e) {
       return WorldTime(url: e, location: e);
     }).toList();
     return countryList;
   }
}