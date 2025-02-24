import 'package:flutter/material.dart';
import 'fetch_quiz.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  Map<String, dynamic>? quizQuestion;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizQuestion();
  }

  Future<void> _loadQuizQuestion() async {
    final questionData = await fetchQuizQuestion();
    setState(() {
      quizQuestion = questionData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI-Powered Quiz")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : quizQuestion != null && quizQuestion!["error"] == null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              quizQuestion!["question"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ...quizQuestion!["options"].entries.map((entry) {
            return ElevatedButton(
              onPressed: () {
                String selected = entry.key;
                String correct = quizQuestion!["answer"];
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(selected == correct ? "Correct!" : "Wrong!"),
                      content: Text(
                          "The correct answer is: $correct) ${quizQuestion!["options"][correct]}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _loadQuizQuestion(); // Load a new question
                          },
                          child: Text("Next Question"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("${entry.key}) ${entry.value}"),
            );
          }).toList(),
        ],
      )
          : Center(child: Text("Failed to load quiz")),
    );
  }


  void main() {
    runApp(MaterialApp(
      home: QuizScreen(),
    ));
  }
}