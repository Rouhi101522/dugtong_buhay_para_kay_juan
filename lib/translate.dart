import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleTranslateService {
  static String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
  static const String baseUrl = 'https://translation.googleapis.com/language/translate/v2';

  static Future<String> translateText(String text, String targetLang) async {
    final response = await http.post(
      Uri.parse('$baseUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'target': targetLang,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Translation failed');
    }
  }
}
