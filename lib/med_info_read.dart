import 'package:dugtong_buhay_para_kay_juan_v2/home.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  String scannedData = '';
  bool cameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        cameraPermissionGranted = true;
      });
    } else if (status.isDenied) {
      _showPermissionDialog();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('Camera permission is required to proceed. Please allow it in the settings.'),
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

  Future<void> _saveScannedData(String data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dataList = data.split('\n');
    for (String item in dataList) {
      List<String> keyValue = item.split(': ');
      if (keyValue.length == 2) {
        await prefs.setString(keyValue[0], keyValue[1]);
      }
    }
  }

  void _showScannedDataDialog(String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanned Data'),
          content: Text(data),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                ).then((_) {
                  // Open the drawer after navigating to the HomePage
                  Future.delayed(Duration(milliseconds: 500), () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Drawer opened'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Scaffold.of(context).openDrawer();
                  });
                });
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraPermissionGranted
          ? Stack(
        children: [
          MobileScanner(
            onDetect: (barcodeCapture) async {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              if (barcodes.isNotEmpty) {
                String data = barcodes.first.rawValue ?? 'No data';
                setState(() {
                  scannedData = data;
                });
                await _saveScannedData(data);
                _showScannedDataDialog(data);
              } else {
                setState(() {
                  scannedData = 'No data';
                });
              }
            },
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      )
          : Center(
        child: Text('Camera permission is required to scan QR codes'),
      ),
    );
  }
}