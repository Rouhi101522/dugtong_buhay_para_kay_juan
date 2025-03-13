import 'package:dugtong_buhay_para_kay_juan_v2/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _showCheckbox = false;
  bool _dontShowAgain = false;
  Timer? _timer;
  int _timerSeconds = 10;

  Future<void> _setOnboardingSeen(bool dontShowAgain) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', !dontShowAgain);
  }

  final List<Map<String, String>> onboardingData = [
    {"image": "assets/Onboarding1.png"},
    {"image": "assets/Onboarding2.png"},
    {"image": "assets/Onboarding3.png"},
    {"image": "assets/Onboarding4.png"},
    {"image": "assets/Onboarding5.png"},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _timer?.cancel();
          _showCheckbox = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50%screenSize.height),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index == onboardingData.length - 1) {
                    _timerSeconds = 10;
                    startTimer();
                  } else {
                    _timer?.cancel();
                    _showCheckbox = false;
                  }
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  width: screenSize.width,
                  height: screenSize.height,
                  child: Image.asset(
                    onboardingData[index]["image"]!,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(onboardingData.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentIndex == index ? 12.0 : 8.0,
                height: _currentIndex == index ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex == onboardingData.length - 1)
                  Row(
                    children: [
                      Checkbox(
                        value: _dontShowAgain,
                        onChanged: (value) {
                          setState(() {
                            _dontShowAgain = value!;
                          });
                        },
                      ),
                      const Text("Do not show again"),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == onboardingData.length - 1) {
                      if (_timerSeconds == 0) {
                        _setOnboardingSeen(_dontShowAgain);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      }
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentIndex == onboardingData.length - 1
                      ? _timerSeconds == 0
                      ? "I Understand"
                      : "I Understand ($_timerSeconds)"
                      : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}