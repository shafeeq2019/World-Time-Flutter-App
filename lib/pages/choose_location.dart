import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  TextEditingController editingController = TextEditingController();

  var _future;
  String searchString = "";

  @override
  void initState() {
    super.initState();
    _future = WorldTime.getCountriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("Choose a location"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchString = value.toLowerCase();
                  });
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    fillColor: Colors.grey[100],
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            FutureBuilder(
              future: _future,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return snapshot.data[index].location
                                .toString()
                                .toLowerCase()
                                .contains(searchString)
                            ? Card(
                                child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 4),
                                child: ListTile(
                                  onTap: () async {
                                    await snapshot.data[index].getTime();
                                    await snapshot.data[index].getWeather();
                                    // the same thing as what the arrow do: Pop:
                                    Navigator.pop(context, {
                                      "location": snapshot.data[index].location,
                                      //flag": snapshot.data[index].flag,
                                      "time": snapshot.data[index].time,
                                      "isDaytime":
                                          snapshot.data[index].isDaytime,
                                      "url": snapshot.data[index].url,
                                      "weatherData":
                                          snapshot.data[index].weatherData
                                    });
                                  },
                                  title: Text(
                                      snapshot.data[index].location.toString()),
                                  //leading: CircleAvatar(backgroundImage: AssetImage('assets/${ snapshot.data[index].flag}'),),
                                ),
                              ))
                            : Container();
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          )
                        ]),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Loading...'),
                          )
                        ]),
                  );
                } else {
                  return Text("Error!");
                }
              },
            ),
          ],
        ));
  }
}
