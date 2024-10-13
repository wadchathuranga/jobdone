import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:sqflite/sqflite.dart';

import './db_helper.dart';

class BargeAllocationDB {
  // Table Names
  static const String tblBargeAllocation = 'BargeAllocation_table';
  static const String tblJobItem = 'JobItem_table';

  // SAVE: barge allocation
  static Future saveBargeAllocationListToDB(jobAllocationList) async {
    try {
      final db = await DatabaseHelper.db();

      await db
          .rawDelete('DELETE FROM $tblBargeAllocation')
          .then((onValue) async {
        print('=== DELETE JOB ALLOCATION TABLE DATA ===');

        await db.rawDelete('DELETE FROM $tblJobItem').then((onValue) async {
          print('=== DELETE JOB ITEM TABLE DATA ===');

          for (var jobAllocation in jobAllocationList) {
            await db.transaction((txn) async {
              // main insert query
              int resId = await txn.rawInsert(
                  '''INSERT INTO $tblBargeAllocation(
            jobID, 
            jobNo,
            vesselID,
            vesselName,
            bargeAllocationID,
            assignedToDateTime,
            assignedFromDateTime,
            customerName,
            estimatedStart,
            estimatedEnd,
            imoNumber,
            port,
            berthedTypeCode,
            bunkerTanker,
            agencyBranchName,
            locationName,
            agencyBranchID,
            agencyBranchCode,
            bargeID,
            bitActive,
            createdDate
          ) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)''',
                  [
                    jobAllocation['jobID'],
                    jobAllocation['jobNo'],
                    jobAllocation['vesselID'],
                    jobAllocation['vesselName'],
                    jobAllocation['bargeAllocationID'],
                    jobAllocation['assignedFromDateTime'],
                    jobAllocation['assignedToDateTime'],
                    jobAllocation['customerName'],
                    jobAllocation['estimatedStart'],
                    jobAllocation['estimatedEnd'],
                    jobAllocation['imoNumber'],
                    jobAllocation['port'],
                    jobAllocation['berthedTypeCode'],
                    jobAllocation['bunkerTanker'],
                    jobAllocation['locationName'],
                    jobAllocation['agencyBranchID'],
                    jobAllocation['agncyBranchName'],
                    jobAllocation['agencyBranchCode'],
                    jobAllocation['bargeID'],
                    1,
                    DateTime.now().toString()
                  ]);
              print(
                  '=== BARGE ALLOCATION INSERTED ID: $resId - ${jobAllocation['jobID']}');

              //sub insert query
              if (jobAllocation['jobItems'].length > 0) {
                for (var jobItem in jobAllocation['jobItems']) {
                  int jobItemResId =
                      await txn.rawInsert('''INSERT INTO $tblJobItem(
                    jobID,
                    jobItemDtID,
                    productCode,
                    maxQty,
                    minQty,
                    isItemExist,
                    bitActive,
                    createdAt
                ) VALUES(?, ?, ?, ?, ?, ?, ?, ?)''', [
                    jobAllocation['jobID'],
                    jobItem['jobItemDTID'],
                    jobItem['productCode'],
                    jobItem['maxQty'],
                    jobItem['minQty'],
                    jobItem['isItemExist'],
                    1,
                    DateTime.now().toString()
                  ]);
                  print(
                      '=== JOB ITEM INSERTED ID: $jobItemResId - ${jobAllocation['jobID']}');
                }
              }
            });

            // final resId = await db
            //     .insert(
            //         tblBargeAllocation,
            //         {
            //           'jobID': jobAllocation['jobID'],
            //           'jobNo': jobAllocation['jobNo'],
            //           'vesselID': jobAllocation['vesselID'],
            //           'vesselName': jobAllocation['vesselName'],
            //           'bargeAllocationID': jobAllocation['bargeAllocationID'],
            //           'assignedFromDateTime': jobAllocation['assignedFromDateTime'],
            //           'assignedToDateTime': jobAllocation['assignedToDateTime'],
            //           'customerName': jobAllocation['customerName'],
            //           'estimatedStart': jobAllocation['estimatedStart'],
            //           'estimatedEnd': jobAllocation['estimatedEnd'],
            //           'imoNumber': jobAllocation['imoNumber'],
            //           'port': jobAllocation['port'],
            //           'berthedTypeCode': jobAllocation['berthedTypeCode'],
            //           'berthedLocation': jobAllocation[''],
            //           'bunkerTanker': jobAllocation['bunkerTanker'],
            //           'locationName': jobAllocation['locationName'],
            //           'agencyBranchID': jobAllocation['agencyBranchID'],
            //           'agencyBranchName': jobAllocation['agncyBranchName'],
            //           'agencyBranchCode': jobAllocation['agencyBranchCode'],
            //           'bargeID': jobAllocation['bargeID'],
            //           'bitActive': 1,
            //           'createdDate': DateTime.now().toString()
            //         },
            //         conflictAlgorithm: ConflictAlgorithm.replace)
            //     .then((bargeAllocationResId) async {
            //   print(
            //       '=== BARGE ALLOCATION INSERTED ID: $bargeAllocationResId - jobID: ${jobAllocation['jobID']}');
            // if (jobAllocation['jobItems'].length > 0) {
            //   for (var jobItem in jobAllocation['jobItems']) {
            //     final jobItemResId = await db
            //         .insert(
            //             tblJobItem,
            //             {
            //               'jobID': jobAllocation['jobID'],
            //               'jobItemDtID': jobItem['jobItemDTID'],
            //               'productCode': jobItem['productCode'],
            //               'maxQty': jobItem['maxQty'],
            //               'minQty': jobItem['minQty'],
            //               'isItemExist': jobItem['isItemExist'],
            //               'bitActive': 1,
            //               'createdAt': DateTime.now().toString()
            //             },
            //             conflictAlgorithm: ConflictAlgorithm.replace)
            //         .then((jobItemResId) {
            //       print(
            //           '=== JOB ITEM INSERTED ID: $jobItemResId - jobID: ${jobAllocation['jobID']}');
            //     });
            //   }
            // }
            // });
          }
        });
      });
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET: barge allocation list
  static Future<List<Map<String, dynamic>>>
      getBargeAllocationListFromDB() async {
    try {
      var jobAllocationList = [];
      final db = await DatabaseHelper.db();

      List<Map<String, dynamic>> bargeAllocationList = await db.query(
        tblBargeAllocation,
        columns: [
          'jobID',
          'jobNo',
          'assignedFromDateTime',
          'assignedToDateTime'
        ],
      );

      if (bargeAllocationList.isNotEmpty) {
        for (int i = 0; i < bargeAllocationList.length; i++) {
          Map<String, dynamic> newMap =
              Map<String, dynamic>.from(bargeAllocationList[i]);
          print(newMap);
          jobAllocationList.add(newMap);

          List<Map<String, dynamic>> jobItems = await db.query(
            tblJobItem,
            //columns: ['otherData'],  // Specify the needed columns
            where: 'jobID = ?',
            whereArgs: [bargeAllocationList[i]['jobID']],
          );
          // bind the job items to main list
          print(jobItems);
          jobAllocationList[i]['jobItems'] = jobItems;
        }
      }

      print('====== ALL DATA FETCHES ====== \n$jobAllocationList');
      return bargeAllocationList;
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }
}
