import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DUGTONG BUHAY PARA KAY JUAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreenWrapper(),
    );
  }
}

class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate splash screen delay
    final prefs = await SharedPreferences.getInstance();
    final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => showOnboarding ? OnboardingScreen() : SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;

  Future<void> _setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showOnboarding', false);
  }

  final List<Map<String, String>> onboardingData = [
    {"text": "Welcome to Dugtong Buhay Para Kay Juan!", "image": "assets/placeholder1.svg"},
    {"text": "Learn Basic Life Support techniques.", "image": "assets/placeholder2.svg"},
    {"text": "Stay prepared and help save lives.", "image": "assets/placeholder3.svg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          onboardingData[index]["image"]!,
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            onboardingData[index]["text"]!,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex != onboardingData.length - 1)
                  TextButton(
                    onPressed: () {
                      _setOnboardingSeen();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    },
                    child: const Text("Do not show again"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == onboardingData.length - 1) {
                      _setOnboardingSeen();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SplashScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_currentIndex == onboardingData.length - 1 ? "I Understand" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





//vvv OLD MAIN.DART FILE vvv



// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter/material.dart';
// import 'splashscreen.dart';
//
// void main() async{
//   await dotenv.load();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
//     print('API Key: $apiKey');
//
//     return MaterialApp(
//       title: 'DUGTONG BUHAY PARA KAY JUAN',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SplashScreen(),
//     );
//   }
// }
//
