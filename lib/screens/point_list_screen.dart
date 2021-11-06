import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/db_provider.dart';

class PointListScreen extends StatelessWidget {
  static const routeName = '/pointlist';

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
            FutureBuilder<List<Point>>(
              future: dbProvider.getPoints(),
              builder: (ctx,points) => points.connectionState == ConnectionState.waiting
              ? CircularProgressIndicator()
              : Consumer<DBProvider>(
                builder: (ctx,db,_) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: db.loadedPoints.length,
                  itemBuilder: (ctx,i) => ListTile(
                    key: ValueKey(db.loadedPoints[i].id),
                    title: Text(db.loadedPoints[i].id),
                    subtitle: Text(db.loadedPoints[i].sequenceNumber.toString()),
                    onTap: () {
                    },
                  ),
                )
                ),
              ),
              ElevatedButton(
                onPressed: () {}, 
                child: Text('A Button')
              )
          ],
        ),
      )
    );
  }
}