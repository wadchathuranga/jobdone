import 'package:intl/intl.dart';
import 'package:jobdone/Databases/bargePara_queries.dart';
import 'package:jobdone/Models/ApiResponse.dart';
import 'package:jobdone/Models/DbResponseModel.dart';

import '../Models/BDNModel.dart';
import 'db_helper.dart';

class BDNInfoDB {
  static const String tblBDN = 'BDN_table';
  static const String tblConfCheck = 'ConfCheck_table';
  static const String tblSealNos = 'SealNos_table';
  static const String tblBargeAllocation = 'BargeAllocation_table';
  static const String tblJobItem = 'JobItem_table';
  static const String tblBargePara = 'BargePara_table';

  // SAVE: BDN save into DB
  static Future<bool> saveBDNInfoToDB(BDN bdnInfo) async {
    bool isSuccess = false;
    try {
      final db = await DatabaseHelper.db();

      await db.transaction((txn) async {
        List<Map<String, dynamic>> jobItems = await txn.rawQuery(
            'SELECT jobItemID FROM $tblBDN WHERE jobItemID = ? AND bitActive = ?',
            [bdnInfo.jobItemID, 1]);

        if (jobItems.isEmpty) {
          //INSERT BDN INFO TO LOCAL DB
          int? bdnID = await txn.rawInsert('''
                                INSERT INTO $tblBDN (
                                  jobID,
                                  jobNo,
                                  date,
                                  bdnNo,
                                  bargeBdnNo,
                                  alongSide,
                                  pumpingCom,
                                  comp,
                                  jobItemID,
                                  jobProductCode,
                                  viscocity,
                                  waterContent,
                                  sulphurContent,
                                  density,
                                  flashPoint,
                                  grObVolume,
                                  grStVolume,
                                  qty,
                                  barSixtyF,
                                  temp,
                                  nameStamp,
                                  fullName,
                                  remark,
                                  companyID,
                                  agencyID,
                                  locationCode,
                                  berthedTypeCode,
                                  berthedLocation,
                                  grossTonnage,
                                  ownerOperator,
                                  nextPort,
                                  dteVslETD,
                                  isUpload,
                                  bitActive,
                                  createdBy,
                                  createdAt
                                ) VALUES (
                                  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
                                )
                              ''', [
            bdnInfo.jobID, // jobID
            bdnInfo.jobNo, // jobNo
            DateTime.now().toIso8601String(), // date
            bdnInfo.bdnNo, // bdnNo
            bdnInfo.bargeBdnNo, // bargeBdnNo
            bdnInfo.alongSide, // alongSide
            bdnInfo.pumpingCom, // pumpingCom
            bdnInfo.comp, // comp
            bdnInfo.jobItemID, // jobItemID
            bdnInfo.jobProductCode, // jobProductCode
            bdnInfo.viscocity, // viscocity
            bdnInfo.waterContent, // waterContent
            bdnInfo.sulphurContent, // sulphurContent
            bdnInfo.density, // density
            bdnInfo.flashPoint, // flashPoint
            bdnInfo.grObVolume, // grObVolume
            bdnInfo.grStVolumne, // grStVolume
            bdnInfo.qty, // qty
            bdnInfo.barsixtyF, // barSixtyF
            bdnInfo.temp, // temp
            bdnInfo.nameStamp, // nameStamp
            bdnInfo.fullName, // fullName
            bdnInfo.remark, // remark
            bdnInfo.companyID, // companyID
            bdnInfo.agencyID, // agencyID
            bdnInfo.locationCode, // locationCode
            bdnInfo.berthedTypeCode, // berthedTypeCode
            bdnInfo.berthedLocation, // berthedLocation
            bdnInfo.grosstonnage, // grossTonnage
            bdnInfo.owneroparator, // ownerOperator
            bdnInfo.nextPort, // nextPort
            bdnInfo.dteVslETD, // dteVslETD
            0, // isUpload
            1, // bitActive
            333, // createdBy
            DateTime.now().toIso8601String() // createdAt
          ]);


          //Save supplier confirm using saved BDN id
          await Future.forEach(bdnInfo.supConf as Iterable<SupConf>,
              (SupConf supConf) async {
            int supConId = await txn.rawInsert('''
                                  INSERT INTO $tblConfCheck (
                                    bdnID,
                                    jobItemID,
                                    regCode,
                                    value,
                                    spValue
                                  ) VALUES (
                                    ?, ?, ?, ?, ?
                                  )
                                ''', [
              bdnID, // bdnID
              bdnInfo.jobItemID, // jobItemID
              supConf.regCode, // regCode
              supConf.value, // value
              supConf.spValue // spValue
            ]);
          });

          //Save sealNo and counterSealNo using saved BDN id
          await Future.forEach(bdnInfo.sampleIssue as Iterable<SampleIssue>,
              (SampleIssue sampleIssue) async {
            int sealNosId = await txn.rawInsert('''
                    INSERT INTO $tblSealNos (
                      bdnID,
                      jobItemID,
                      sealNo,
                      conSealNo,
                      issueParty
                    ) VALUES (
                      ?, ?, ?, ?, ?
                    )
                  ''', [
              bdnID, // bdnID
              bdnInfo.jobItemID, // jobItemID
              sampleIssue.sealNo, // sealNo
              sampleIssue.conSealNo, // conSealNo
              sampleIssue.issueParty // issueParty
            ]);
          });

          // Update the jobItem Status
          await txn.rawUpdate(
            'UPDATE $tblJobItem SET isItemExist = ? WHERE jobItemDtID = ?',
            [
              1,
              bdnInfo.jobItemID,
            ],
          );

          // Update barge wise BDN sequence
          int userID = 15; //TODO: get userID from the token

          await txn.rawUpdate(
            'UPDATE $tblBargePara SET numBargeBDNSequence = numBargeBDNSequence + 1 WHERE numUserID = ?',
            [userID],
          );

          isSuccess = true;
        } else {
          print("========= Already Saved BDN =============| $jobItems |");
          isSuccess = false;
        }
      });
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }

    return isSuccess;
  }

