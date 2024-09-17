import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _url = 'https://random.dog/woof.json';

  static Future<String> fetchRandomDog() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      } else {
        throw Exception('Failed to load dog image');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
