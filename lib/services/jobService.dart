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
}
