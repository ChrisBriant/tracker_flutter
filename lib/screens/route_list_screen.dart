import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/screens/record_location_screen.dart';

import '../screens/add_route_screen.dart';
import '../screens/record_location_screen.dart';
import '../providers/db_provider.dart';

class RouteListScreen extends StatelessWidget {
  static const routeName = '/routelist';
  const RouteListScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DBProvider>(context,listen:false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Route List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<RecordedRoute>>(
              future: dbProvider.getRoutes(),
              builder: (ctx,routes) => routes.connectionState == ConnectionState.waiting
              ? CircularProgressIndicator()
              : Consumer<DBProvider>(
                builder: (ctx,db,_) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: db.loadedRoutes.length,
                  itemBuilder: (ctx,i) => ListTile(
                    key: ValueKey(db.loadedRoutes[i].id),
                    leading: Text(db.loadedRoutes[i].name),
                    //trailing: Text(db.loadedRoutes[i].description),
                    subtitle: Container(
                      width: 300,
                      color: Colors.amber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(db.loadedRoutes[i].description),
                          Text(db.loadedRoutes[i].dateAdded.toString())
                        ],
                      ),
                    ),
                    onTap: () {
                      dbProvider.selectedRoute = db.loadedRoutes[i];
                      Navigator.of(context).pushNamed(
                        RecordLocationScreen.routeName,
                        arguments: {'routeId' : db.selectedRoute.id}
                      );
                    },
                  ),
                )
                ),
              ),
              ElevatedButton(
                onPressed: () {Navigator.of(context).pushNamed(AddRouteScreen.routeName);}, 
                child: Text('Add Route')
              )
          ],
        ),
      )
    );
  }
}