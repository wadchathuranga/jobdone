import 'package:http/http.dart' as http;

class LocationAndBerthedTypeApiService {
  static String BASE_URL =
      'https://logixbmsmob.advantis.world/BMSAppUATAPI/api';

  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ikt1bWFuYSIsInVzZXJJZCI6IjkiLCJhZ2VuY3lJRCI6IjEiLCJjb21wYW55SUQiOiIxIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNzMwMzUzNjkzLCJleHAiOjE3MzA0NDAwOTMsImlhdCI6MTczMDM1MzY5M30._5rkxiYbTktAVeOkiNYXZnxREsXQeeXT34cak6vy6KE';

  static Future getPortLocationCodeListFromServer() async {
    try {
      Uri url = Uri.parse('$BASE_URL/BDN/GetLocations?bitActive=true');
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer $token'
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

  static Future getBerthedTypeListFromServer() async {
    try {
      Uri url = Uri.parse('$BASE_URL/BDN/GetBerthTypes?bitActive=true');
      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer $token'
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
