import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstAidKitPage extends StatefulWidget {
  @override
  _FirstAidKitPageState createState() => _FirstAidKitPageState();
}

class _FirstAidKitPageState extends State<FirstAidKitPage> {
  final Map<String, List<Map<String, dynamic>>> categorizedItems = {
    'Bandages & Dressings': [
      {'name': 'Triangular Bandage', 'image': 'assets/triangular_bandage.png', 'quantity': 0, 'suggested': 2, 'description': 'Used for immobilizing limbs or as a sling.'},
      {'name': 'Wound Dressing', 'image': 'assets/wound_dressing.png', 'quantity': 0, 'suggested': 3, 'description': 'Used to cover and protect wounds from infection.'},
      {'name': 'Conforming Bandage', 'image': 'assets/conforming_bandage.png', 'quantity': 0, 'suggested': 2, 'description': 'Used to secure dressings and provide light support.'},
      {'name': 'Reusable Bandage', 'image': 'assets/reusable_bandage.png', 'quantity': 0, 'suggested': 2, 'description': 'Provides compression and support for injuries.'},
    ],
    'Medications & Disinfectants': [
      {'name': 'Alcohol', 'image': 'assets/alcohol.png', 'quantity': 0, 'suggested': 1, 'description': 'Used to disinfect wounds and clean hands.'},
      {'name': 'Providone Iodine', 'image': 'assets/providone_iodine.png', 'quantity': 0, 'suggested': 1, 'description': 'An antiseptic solution for treating wounds.'},
      {'name': 'Oral Solution', 'image': 'assets/oral_solution.png', 'quantity': 0, 'suggested': 2, 'description': 'Rehydrates the body in cases of dehydration.'},
    ],
    'Tools & Accessories': [
      {'name': 'Scissors', 'image': 'assets/scissors.png', 'quantity': 0, 'suggested': 1, 'description': 'Used to cut bandages, dressings, and clothing.'},
      {'name': 'Tweezers', 'image': 'assets/tweezers.png', 'quantity': 0, 'suggested': 1, 'description': 'Used for removing splinters or debris from wounds.'},
      {'name': 'Multi-purpose Knife', 'image': 'assets/multi_purpose_knife.png', 'quantity': 0, 'suggested': 1, 'description': 'A versatile tool for various first aid needs.'},
      {'name': 'Micropore Tape', 'image': 'assets/micropore_tape.png', 'quantity': 0, 'suggested': 2, 'description': 'Used to secure dressings and bandages in place.'},
      {'name': 'Safety Pin', 'image': 'assets/safety_pin.png', 'quantity': 0, 'suggested': 5, 'description': 'Used to secure bandages or clothing in emergencies.'},
    ],
    'Emergency Items': [
      {'name': 'Flashlight', 'image': 'assets/flashlight.png', 'quantity': 0, 'suggested': 1, 'description': 'Provides visibility in low-light situations.'},
      {'name': 'Battery', 'image': 'assets/battery.png', 'quantity': 0, 'suggested': 4, 'description': 'Powers flashlights and other emergency devices.'},
      {'name': 'Glow Sticks', 'image': 'assets/glowstick.png', 'quantity': 0, 'suggested': 3, 'description': 'Provides emergency lighting in dark conditions.'},
      {'name': 'Whistle', 'image': 'assets/whistle.png', 'quantity': 0, 'suggested': 1, 'description': 'Used for signaling in emergency situations.'},
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final prefs = await SharedPreferences.getInstance();
    categorizedItems.forEach((category, items) {
      for (var item in items) {
        item['quantity'] = prefs.getInt(item['name']) ?? 0;
      }
    });
    setState(() {});
  }

  Future<void> _updateQuantity(String itemName, int newQuantity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(itemName, newQuantity);
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
                "\n\nUses of Items:\n- Bandages & Dressings: Cover and protect wounds.\n- Medications & Disinfectants: Treat infections and disinfect wounds.\n- Tools & Accessories: Assist in first aid procedures.\n- Emergency Items: Provide safety and visibility."
        ),
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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: categorizedItems.entries.map((entry) {
          return ExpansionTile(
            title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
            children: entry.value.map((item) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: Image.asset(
                    item['image'],
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 40, color: Colors.grey);
                    },
                  ),
                  title: Text(item['name']),
                  subtitle: Text("${item['quantity']} out of ${item['suggested']}"),
                  onTap: () => _showItemDescription(item['name'], item['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (item['quantity'] > 0) {
                              item['quantity']--;
                              _updateQuantity(item['name'], item['quantity']);
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            item['quantity']++;
                            _updateQuantity(item['name'], item['quantity']);
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
    );
  }
}