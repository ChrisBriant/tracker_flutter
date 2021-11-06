import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/screens/point_list_screen.dart';
import 'package:uuid/uuid.dart';

import '../providers/location_provider.dart';
import '../providers/db_provider.dart';


class RecordLocationScreen extends StatelessWidget {
  static const routeName = '/recordroute';

  double _lat = 0.0;
  double _lng = 0.0;
  bool recording = false;
  

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<DBProvider>(context, listen: false);
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    int _sequenceNumber = 1;

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
    locationProvider.locationObj.changeSettings(
      interval: 10000, 
    );
    locationProvider.locationObj.onLocationChanged.listen((event) { 
      if(recording) {
        print('location changed');
        print('${event.latitude}');
        print('${event.longitude}');
        print(_sequenceNumber);
        //_addRoute();
        _sequenceNumber++;
      }
      _lat = event.latitude!;
      _lng = event.longitude!;
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
            onPressed: () { recording = !recording; } , 
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