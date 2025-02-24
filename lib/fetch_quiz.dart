import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final String gemAPI = dotenv.env['GEMINI_API_KEY'] ?? 'default_value';
final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$gemAPI";

Future<Map<String, dynamic>> fetchQuizQuestion() async {
  final prompt = "**Question:** <question_text>\n\n"
      "**Options:**\n"
      "A) <option_1>\n"
      "B) <option_2>\n"
      "C) <option_3>\n"
      "D) <option_4>\n\n"
      "**Answer:** <correct_option>";

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("API Response: $data"); // Debugging output

    if (data["candidates"] != null && data["candidates"].isNotEmpty) {
      String generatedText = data["candidates"][0]["content"]["parts"][0]["text"];
      print("Generated Quiz Text: $generatedText"); // Debugging output

      // ✅ Updated regex to match Markdown format
      final regex = RegExp(
        r"\*\*Question:\*\* (.*?)\n\n\*\*Options:\*\*\nA\) (.*?)\nB\) (.*?)\nC\) (.*?)\nD\) (.*?)\n\n\*\*Answer:\*\* (A|B|C|D)",
        dotAll: true,
      );
      final match = regex.firstMatch(generatedText);

      if (match != null) {
        return {
          "question": match.group(1),
          "options": {
            "A": match.group(2),
            "B": match.group(3),
            "C": match.group(4),
            "D": match.group(5),
          },
          "answer": match.group(6),
        };

      } else {
        return {"error": "Failed to extract quiz data"};
      }
    }
  }

  return {"error": "Failed to generate quiz question"};
}
