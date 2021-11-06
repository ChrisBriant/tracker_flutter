import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/screens/point_list_screen.dart';
import 'package:uuid/uuid.dart';

import '../providers/location_provider.dart';
import '../providers/db_provider.dart';


class RecordLocationScreen extends StatefulWidget {
  static const routeName = '/recordroute';

  @override
  _RecordLocationScreenState createState() => _RecordLocationScreenState();
}

class _RecordLocationScreenState extends State<RecordLocationScreen> {
  double _lat = 0.0;
  double _lng = 0.0;
  Location _location = new Location();
  int _sequenceNumber = 1;
  bool _recording = false;
  String routeId = '';

  _addRoute() async {
    print(routeId);
    if(routeId != '') {
      var uuid = Uuid();
      try {
        bool _success = await DBProvider.insert('point',{
              'id' : uuid.v4(),
              'lat' : _lat,
              'lng' : _lng,
              'dateadded' : DateTime.now().toIso8601String(),
              'sequencenumber' : _sequenceNumber,
              'isstart' : 0,
              'isend' : 0,
              'routeid' : routeId,
        });
      } catch(err) {
        print(err);
      }
    }

  }

  Future<void> _initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        print('Service is not enabled');
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      print('I should ask permission');
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print('Permission is not granted');
        return;
      }
    }

    _location.changeSettings(
      interval: 10000, 
    );
    _location.onLocationChanged.listen((event) { 
      if(_recording) {
        print('location changed');
        print('${event.latitude}');
        print('${event.longitude}');
        print(_sequenceNumber);
        _addRoute();
        _sequenceNumber++;
      }
      _lat = event.latitude!;
      _lng = event.longitude!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initLocation();
  }

  @override
  Widget build(BuildContext context) {
    final _dbProvider = Provider.of<DBProvider>(context, listen: false);
    //final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    routeId = _dbProvider.selectedRoute.id;



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
            onPressed: () { 
              setState(() {
                _recording = !_recording; 
              });
            } , 
            child: _recording 
            ? Text('Stop')
            : Text('Record')
          ),
          Visibility(
            visible: _recording,
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