import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/onboarding.dart';
import 'package:dugtong_buhay_para_kay_juan_v2/notif.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeEmergencyService(); // Initialize emergency service
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      print('Location permission granted');
      _navigateToOnboarding();
    } else if (status.isDenied) {
      print('Location permission denied');
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      print('Location permission permanently denied');
      openAppSettings();
    }
  }

  Future<void> _initializeEmergencyService() async {
    // Initialize the emergency service
    EmergencyService emergencyService = EmergencyService();
    emergencyService.createState().initState();
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text(
              'Location permission is required to proceed. Please allow it in the settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToOnboarding() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool dontShowOnboarding = !(prefs.getBool('showOnboarding') ?? true);

    if (dontShowOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_splashscreen.gif',
              width: 400,
              height: 400,
            ),
          ],
        ),
      ),
    );
  }
}