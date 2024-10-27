import 'package:sqflite/sqflite.dart';

import './db_helper.dart';

class LocationAndBerthedTypeDB {
  // Table Names
  static const String tblLocations = 'Location_table';
  static const String tblBerthedTypes = 'BerthedType_table';

  // SAVE TO DB: Locations
  static Future saveLocationListToDB(locationList) async {
    try {
      final db = await DatabaseHelper.db();

      await db.rawDelete('DELETE FROM $tblLocations').then((onValue) async {
        print('=== LOCATION TABLE DATA DELETED ===');
      });

      for (var location in locationList) {
        await db
            .insert(
                tblLocations,
                {
                  'varLocationCode': location['varLocationCode'],
                  'varLocationName': location['varLocationName'],
                  'bitActive': 1,
                  'createdAt': DateTime.now().toString()
                },
                conflictAlgorithm: ConflictAlgorithm.replace)
            .then((resId) {
          print('=== LOCATION LIST INSERTED ID: $resId');
        });
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // SAVE TO DB: BerthedTypeCodes
  static Future saveBerthedTypeListToDB(berthedTypeList) async {
    try {
      final db = await DatabaseHelper.db();

      await db.rawDelete('DELETE FROM $tblBerthedTypes').then((onValue) async {
        print('=== BERTHED TYPE TABLE DATA DELETED ===');
      });

      for (var berthedType in berthedTypeList) {
        await db
            .insert(
                tblBerthedTypes,
                {
                  'varBerthedTypeCode': berthedType['varBerthedTypeCode'],
                  'varBerthedTypeName': berthedType['varBerthedTypeName'],
                  'bitActive': 1,
                  'createdAt': DateTime.now().toString()
                },
                conflictAlgorithm: ConflictAlgorithm.replace)
            .then((resId) {
          print('=== BERTHED TYPE LIST INSERTED ID: $resId');
        });
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET FROM DB: Locations
  static Future<List> getAllLocation() async {
    try {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> locationList = await db.query(
        tblLocations,
        columns: ['varLocationCode', 'varLocationName'],
      );
      print('====== LOCATION LIST FETCHED ====== \n$locationList');
      return locationList;
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  // GET FROM DB: BerthedTypes
  static Future<List> getAllBerthedType() async {
    try {
      final db = await DatabaseHelper.db();
      List<Map<String, dynamic>> berthedTypeList = await db.query(
        tblBerthedTypes,
        columns: ['varBerthedTypeCode', 'varBerthedTypeName'],
      );
      print('====== BERTHED TYPE FETCHED ====== \n$berthedTypeList');
      return berthedTypeList;
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }
}
