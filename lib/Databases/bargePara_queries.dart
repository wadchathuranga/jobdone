import 'db_helper.dart';

class BargeParaDB {
  static const String tblBargePara = 'BargePara_table';

  static Future<Map<String, dynamic>> getBargeParaFromDB() async {
    try {
      int userID = 15;

      final db = await DatabaseHelper.db();

      List<Map<String, dynamic>> bargePara = await db.rawQuery(
          'SELECT numUserID, numBargeID, varBargeCode, numBargeBDNSequence FROM $tblBargePara WHERE numUserID = ?',
          [userID]);

      print('====== BARGE PARA FETCHES ====== \n$bargePara');
      return bargePara[0];
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  // SAVE: barge para save in DB
  static Future saveBargeParaDataToDB(bargeParaFromServer) async {
    try {
      final db = await DatabaseHelper.db();

      await db.transaction((txn) async {
        List<Map<String, dynamic>> bargeParaFromDB = await txn.rawQuery(
            'SELECT numUserID, numBargeID, numBargeBDNSequence FROM $tblBargePara WHERE numUserID = ?',
            [bargeParaFromServer['userID']]);

        if (bargeParaFromDB.isNotEmpty ) {
          if (bargeParaFromDB[0]['numBargeBDNSequence'] < bargeParaFromServer['bargeBDNSequence']) {
            //UPDATE BARGE PARA LOCAL DB
            await txn.rawUpdate(
                'UPDATE $tblBargePara SET numBargeBDNSequence = ? WHERE numUserID = ?',
                [bargeParaFromServer['bargeBDNSequence'], bargeParaFromServer['userID']]);
          } else if (bargeParaFromDB[0]['numBargeBDNSequence'] > bargeParaFromServer['bargeBDNSequence']) {
            // UPDATE THE SERVER DB FROM LOCAL DB
            // TODO: set API call to update the barge para table in server
          }
        } else {
          //INSERT BARGE PARA TO LOCAL DB
          await txn.rawInsert(
              'INSERT INTO $tblBargePara(numBargeID, numUserID, varBargeCode, numBargeBDNSequence) VALUES (?,?,?,?)',
              [bargeParaFromServer['bargeID'], bargeParaFromServer['userID'], bargeParaFromServer['bargeCode'], bargeParaFromServer['bargeBDNSequence']]);
        }
        return bargeParaFromDB;
      });
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  // UPDATE: barge para by userID
  static void updateBargeParaByUserID(int userID) async {
    try {
      final db = await DatabaseHelper.db();

      await db.transaction((txn) async {
        List<Map<String, dynamic>> bargeParaFromDB = await txn.rawQuery(
            'SELECT numUserID, numBargeID, numBargeBDNSequence FROM $tblBargePara WHERE numUserID = ?',
            [userID],
        );

        if (bargeParaFromDB.isNotEmpty ) {
          await txn.rawUpdate(
              'UPDATE $tblBargePara SET numBargeBDNSequence = ? WHERE numUserID = ?',
              [
                int.parse(bargeParaFromDB[0]['bargeBDNSequence']) + 1,
                userID,
              ],
          );
        }

        print('====== BARGE WISE BDN SEQUENCE UPDATED ======');
      });
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }
}