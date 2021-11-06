import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/screens/point_list_screen.dart';
import 'package:uuid/uuid.dart';

import '../providers/location_provider.dart';
import '../providers/db_provider.dart';


class RecordLocationScreen extends StatefulWidget {
  static const routeName = '/recordroute';
  const RecordLocationScreen({ Key? key }) : super(key: key);

  @override
  _RecordLocationScreenState createState() => _RecordLocationScreenState();
}

class _RecordLocationScreenState extends State<RecordLocationScreen> {
  double _lat = 0.0;
  double _lng = 0.0;
  bool recording = false;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<DBProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    DateTime dtLastUpdated = DateTime.now();
    bool _getLocation = false;
    int _sequenceNumber = 0;
    Timer.periodic(Duration(seconds: 10), (Timer timer) {
      _getLocation = true;
    });

    _addRoute() async {
      var uuid = Uuid();
      try {
        bool _success = await _dbProvider.insert('point',{
              'id' : uuid.v4(),
              'lat' : _lat,
              'lng' : _lng,
              'dateadded' : DateTime.now().toIso8601String(),
              'sequencenumber' : _sequenceNumber,
              'isstart' : 0,
              'isend' : 0,
              'routeid' : _dbProvider.selectedRoute.id,
        });
      } catch(err) {
        print(err);
      }
    }


    locationProvider.initLocation();
    locationProvider.locationObj.onLocationChanged.listen((event) { 
      //print(event.time);
      DateTime dtLocationUpdate = DateTime.fromMillisecondsSinceEpoch(event.time!.toInt());
      print(dtLocationUpdate.difference(dtLastUpdated).inSeconds);
      if(dtLocationUpdate.difference(dtLastUpdated).inSeconds >= 10) {
        dtLastUpdated = dtLocationUpdate;
      }
      //print('location changed');
      //print('${event.latitude}');
      if(_getLocation) {
        _getLocation = false;
        if(recording) {
          print('location changed');
          print('${event.latitude}');
          print('${event.longitude}');
          print(_sequenceNumber);
          _addRoute();
        }

        //Using set state breaks it
        //setState(() {
        _lat = event.latitude!;
        _lng = event.longitude!;
        //});
        _sequenceNumber++;
        
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Location'),
      ),
      body: Column(
        children: [
          _lat != null || _lng != null
          ? Text('$_lat, $_lng')
          : CircularProgressIndicator(),
          ElevatedButton(
            onPressed: () { setState(() {
              recording = !recording;
            });} , 
            child: recording 
            ? Text('Stop')
            : Text('Record')
          ),
          Visibility(
            visible: recording,
            child: Text('Recording')
          ),
          ElevatedButton(
            onPressed: () {Navigator.of(context).pushNamed(PointListScreen.routeName);}, 
            child: Text('View Points')
          )
        ],
      ),
    );
  }
}