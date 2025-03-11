import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyService extends StatefulWidget {
  @override
  _EmergencyServiceState createState() => _EmergencyServiceState();
}

class _EmergencyServiceState extends State<EmergencyService> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    _loadEmergencyInfo();
  }

  Future<void> _loadEmergencyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');
    String? bloodType = prefs.getString('bloodType');
    String? allergies = prefs.getString('allergies');
    String? medication = prefs.getString('medication');
    String? organDonor = prefs.getString('organDonor');

    print('Loaded emergency info: $address, $bloodType, $allergies, $medication, $organDonor');
    _showNotification(address, bloodType, allergies, medication, organDonor);
  }

  Future<void> _showNotification(String? address, String? bloodType, String? allergies, String? medication, String? organDonor) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'emergency_channel', // channel ID
      'Emergency Info', // channel name
      channelDescription: 'Displays emergency information', // channel description
      importance: Importance.max,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      ongoing: true,
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Emergency Information',
      'Address: $address\nBlood Type: $bloodType\nAllergies: $allergies\nMedication: $medication\nOrgan Donor: $organDonor',
      platformChannelSpecifics,
    );
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    // Handle notification tap
    print('Notification tapped with payload: ${notificationResponse.payload}');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}