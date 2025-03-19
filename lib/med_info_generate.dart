import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRGeneratorScreen extends StatefulWidget {
  @override
  _QRGeneratorScreenState createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  String qrData = '';
  bool hasMedicalInfo = false;

  @override
  void initState() {
    super.initState();
    _generateQRData();
  }

  Future<void> _generateQRData() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? address = prefs.getString('address');
    String? bloodType = prefs.getString('bloodType');
    String? allergies = prefs.getString('allergies');
    String? medication = prefs.getString('medication');
    String? organDonor = prefs.getString('organDonor');
    String? emergencyContactPerson = prefs.getString('emergencyContactPerson');
    String? emergencyContactPersonNumber = prefs.getString('emergencyContactPersonNumber');

    if (email != null && address != null && bloodType != null && allergies != null && medication != null && organDonor != null && emergencyContactPerson != null && emergencyContactPersonNumber != null) {
      setState(() {
        hasMedicalInfo = true;
        qrData = 'Email: $email\n, Address: $address\nBlood Type: $bloodType\nAllergies: $allergies\nMedication: $medication\nOrgan Donor: $organDonor\nEmergency Contact: $emergencyContactPerson\nEmergency Contact Number: $emergencyContactPersonNumber';
      });
    } else {
      setState(() {
        hasMedicalInfo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: hasMedicalInfo
            ? QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        )
            : Text('Please provide all medical information to generate a QR code.'),
      ),
    );
  }
}