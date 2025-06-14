import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pw_registration.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/PwRegistration';

  static Future<PwRegistration?> fetchPwDetails(int rchid) async {
    final response = await http.get(Uri.parse('$baseUrl/$rchid'));

    if (response.statusCode == 200) {
      return PwRegistration.fromJson(json.decode(response.body));
    } else {
      print('Failed to load data: ${response.statusCode}');
      return null;
    }
  }
}
