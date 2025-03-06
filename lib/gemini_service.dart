import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FetchQuizQuestion {
  final String gemAPI = dotenv.env['GEMINI_API_KEY'] ?? 'default_value';
  final String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";
  Set<String> askedQuestions = {};


  Future<Map<String, dynamic>> checkAnswer(String userAnswer, String correctAnswer) async {
    // Logic to compare answers and return an explanation
    bool isCorrect = userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
    String explanation = isCorrect
        ? "Correct! $correctAnswer is the right answer."
        : "Incorrect. The correct answer is $correctAnswer.";
    return {"isCorrect": isCorrect, "explanation": explanation};
  }



  /// Generates a multiple-choice quiz question using the Gemini API
  Future<Map<String, dynamic>> generateQuestion(

      String difficulty, String topic) async {
    final url = Uri.parse("$apiUrl?key=$gemAPI");
    print("Generating question with difficulty: $difficulty, topic: $topic");

    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "Create a $difficulty difficulty multiple-choice question on $topic as primary topic related to Basic Life Support (BLS)."
                  "The secondary topic will be the BLS Sequence, AED use, and other BLS topic for LAY RESCUER"
                  "Provide exactly four answer choices labeled A., B., C., and D., each on a new line."
                  "Clearly indicate the correct answer using 'Correct Answer: <option letter>'. "
                  "Ensure that the question is unique and covers a different aspect of the topic."
                  "Do not include any introductory text, only the question and answer choices."
                  "Scope of CPR Quizzes: Infant, Child, and Adult."
                  "Scope of FBAO Quizzes: Infant, Child, and Adult."
                  "Limitations of the quiz: For Layman rescuer."
            }
          ]
        }
      ]
    });

    print("Request Body: $requestBody");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
          String fullResponse = data["candidates"][0]["content"]["parts"][0]["text"];
          print("Full Response: $fullResponse");

          List<String> parts = fullResponse.split("\n").where((e) => e.trim().isNotEmpty).toList();

          if (parts.length >= 6) {
            String questionText = parts[0].trim();
            if (askedQuestions.contains(questionText)) {
              // If the question is already asked, generate a new one
              return await generateQuestion(difficulty, topic);
            }

            askedQuestions.add(questionText);

            Map<String, String> choices = {
              "A": parts[1].substring(3).trim(),
              "B": parts[2].substring(3).trim(),
              "C": parts[3].substring(3).trim(),
              "D": parts[4].substring(3).trim(),
            };

            String correctAnswer = extractCorrectAnswerFromOptions(parts);

            return {
              "difficulty": difficulty,
              "category": topic,
              "question": questionText,
              "choices": choices,
              "correct_answer": correctAnswer,
              "reason": "Explanation of why the correct answer is correct."
            };
          } else {
            print("Unexpected API response format.");
            throw Exception("Unexpected API response format.");
          }
        } else {
          print("No valid response from AI.");
          throw Exception("No valid response from AI.");
        }
      } else {
        print("Failed to generate question: ${response.body}");
        throw Exception("Failed to generate question: ${response.body}");
      }
    } catch (e) {
      print("Error fetching question: $e");
      throw Exception("Error fetching question. Please try again.");
    }
  }

  /// Extracts the correct answer from AI-generated options
  String extractCorrectAnswerFromOptions(List<String> options) {
    for (String option in options) {
      if (option.startsWith("Correct Answer:")) {
        return option.split(":")[1].trim();
      }
    }
    return "Unknown"; // Default if AI response fails
  }

  /// Generates AI-based feedback after the quiz
  Future<Map<String, dynamic>> generateFinalAssessment(
      int score, int totalQuestions) async {
    final url = Uri.parse("$apiUrl?key=$gemAPI");
    print(
        "Generating final assessment: Score: $score, Total Questions: $totalQuestions");

    final requestBody = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": "The user scored $score out of $totalQuestions in a Basic Life Support (BLS) quiz. "
                  "Provide an AI-generated competence assessment, highlighting strengths, weaknesses, and specific topics to review."
            }
          ]
        }
      ]
    });

    print("Request Body: $requestBody");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "assessment": data["candidates"][0]["content"]["parts"][0]["text"]
        };
      } else {
        print("Failed to generate assessment: ${response.body}");
        throw Exception("Failed to generate assessment.");
      }
    } catch (e) {
      print("Error generating assessment: $e");
      return {"error": "Unable to generate assessment."};
    }
  }
}

