import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'splashscreen.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');
    String? bloodType = prefs.getString('bloodType');
    String? allergies = prefs.getString('allergies');
    String? medication = prefs.getString('medication');
    String? organDonor = prefs.getString('organDonor');
    String? emergencyContactPerson = prefs.getString('emergencyContactPerson');
    String? emergencyContactPersonNumber = prefs.getString('emergencyContactPersonNumber');

    var bigTextStyleInformation = BigTextStyleInformation(
      'Address: ${address ?? 'N/A'}\n'
          'Blood Type: ${bloodType ?? 'N/A'}\n'
          'Allergies: ${allergies ?? 'N/A'}\n'
          'Medication: ${medication ?? 'N/A'}\n'
          'Organ Donor: ${organDonor ?? 'N/A'}\n\n'
          'In case of emergency, contact:\n'
          'Contact Name: ${emergencyContactPerson ?? 'N/A'}\n'
          'Number: ${emergencyContactPersonNumber ?? 'N/A'}\n',
      contentTitle: 'Emergency Information',
      summaryText: 'Emergency Info',
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'emergency_channel', // channel ID
      'Emergency Info', // channel name
      channelDescription: 'Displays emergency information', // channel description
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public, // Ensure visibility on lock screen
      styleInformation: bigTextStyleInformation,
      fullScreenIntent: true, // Show full screen notification
      ongoing: true, // Make the notification persistent
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Use a unique notification ID
      'Emergency Information',
      'Tap to view details', // Provide a brief message
      platformChannelSpecifics,
      payload: 'emergency_info', // Optional payload
    );

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    // Handle error if needed
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DUGTONG BUHAY PARA KAY JUAN',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );

  }
}