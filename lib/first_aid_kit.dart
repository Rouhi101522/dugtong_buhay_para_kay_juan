import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirstAidKitPage extends StatefulWidget {
  @override
  _FirstAidKitPageState createState() => _FirstAidKitPageState();
}

class _FirstAidKitPageState extends State<FirstAidKitPage> {
  final Map<String, List<Map<String, dynamic>>> categorizedItems = {
    'Bandages & Dressings': [
      {
        'name': 'Triangular Bandage',
        'image': 'assets/triangular_bandage.png',
        'quantity': 0,
        'suggested': 2,
        'description': 'Used for immobilizing limbs or as a sling.'
      },
      {
        'name': 'Wound Dressing',
        'image': 'assets/wound_dressing.png',
        'quantity': 0,
        'suggested': 3,
        'description': 'Used to cover and protect wounds from infection.'
      },
      {
        'name': 'Conforming Bandage',
        'image': 'assets/conforming_bandage.png',
        'quantity': 0,
        'suggested': 2,
        'description': 'Used to secure dressings and provide light support.'
      },
      {
        'name': 'Reusable Bandage',
        'image': 'assets/reusable_bandage.png',
        'quantity': 0,
        'suggested': 2,
        'description': 'Provides compression and support for injuries.'
      },
    ],
    'Medications & Disinfectants': [
      {
        'name': 'Alcohol',
        'image': 'assets/alcohol.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'Used to disinfect wounds and clean hands.'
      },
      {
        'name': 'Providone Iodine',
        'image': 'assets/providone_iodine.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'An antiseptic solution for treating wounds.'
      },
      {
        'name': 'Oral Solution',
        'image': 'assets/oral_solution.png',
        'quantity': 0,
        'suggested': 2,
        'description': 'Rehydrates the body in cases of dehydration.'
      },
    ],
    'Tools & Accessories': [
      {
        'name': 'Scissors',
        'image': 'assets/scissors.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'Used to cut bandages, dressings, and clothing.'
      },
      {
        'name': 'Tweezers',
        'image': 'assets/tweezers.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'Used for removing splinters or debris from wounds.'
      },
      {
        'name': 'Multi-purpose Knife',
        'image': 'assets/multi_purpose_knife.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'A versatile tool for various first aid needs.'
      },
      {
        'name': 'Micropore Tape',
        'image': 'assets/micropore_tape.png',
        'quantity': 0,
        'suggested': 2,
        'description': 'Used to secure dressings and bandages in place.'
      },
      {
        'name': 'Safety Pin',
        'image': 'assets/safety_pin.png',
        'quantity': 0,
        'suggested': 5,
        'description': 'Used to secure bandages or clothing in emergencies.'
      },
    ],
    'Emergency Items': [
      {
        'name': 'Flashlight',
        'image': 'assets/flashlight.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'Provides visibility in low-light situations.'
      },
      {
        'name': 'Battery',
        'image': 'assets/battery.png',
        'quantity': 0,
        'suggested': 4,
        'description': 'Powers flashlights and other emergency devices.'
      },
      {
        'name': 'Glow Sticks',
        'image': 'assets/glowstick.png',
        'quantity': 0,
        'suggested': 3,
        'description': 'Provides emergency lighting in dark conditions.'
      },
      {
        'name': 'Whistle',
        'image': 'assets/whistle.png',
        'quantity': 0,
        'suggested': 1,
        'description': 'Used for signaling in emergency situations.'
      },
    ],
  };

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  bool _isLowStock = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadInventory();
  }

  Future<void> _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    categorizedItems.forEach((category, items) {
      for (var item in items) {
        item['quantity'] = prefs.getInt(item['name']) ?? 0;
      }
    });
    _checkLowStock();
    setState(() {});
  }

  Future<void> _updateQuantity(String itemName, int newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(itemName, newQuantity);
    _checkLowStock();
  }

  void _checkLowStock() async {
    List<String> lowStockItems = [];
    categorizedItems.values.forEach((items) {
      items.forEach((item) {
        if (item['quantity'] < item['suggested']) {
          lowStockItems.add(item['name']);
        }
      });
    });
    _isLowStock = lowStockItems.isNotEmpty;
    if (_isLowStock) {
      final prefs = await SharedPreferences.getInstance();
      final lastNotificationTime = prefs.getInt('lastNotificationTime') ?? 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      const notificationInterval =
          6 * 60 * 60 * 1000; // 6 hours in milliseconds

      if (currentTime - lastNotificationTime > notificationInterval) {
        _showLowStockNotification(lowStockItems);
        await prefs.setInt('lastNotificationTime', currentTime);
      }
    }
  }

  Future<void> _showLowStockNotification(List<String> lowStockItems) async {
    final BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
      'The following items are low on stock: ${lowStockItems.join(', ')}',
      contentTitle: 'Low Stock Alert',
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'low_stock_channel',
      'Low Stock Notifications',
      channelDescription:
          'Notifications for low stock items in the first aid kit',
      styleInformation: bigTextStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Low Stock Alert',
      'The following items are low on stock: ${lowStockItems.join(', ')}',
      platformChannelSpecifics,
    );
  }

  void _showItemDescription(String name, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(name),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("First Aid Kit Information"),
        content: Text(
            "What is a First Aid Kit?\nA first aid kit is a collection of supplies and equipment used to give medical treatment."
            "\n\nImportance:\nA well-stocked first aid kit can help treat minor injuries and manage emergencies until professional medical help arrives."
            "\n\nUses of Items:\n- Bandages & Dressings: Cover and protect wounds.\n- Medications & Disinfectants: Treat infections and disinfect wounds.\n- Tools & Accessories: Assist in first aid procedures.\n- Emergency Items: Provide safety and visibility."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Aid Kit Checklist"),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isLowStock)
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Some items are low on stock!",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: categorizedItems.entries.map((entry) {
                return ExpansionTile(
                  title: Text(entry.key,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  children: entry.value.map((item) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Image.asset(
                          item['image'],
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image,
                                size: 40, color: Colors.grey);
                          },
                        ),
                        title: Text(item['name']),
                        subtitle: Text(
                            "${item['quantity']} out of ${item['suggested']}"),
                        onTap: () => _showItemDescription(
                            item['name'], item['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (item['quantity'] > 0) {
                                    item['quantity']--;
                                    _updateQuantity(
                                        item['name'], item['quantity']);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  item['quantity']++;
                                  _updateQuantity(
                                      item['name'], item['quantity']);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
