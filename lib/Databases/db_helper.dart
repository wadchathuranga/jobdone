import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:async';

class DatabaseHelper {
  // DB Names
  static const String dbName = 'bms_mob.db';

  // Table Names
  static const String tblBDN = 'BDN_table';
  static const String tblConfCheck = 'ConfCheck_table';
  static const String tblSealNos = 'SealNos_table';
  static const String tblBargeAllocation = 'BargeAllocation_table';
  static const String tblJobItem = 'JobItem_table';
  static const String tblPortOfDelivery = 'PortOfDelivery_table';
  static const String tblLocationOfSupply = 'LocationOfSupply_table';
  static const String tblBargePara = 'BargePara_table';

  // Columns Names
  static const String col_id = 'id';
  static const String col_bitActive = 'bitActive';
  static const String col_createdAt = 'createdAt';
  static const String col_createdBy = 'createdBy';

  // table schema define
  static Future<void> createTable(sql.Database database) async {
    await database.execute('''
        CREATE TABLE $tblBDN(
          bdnID INTEGER PRIMARY KEY AUTOINCREMENT,
          jobID INTEGER NULL,
          date TEXT NULL,
          bdnNo TEXT NULL,
          bargeBdnNo TEXT NULL,
          alongSide TEXT NULL,
          pumpingCom TEXT NULL,
          comp TEXT NULL,
          jobItemID INTEGER NULL,
          jobProductCode TEXT NULL,
          viscocity REAL NULL,
          waterContent REAL NULL,
          sulphurContent REAL NULL,
          density REAL NULL,
          flashPoint REAL NULL,
          grObVolume REAL NULL,
          grStVolume REAL NULL,
          qty REAL NULL,
          barSixtyF REAL NULL,
          temp REAL NULL,
          nameStamp TEXT NULL,
          fullName TEXT NULL,
          remark TEXT NULL,
          companyID INTEGER NULL,
          agencyID INTEGER NULL,
          locationCode TEXT NULL,
          berthedTypeCode TEXT NULL,
          berthedLocation TEXT NULL,
          grossTonnage REAL NULL,
          ownerOperator TEXT NULL,
          nextPort TEXT NULL,
          dteVslETD TEXT NULL,
          isUpload INTEGER NOT NULL DEFAULT 0,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdBy INTEGER NULL,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblConfCheck(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          bdnID INTEGER NOT NULL,
          regCode INTEGER NULL,
          value INTEGER NULL,
          spValue REAL NULL,
          col_isSubmit INTEGER NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdBy INTEGER NULL,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblSealNos(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          bdnID INTEGER NOT NULL,
          sealNo TEXT NULL,
          conSealNo TEXT NULL,
          issueParty TEXT NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdBy INTEGER NULL,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblBargeAllocation(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          jobID INTEGER NULL,
          jobNo TEXT NULL,
          vesselID INTEGER NULL,
          vesselName TEXT NULL,
          bargeAllocationID INTEGER NULL,
          assignedToDateTime TEXT NULL,
          assignedFromDateTime TEXT NULL,
          customerName TEXT NULL,
          estimatedStart TEXT NULL,
          estimatedEnd TEXT NULL,
          imoNumber TEXT NULL,
          port TEXT NULL,
          berthedTypeCode TEXT NULL,
          bunkerTanker TEXT NULL,
          createdDate TEXT NULL,
          agencyBranchName TEXT NULL,
          locationName TEXT NULL,
          agencyBranchID INTEGER NULL,
          agencyBranchCode TEXT NULL,
          bargeID INTEGER NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblJobItem(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          jobID INTEGER NULL,
          jobItemDtID INTEGER NULL,
          productCode TEXT NULL,
          maxQty REAL NULL,
          minQty REAL NULL,
          isItemExist INTEGER NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdBy INTEGER NULL,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblPortOfDelivery(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          varLocationCode TEXT NULL,
          varLocationName TEXT NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblLocationOfSupply(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          varBerthedTypeCode TEXT NULL,
          varBerthedTypeName TEXT NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdAt TEXT NULL
        )
    ''');

    await database.execute('''
        CREATE TABLE $tblBargePara(
          $col_id INTEGER PRIMARY KEY AUTOINCREMENT,
          numBargeID INTEGER NULL,
          numUserID INTEGER NULL,
          varBargeCode TEXT NULL,
          numBargeBDNSequence INTEGER NOT NULL,
          $col_bitActive INTEGER NOT NULL DEFAULT 1,
          $col_createdAt TEXT NULL
        )
    ''');
  }

  // create database & tables
  static Future<sql.Database> db() async {
    return sql.openDatabase(dbName, version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTable(database);
      if (kDebugMode) {
        print('$database Database created.');
      }
    });
  }

  // Drop specific table
  // static Future<void> dropSpecificTable(String tblName) async {
  //   final db = await DatabaseHelper.db();
  //   db.delete(tblName);
  //   if (kDebugMode) {
  //     print('$tblName Dropped / Deleted!');
  //   }
  //   return;
  //}

  // Drop all tables
  // static Future<void> dropAllTables() async {
  //   final db = await DatabaseHelper.db();
  //   db.delete(tblPropertyInspection);
  //   if (kDebugMode) {
  //     print('All Tables Dropped / Deleted!');
  //   }
  //   return;
  // }
}
