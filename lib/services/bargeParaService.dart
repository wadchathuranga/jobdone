import 'dart:convert';
import 'package:http/http.dart' as http;

class BargeParaAPIService {
  static String BASE_URL =
      'https://logixbmsmob.advantis.world/BMSAppUATAPI/api';

  static String token = '';

  // GET: get barge para data from server
  static Future getBargeParaDataFromServer() async {
    try {
      token = await login(); //temporary set token

      Uri url = Uri.parse('$BASE_URL/BDN/GetBargePara?userID=15');
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