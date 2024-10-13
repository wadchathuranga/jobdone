import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class JobApiService {
  static String BASE_URL =
      'http://192.168.8.165:4444/v1/test_project'; //http://localhost:4444/v1

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

  static Future getBargeAllocationListFromServer() async {
    try {
      Uri url = Uri.parse(
          'https://logixbmsmob.advantis.world/BMSAppUATAPI/api/Home/getBargeAllocationCalenderDataOffline?userID=15');
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ikt1bWFuYSIsInVzZXJJZCI6IjkiLCJhZ2VuY3lJRCI6IjEiLCJjb21wYW55SUQiOiIxIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNzI4NzU3NzI4LCJleHAiOjE3Mjg4NDQxMjgsImlhdCI6MTcyODc1NzcyOH0.43Fj_gnMcMl1-ADX9crN-IfbF8LAdTRcE0Ni-VVaSmI'
      });

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

  static Future getBargeParaData() async {
    try {
      Uri url = Uri.parse(
          'https://logixbmsmob.advantis.world/BMSAppUATAPI/api/BDN/GetBargePara?userID=15');
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ikt1bWFuYSIsInVzZXJJZCI6IjkiLCJhZ2VuY3lJRCI6IjEiLCJjb21wYW55SUQiOiIxIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNzI4NzU3NzI4LCJleHAiOjE3Mjg4NDQxMjgsImlhdCI6MTcyODc1NzcyOH0.43Fj_gnMcMl1-ADX9crN-IfbF8LAdTRcE0Ni-VVaSmI'
      });

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
}
