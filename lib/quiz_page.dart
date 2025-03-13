import 'package:flutter/material.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/gemini_service.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FetchQuizQuestion fetchQuiz = FetchQuizQuestion();
  int score = 0;
  int questionIndex = 0;
  final int totalQuestions = 20;
  String difficulty = "MEDIUM"; // Default difficulty
  String quizType = "CPR"; // Default quiz type
  Future<Map<String, dynamic>>? quizQuestionFuture;
  String? selectedAnswer;
  String? explanation; // Store explanation after answer selection

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  Future<void> loadQuestion() async {
    setState(() {
      selectedAnswer = null;
      explanation = null; // Reset explanation for new question
      quizQuestionFuture = fetchQuiz.generateQuestion(difficulty, quizType);
    });
  }

  void checkAnswer(String answer) async {
    String correctAnswer = (await quizQuestionFuture)?["correct_answer"] ?? "";
    String selectedOption = (await quizQuestionFuture)?["choices"].entries.firstWhere((entry) => entry.value == answer).key;

    bool isCorrect = selectedOption.trim().toLowerCase() == correctAnswer.trim().toLowerCase();

    print("Selected Answer: $answer");
    print("Selected Option: $selectedOption");
    print("Correct Answer: $correctAnswer");
    print("Is Correct: $isCorrect");

    setState(() {
      selectedAnswer = answer;
      if (isCorrect) score++;
    });

    // Show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "Correct!" : "Incorrect!"),
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );

    // Fetch explanation from AI
    Map<String, dynamic> response = await fetchQuiz.checkAnswer(selectedOption, correctAnswer);
    setState(() {
      explanation = response["explanation"]; // Show explanation
    });

    // Wait before moving to the next question
    Future.delayed(Duration(seconds: 4), () {
      if (questionIndex < totalQuestions - 1) {
        setState(() {
          questionIndex++;
        });
        loadQuestion();
      } else {
        showFinalResults();
      }
    });
  }

  Future<void> showFinalResults() async {
    Map<String, dynamic> assessment = await fetchQuiz.generateFinalAssessment(score, totalQuestions);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Quiz Complete"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Score: $score/$totalQuestions"),
                SizedBox(height: 10),
                Text(assessment["assessment"]),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the quiz? Your progress will be lost.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  Future<void> _showChangeConfirmationDialog(VoidCallback onConfirmed) async {
    bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Changing the difficulty or topic will reset your progress. Do you want to proceed?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      onConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("BLS Knowledge Quiz"),
          actions: [
            // Difficulty selection dropdown
            DropdownButton<String>(
              value: difficulty,
              items: ["EASY", "MEDIUM", "HARD"].map((level) {
                return DropdownMenuItem(value: level, child: Text(level));
              }).toList(),
              onChanged: (value) {
                _showChangeConfirmationDialog(() {
                  setState(() {
                    difficulty = value ?? "MEDIUM";
                    questionIndex = 0;
                    score = 0;
                  });
                  loadQuestion();
                });
              },
            ),
            SizedBox(width: 10),
            // Quiz Type selection dropdown
            DropdownButton<String>(
              value: quizType,
              items: ["CPR", "FBAO"].map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                _showChangeConfirmationDialog(() {
                  setState(() {
                    quizType = value ?? "CPR";
                    questionIndex = 0;
                    score = 0;
                  });
                  loadQuestion();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: quizQuestionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Failed to load quiz"));
            } else if (snapshot.hasData) {
              var quizQuestion = snapshot.data!;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Question ${questionIndex + 1} of $totalQuestions"),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              quizQuestion["question"],
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ...quizQuestion["choices"].entries.map<Widget>((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ElevatedButton(
                                  onPressed: selectedAnswer == null ? () => checkAnswer(entry.value) : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedAnswer == null
                                        ? Colors.blue
                                        : (entry.value == quizQuestion["correct_answer"]
                                        ? Colors.green
                                        : (entry.value == selectedAnswer ? Colors.red : Colors.blue)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(fontSize: 18, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          if (selectedAnswer != null && explanation != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                explanation!,
                                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text("Failed to load quiz"));
            }
          },
        ),
      ),
    );
  }
}

