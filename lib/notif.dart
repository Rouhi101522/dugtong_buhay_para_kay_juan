import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyService extends StatefulWidget {
  @override
  _EmergencyServiceState createState() => _EmergencyServiceState();
}

class _EmergencyServiceState extends State<EmergencyService> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int notificationId = 0;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
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
    var bigTextStyleInformation = BigTextStyleInformation(
      'Address: ${address ?? 'N/A'}\n'
          'Blood Type: ${bloodType ?? 'N/A'}\n'
          'Allergies: ${allergies ?? 'N/A'}\n'
          'Medication: ${medication ?? 'N/A'}\n'
          'Organ Donor: ${organDonor ?? 'N/A'}',
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
    );

    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    print('Showing notification...');
    await flutterLocalNotificationsPlugin.show(
      notificationId++, // Use a unique notification ID
      'Emergency Information',
      null, // Title is already set in BigTextStyleInformation
      platformChannelSpecifics,
    );
    print('Notification should be shown.');
  }

  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    // Handle notification tap
    print('Notification tapped with payload: ${notificationResponse.payload}');
    _showNotificationAgain(); // Re-show the notification
  }

  Future<void> _showNotificationAgain() async {
    final prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');
    String? bloodType = prefs.getString('bloodType');
    String? allergies = prefs.getString('allergies');
    String? medication = prefs.getString('medication');
    String? organDonor = prefs.getString('organDonor');

    _showNotification(address, bloodType, allergies, medication, organDonor);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
