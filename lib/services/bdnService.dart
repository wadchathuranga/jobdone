import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/ApiResponse.dart';

class BDNInfoAPIService {
  static String baseURL =
      'https://logixbmsmob.advantis.world/BMSAppUATAPI/api';

  static String token = '';

  // POST: BDN Info data to the server
  static Future<ApiResponse> uploadBDNInfoToServer(Map<String,dynamic> bdnInfo) async {
    try {
      token = await login(); //temporary set token

      bdnInfo['date'] = DateTime.now().toIso8601String();
      bdnInfo['berthedLocation'] = null;

      print(bdnInfo);

      Uri url = Uri.parse('$baseURL/BDN/saveBDN');
      final response =
      await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
          },
          body: jsonEncode(bdnInfo),
      );

      print("=== api-res-body ===${response.body}");
      ApiResponse result = ApiResponse.fromJson(jsonDecode(response.body));
      if (response.statusCode == 200) {
        return result;
      } else {
        print("ERROR: ${response.reasonPhrase}");
        return result;
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