import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

import '../helpers/custom_exception.dart';

class DBProvider with ChangeNotifier {
  List<RecordedRoute> _routes = [];
  RecordedRoute? _selectedRoute;
  List<Point> _selectedPoints = [];
  
  static Future<Database> database() async {  
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath,'routes.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE route(
	                              id TEXT PRIMARY KEY,
	                              name TEXT,
                                dateadded TEXT,
	                              description TEXT
                  );''');
        await db.execute('''CREATE TABLE point(
                              id TEXT PRIMARY KEY, 
                              lat REAL,
                              lng REAL,
                              dateadded TEXT,
                              sequencenumber INTEGER,
                              isstart INTEGER,
                              isend INTEGER, 
                              routeid TEXT,
                              FOREIGN KEY(routeid) REFERENCES route(id)
                            );
                            ''');
      },
      version: 1
    );
  } 

  Future<bool> insertRoute(String table, Map<String,Object> data) async {
    final db = await DBProvider.database();
    try {
      var id = await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      if(id != 0) {
        //Add to the list of routes before returning
        _routes.add(RecordedRoute(
          id: data['id'].toString(), 
          name: data['name'].toString(), 
          dateAdded: DateTime.parse(data['dateadded'].toString()),
          description: data['description'].toString()
        ));
        notifyListeners();
        return true;
      } else {
        throw CustomException('Unable to add to the database');
      }
    } catch(err) {
      throw CustomException('Unable to add to the database');
    }
  }

    static Future<bool> insert(String table, Map<String,Object> data) async {
    final db = await DBProvider.database();
    try {
      var id = await db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
      if(id != 0) {
        return true;
      } else {
        throw CustomException('Unable to add to the database');
      }
    } catch(err) {
      throw CustomException('Unable to add to the database');
    }
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBProvider.database();
    return db.query(table);
  }


  Future<List<RecordedRoute>> getRoutes() async {
    _routes.clear();
    final db = await DBProvider.database();
    //db.delete('route');
    //db.delete('point');
    notifyListeners();
    List<Map<String,Object?>> _resultSet =  await db.query('route');
    print('DB Results');
    for(var _result in _resultSet) {
      print(_result);
      _routes.add(
        RecordedRoute(
          id: _result['id'].toString(), 
          name: _result['name'].toString(), 
          dateAdded: DateTime.parse(_result['dateadded'].toString()), 
          description: _result['description'].toString()
        )
      );
    }
    return _routes;
  }

  Future<List<Point>> getPoints() async {
    final db = await DBProvider.database();
    List<Map<String,Object?>> _resultSet =  await db.query(
      'point',
      where: 'routeid = "${_selectedRoute!.id}"',           
    );
    for(var _result in _resultSet) {
      _selectedPoints.add(
        Point(
          id: _result['id'].toString(), 
          lat: double.parse(_result['lat'].toString()),
          lng: double.parse(_result['lng'].toString()), 
          dateAdded: DateTime.parse(_result['dateadded'].toString()), 
          sequenceNumber: int.parse(_result['sequencenumber'].toString()),
          isStart: _result['isstart'] == 1 ? true : false,
          isEnd: _result['isend'] == 1 ? true : false,
        )
      );
      print(_result);

    }
    return _selectedPoints;
  }

  Future<int> getRowCount(String table) async {
    final db = await DBProvider.database();
    //sql.Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table;')
      .then(
         (record) => record.length 
      );
      return 0;
    //);
    //return count;
    //return int.parse(db.rawQuery('SELECT COUNT(*) FROM $table;'));
  }

  List<RecordedRoute> get loadedRoutes {
    return _routes;
  }

  set selectedRoute(route) {
    _selectedRoute = route;
  }

  RecordedRoute get selectedRoute {
    return _selectedRoute!;
  }

  List<Point> get loadedPoints {
    return _selectedPoints;
  }

}

class RecordedRoute {
  String id;
  String name;
  DateTime dateAdded;
  String description;

  RecordedRoute({
    required this.id,
    required this.name,
    required this.dateAdded,
    required this.description
  });
}

class Point {
  String id;
  double lat;
  double lng;
  DateTime dateAdded;
  int sequenceNumber;
  bool isStart;
  bool isEnd;

  Point({
    required this.id,
    required this.lat,
    required this.lng,
    required this.dateAdded,
    required this.sequenceNumber,
    required this.isStart,
    required this.isEnd
  });

}