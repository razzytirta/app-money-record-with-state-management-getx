import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:d_method/d_method.dart';

class AppRequest {
  static Future<Map<String, dynamic>?> gets(String url, {Map<String, String>? headers}) async {
    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      DMethod.printTitle('GET - $url', response.body);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        DMethod.printTitle('GET Error', 'Status Code: ${response.statusCode}');
        return null;
      }
    } catch(e) {
      DMethod.printTitle('GET Catch Error', e.toString());
      return null;
    }
  }

 static Future<Map?> post(String url, Object? body, {Map<String, String>? headers}) async {
  try {
    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers ?? {
        'Content-Type': 'application/x-www-form-urlencoded'},
    );
    
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> responseBody = jsonDecode(response.body);
      return responseBody;
    } else {
      print("Error: Server responded with status code ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error during POST request: $e");
    return null;
  }
}

}