import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/add_route_screen.dart';
import 'screens/route_list_screen.dart';
import 'screens/record_location_screen.dart';
import '../providers/location_provider.dart';
import '../providers/db_provider.dart';

void main() {
  runApp(Tracker());
}

class Tracker extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => LocationProvider()
        ),
        ChangeNotifierProvider(
          create: (ctx) => DBProvider()
        ),
      ],
      child: MaterialApp(
        title: 'Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RouteListScreen(),
        routes: {
          AddRouteScreen.routeName : (ctx) => AddRouteScreen(),
          RecordLocationScreen.routeName : (ctx) => RecordLocationScreen(),
        },
      ),
    );
  }
}
