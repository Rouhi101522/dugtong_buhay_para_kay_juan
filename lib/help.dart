import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // Import for clipboard functionality
import 'package:share_plus/share_plus.dart'; // Import for sharing content

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();

}

class _HelpPageState extends State<HelpPage> {
  String? address;
  String? plusCode;
  double? latitude;
  double? longitude;
  String time = '';
  String date = '';
  double sliderValue = 0;

    final String apiKey = 'AIzaSyDak-C4yCq4C10hlQJS239WIbcQzEQK67w';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getLocationAndAddress();
    });
  }

  Future<void> _getLocationAndAddress() async {
    setState(() {
      time = DateFormat.jm().format(DateTime.now());
      date = DateFormat.yMMMd().format(DateTime.now());
    });

    var locationPermission = await Permission.location.request();
    if (!locationPermission.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
      }
      return;
    }

    try {
      LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      // Check if there's an internet connection before attempting geocoding
      bool isConnected = await _isConnectedToInternet();

      if (isConnected) {
        // Fetch address only if there's an internet connection
        final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey',
        );

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          if (data['results'].isNotEmpty) {
            address = data['results'][0]['formatted_address'];
            plusCode = data['plus_code']?['global_code'];
            setState(() {});
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No address found for this location.')),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to fetch data: ${response.reasonPhrase}')),
            );
          }
        }
      } else {
        // Offline: Only show the coordinates
        address = 'No internet connection, unable to fetch address.';
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching location: $e')),
        );
      }
    }
  }

// Function to check internet connection
  Future<bool> _isConnectedToInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }



  Future<void> _makeEmergencyCall(BuildContext context) async {
    final Uri emergencyUrl = Uri(scheme: 'tel', path: '911');
    try {
      await launchUrl(emergencyUrl, mode: LaunchMode.externalApplication);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening dialer to call 911...')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the dialer: $e')),
      );
    }
  }

  Future<void> _copyToClipboard() async {
    final info = '''
This is an emergency situation. Here are my current information.

Date: $date
Time: $time
Address: $address
Latitude: $latitude
Longitude: $longitude
Plus Code: ${plusCode ?? "Unavailable"}

Instruction to use latitude and longitude coordinates: 
If Address is not available, LATITUDE and LONGITUDE must be pasted on Google Maps to see my exact location and must be separated with a comma.
"(x.xxxx , y.yyyy)"

Instruction to use Plus Code:
Copy the plus code on the information if available and paste it on Google Maps search bar to see my exact location.
''';
    await Clipboard.setData(ClipboardData(text: info));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Information copied to clipboard')),
    );
  }

  Future<void> _shareInfo() async {
    final info = '''
This is an emergency situation. Here are my current information.

Date: $date
Time: $time
Address: $address
Latitude: $latitude
Longitude: $longitude
Plus Code: ${plusCode ?? "Unavailable"}

Instruction to use latitude and longitude coordinates: 
If Address is not available, LATITUDE and LONGITUDE must be pasted on Google Maps search bar to see my exact location and must be separated with a comma.
"(x.xxxx , y.yyyy)"

Instruction to use Plus Code:
Copy the plus code on the information if available and paste it on Google Maps search bar to see my exact location.
''';
    await Share.share(info, subject: 'Emergency Information');
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Page'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage, // Call the refresh function
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Emergency Information',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (address != null && latitude != null && longitude != null)
                      Column(
                        children: [
                          _buildInfoCard('Date', date),
                          _buildInfoCard('Time', time),
                          _buildInfoCard('Address', address!),
                          _buildInfoCard('Latitude', latitude.toString()),
                          _buildInfoCard('Longitude', longitude.toString()),
                          _buildInfoCard('Plus Code', plusCode ?? 'Unavailable'),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _copyToClipboard,
                                icon: const Icon(Icons.copy),
                                label: const Text('Copy Info'),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: _shareInfo,
                                icon: const Icon(Icons.share),
                                label: const Text('Share Info'),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      'Hold and Swipe to Call 911',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 70, // Adjust slider height
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 35),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
                        activeTrackColor: Colors.redAccent,
                        inactiveTrackColor: Colors.grey.shade300,
                        thumbColor: Colors.white,
                        overlayColor: Colors.redAccent.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (value) {
                          // Only allow incrementally sliding the slider
                          if ((value - sliderValue).abs() <= 15) { // Adjust step size as needed
                            setState(() {
                              sliderValue = value;
                            });

                            if (value == 100) {
                              _makeEmergencyCall(context);
                            }
                          }
                        },
                        onChangeEnd: (value) {
                          // Reset the slider after action
                          setState(() {
                            sliderValue = 0;
                          });
                        },
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey.shade300,
                        label: 'Slide to Call',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Function to refresh the page
  Future<void> _refreshPage() async {
    await _getLocationAndAddress();
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

}


