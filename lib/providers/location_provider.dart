import 'dart:async';

import 'package:location/location.dart';
import 'package:flutter/widgets.dart';

class LocationProvider with ChangeNotifier{
  Location _location = new Location();
  LocationData? _locationData;
  LocationData? _initialLocationData;
  bool _getLocation = false;

  Future<dynamic> initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _getLocation = true;
    });

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

    // _location.onLocationChanged.listen((LocationData currentLocation) {
    //   // Use current location
    //   if(_getLocation) {
    //     print('New Location');
    //     _locationData = currentLocation;
    //     _getLocation = false;
    //     notifyListeners();
    //   }

    //   //notifyListeners();
    // });

    _locationData = await _location.getLocation();
    _initialLocationData = _locationData;
    return _locationData; 
  }


  Future<LocationData?> get location async {
    print('Location Data');
    print(_locationData);
    if(_locationData == null) {
      await initLocation();
    }
    return _locationData;
  }

  Future<LocationData?> get initialLocation async {
    if(_initialLocationData == null) {
      await initLocation();
    }
    return _initialLocationData;
  }


  LocationData get locationData  {
    return _locationData!;
  }

  Location get locationObj {
    return _location;
  }

}
 
