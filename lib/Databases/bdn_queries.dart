import '../Models/BDNModel.dart';
import 'db_helper.dart';

class BDNInfoDB {
  static const String tblBDN = 'BDN_table';
  static const String tblConfCheck = 'ConfCheck_table';
  static const String tblSealNos = 'SealNos_table';

  // SAVE: BDN save into DB
  static Future<String?> saveBDNInfoToDB(BDN bdnInfo) async {
    String msg = '';
    try {
      final db = await DatabaseHelper.db();

      await db.transaction((txn) async {
        //Save BDN
        List<Map<String, dynamic>> jobItems = await txn.rawQuery(
            'SELECT jobItemID FROM $tblBDN WHERE jobItemID = ?',
            [bdnInfo.jobItemID]);

        print("========= Already Saved BDN =============| $jobItems |");

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
                                      null, // date
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
                                      null // createdAt
                                  ]);

          print('Inserted record ID: $bdnID');

          //Save supplier confirm using saved BDN id
          await Future.forEach(bdnInfo.supConf as Iterable<SupConf>, (SupConf supConf) async {
            int supConId = await txn.rawInsert('''
                                  INSERT INTO $tblConfCheck (
                                    bdnID,
                                    regCode,
                                    value,
                                    spValue,
                                    isSubmit,
                                    bitActive,
                                    createdBy,
                                    createdAt
                                  ) VALUES (
                                    ?, ?, ?, ?, ?, ?, ?, ?
                                  )
                                ''', [
                                        bdnID, // bdnID
                                        supConf.regCode, // regCode
                                        supConf.value, // value
                                        supConf.spValue, // spValue
                                        0, // isSubmit
                                        1, // bitActive
                                        333, // createdBy
                                        null // createdAt
                                      ]);

            print('Inserted record ID (tblConfCheck): $supConId');
          });

          //Save sealNo and counterSealNo using saved BDN id
          await Future.forEach(bdnInfo.sampleIssue as Iterable<SampleIssue>, (SampleIssue sampleIssue) async {
            await txn.rawInsert('''
                    INSERT INTO $tblSealNos (
                      bdnID,
                      sealNo,
                      conSealNo,
                      issueParty,
                      bitActive,
                      createdBy,
                      createdAt
                    ) VALUES (
                      ?, ?, ?, ?, ?, ?, ?
                    )
                  ''', [
                          bdnID, // bdnID
                          sampleIssue.sealNo, // sealNo
                          sampleIssue.conSealNo, // conSealNo
                          sampleIssue.issueParty, // issueParty
                          1, // bitActive
                          333, // createdBy
                          null // createdAt
                        ]);
          });

          print("BDN SAVE SUCCESS.");
          msg = "BDN SAVE SUCCESS.";
        } else {
          print("BDN Already Saved!");
          msg = "BDN Already Saved!";
        }
      });
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }

    return msg;
  }

  // GET: Get a full BDN by
  static Future<BDN> getBDNByJobItemID(int jobItemID, int bdnID) async {
    // try {

      BDN bdnResult = BDN();

      final db = await DatabaseHelper.db();

      List<Map<String, dynamic>> result = await db.query(
          tblBDN,
          where: 'jobItemID=? AND bdnID=?',
          whereArgs: [jobItemID.toString(), bdnID.toString()]);


      // get jobItems and bind to the main job
      if (result.isNotEmpty) {
        // Map<String, dynamic> newMap = Map<String, dynamic>.from(bdnResult.first);
        // print(newMap);
        // bdnList.add(newMap);

        bdnResult = result.map((row) => BDN.fromJson(row)).first;

        List<Map<String, dynamic>> confCheckResult = await db.query(
            tblConfCheck,
            where: 'bdnID=?',
            whereArgs: [bdnID.toString()]);

        // bind the confCheckResult to main list
        print(confCheckResult);
        bdnResult.supConf = confCheckResult.map((row) => SupConf.fromJson(row)).toList();


        List<Map<String, dynamic>> sealNosResult = await db.query(
            tblSealNos,
            where: 'bdnID=?',
            whereArgs: [bdnID.toString()]);

        // bind the sealNosResult to main list
        print(sealNosResult);
        bdnResult.sampleIssue = sealNosResult.map((row) => SampleIssue.fromJson(row)).toList();
      }

      print('====== BDN FETCHE ====== \n$bdnResult');
      return bdnResult;
    // } catch (err) {
    //   print(err.toString());
    //   throw Exception(err.toString());
    // }
  }

  // GET: Get only few BDN data
  static Future<List<Map<String, dynamic>>> getJobListByDate() async {
    try {
      final db = await DatabaseHelper.db();

      List<Map<String, dynamic>> bdnList = [];

      List<Map<String, dynamic>> result = await db.query(tblBDN);

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
}