  /// GET: Get a full BDN by jobItemID
  static Future<Map<String, dynamic>> getBDNByJobItemID(int jobItemID) async {
    try {
      final db = await DatabaseHelper.db();

      Map<String, dynamic> bdnObj = {};

      List<Map<String, dynamic>> result = await db.query(tblBDN,
          where: 'jobItemID=?', whereArgs: [jobItemID.toString()]);

      if (result.isNotEmpty) {
        bdnObj = Map<String, dynamic>.from(result.first);

        List<Map<String, dynamic>> confCheckResult = await db.query(
            tblConfCheck,
            where: 'jobItemID=?',
            whereArgs: [jobItemID.toString()]);

        // bind the confCheckResult to main obj
        confCheckResult = confCheckResult.map((item) {
          Map<String, dynamic> newMapConfCheck = Map<String, dynamic>.from(item);
          newMapConfCheck['value'] = (newMapConfCheck['value'] == 1) ? true : false;
          return newMapConfCheck;
        }).toList();


        List<Map<String, dynamic>> sealNosResult = await db.query(tblSealNos,
            where: 'jobItemID=?', whereArgs: [jobItemID.toString()]);

        // bind the sealNosResult to main obj
        bdnObj.addAll({
          'supConf': confCheckResult,
          'sampleIssue': sealNosResult
        });
      }

      print('====== BDN FETCHES ====== \n$bdnObj');
      return bdnObj;
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  /// GET: Get only few BDN data
  static Future<List<Map<String, dynamic>>> getJobListByDate() async {
    try {
      final db = await DatabaseHelper.db();

      List<Map<String, dynamic>> bdnList = [];

      List<Map<String, dynamic>> result = await db.query(
        tblBDN,
        columns: [
          'jobID',
          'jobNo',
          'bdnNo',
          'bdnID',
          'jobItemID',
          'bargeBdnNo',
          'jobProductCode',
          'isUpload',
          'bitActive',
          'createdAt',
        ],
      );

      for (var row in result) {
        Map<String, dynamic> newMap = Map<String, dynamic>.from(row);
        bdnList.add(newMap);
      }

      print('====== SAVED BDN LIST FETCHES ====== \n$bdnList');
      return bdnList;
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  /// PATCH: Update BDN uploading status by bdnID
  static void updateBDNByJobItemID(int jobItemID) async {
    try {
      final db = await DatabaseHelper.db();

      int result = await db.update(
          tblBDN,
          {
            'isUpload': 1,
          },
          where: 'jobItemID=?',
          whereArgs: [jobItemID.toString()]);

      print('====== JOB ITEM STATUS UPDATED ====== \n$result');
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  /// DELETE: Delete or Inactive BDN status by bdnID
  static Future<DbResponse> inactiveBDNStatusByBDNID(int bdnID) async {
    try {
      final db = await DatabaseHelper.db();

      int result = await db.update(
          tblBDN,
          {
            'bitActive': 0,
          },
          where: 'bdnID = ? AND isUpload = ? AND bitActive = ?',
          whereArgs: [bdnID.toString(), 0, 1]);

      if (result > 0) {
        return DbResponse(
          status: true,
          message: 'BDN has been inactivated.',
        );
      } else {
        return DbResponse(
          status: false,
          message: 'BDN is already uploaded!',
        );
      }
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }
}
