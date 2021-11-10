import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = data.isEmpty ? ModalRoute.of(context)!.settings.arguments as Map : data;
    String bgImage = "";
    // set background
    setState(() {
      bgImage = data['isDaytime'] ? 'day.jpg' : 'night.jpg';
    });


    Future<void> _refresh() async {



    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh:  () async {
          WorldTime instance = WorldTime(location: data["location"], url: data["url"]);
          await instance.getTime();
          setState(() {
            data["location"] = instance.location;
            data["time"] = instance.time;
            data["isDaytime"] = instance.isDaytime;
          });
        },
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(
            image: AssetImage('assets/$bgImage'),
            fit: BoxFit.cover
          )),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                    child: Column(
                      children: <Widget> [
                        FlatButton.icon(onPressed: () async  {
                          dynamic result = await Navigator.pushNamed(context, "/location");
                          if (result != null) {
                            setState(() {
                              data = result;
                            });
                          }
                        }, icon: Icon(Icons.edit_location, color: Colors.grey[300],), label: Text('Edit Location', style: TextStyle(color: Colors.white, letterSpacing: 2),)),
                        SizedBox(height:20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text(data["location"], style: TextStyle(fontSize: 28, letterSpacing: 2,color: Colors.white)),
                        ],),
                        SizedBox(height:20),
                        Text(data['time'],
                        style: TextStyle(
                          fontSize: 66,
                            color: Colors.white
                        ),)
                      ]
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
