import 'package:flutter/material.dart';
import 'med_info_read.dart';
import 'med_info_generate.dart';

void main() {
  runApp(MaterialApp(
    home: MainQR(),
  ));
}

class MainQR extends StatefulWidget {
  @override
  _MainQRScreenState createState() => _MainQRScreenState();
}

class _MainQRScreenState extends State<MainQR> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    QRScannerScreen(),
    QRGeneratorScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code App'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'My QR Code',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}