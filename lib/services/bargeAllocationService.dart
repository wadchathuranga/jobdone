import 'dart:convert';

import 'package:http/http.dart' as http;

class JobApiService {
  static String BASE_URL =
      'https://logixbmsmob.advantis.world/BMSAppUATAPI/api';

  static String token = '';

  static Future<bool> saveJobToDB(reqBody) async {
    try {
      Uri url = Uri.parse('$BASE_URL/SaveCompletedJob');
      final response = await http.post(
        url,
        // headers: {
        //   "Content-Type": "application/json",
        // },
        // body: jsonEncode(reqBody),
        body: reqBody,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  static Future getAllJobsFromDB() async {
    try {
      Uri url = Uri.parse('$BASE_URL/GetAllCompletedJob');
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  // GET: get barge allocation list from server
  static Future getBargeAllocationListFromServer() async {
    try {
      token = await login(); //temporary set token

      print(token);

      Uri url = Uri.parse(
          '$BASE_URL/Home/getBargeAllocationCalenderDataOffline?userID=15');
      final response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print(response.reasonPhrase);
        return false;
      }
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }

  //Temporary
  static Future<String> login() async {
    try {
      Uri url = Uri.parse('https://logixbmsmob.advantis.world/BMSAppUATAuth/api/Auth/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "userName": "KUMANA",
          "password": "123456"
        }),
      );

        print(response.statusCode);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['result']['token'];
      } else {
        return "";
      }
    } catch (err) {
      print(err.toString());
      throw Exception(err.toString());
    }
  }
}
