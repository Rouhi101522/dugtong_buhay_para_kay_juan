import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(14.599512, 120.984222);
  final Set<Marker> _markers = {};
  List<Map<String, dynamic>> _hospitalData = [];
  String mapTheme = '';
  bool isLoading = true;
  int _currentHospitalIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
    DefaultAssetBundle.of(context)
        .loadString('assets/styles/map_style.json')
        .then((value) {
      setState(() {
        mapTheme = value;
      });
    });
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _fetchHospitals();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _mapController.animateCamera(CameraUpdate.newLatLng(_initialPosition));
    });
  }

  Future<void> _fetchHospitals() async {
    if (_hospitalData.isNotEmpty) {
      _updateMarkers();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? cachedHospitals = prefs.getString('hospital_data');

    if (cachedHospitals != null) {
      setState(() {
        _hospitalData =
        List<Map<String, dynamic>>.from(json.decode(cachedHospitals));
        _updateMarkers();
      });
      return;
    }


    setState(() => isLoading = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Searching for hospitals... Please wait.",
          style: TextStyle(color: Colors.white), // Text color
        ),
        backgroundColor: Colors.red,
        // Background color
        behavior: SnackBarBehavior.floating,
        // Makes it float above content
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        duration: Duration(seconds: 10), // Duration before auto-dismiss
      ),
    );

    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=medical+center+OR+hospital+OR+general+hospital+OR+ospital+OR+memorial+hospital+OR+doctors+OR+center+OR+Ospital&location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=1000&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        List<Map<String, dynamic>> tempHospitals = [];

        for (var hospital in data['results']) {
          final details = await _fetchHospitalDetails(hospital['place_id'], apiKey);
          double routeDistance = await _fetchRouteDistance(
            _initialPosition.latitude,
            _initialPosition.longitude,
            hospital['geometry']['location']['lat'],
            hospital['geometry']['location']['lng'],
            apiKey,
          );
          tempHospitals.add({
            'name': hospital['name'],
            'lat': hospital['geometry']['location']['lat'],
            'lng': hospital['geometry']['location']['lng'],
            'phone': details['phone'],
            'telephone': details['telephone'],
            'opening_hours': hospital['opening_hours'] != null
                ? (hospital['opening_hours']['open_now'] ? 'Open' : 'Close')
                : 'Unknown',
            'emergency': hospital['business_status'] == 'OPERATIONAL' ? 'Yes' : 'No',
            'distance': routeDistance,
          });
        }

        tempHospitals.sort((a, b) => a['distance'].compareTo(b['distance']));

        prefs.setString('hospital_data', json.encode(tempHospitals));

        setState(() {
          _hospitalData = tempHospitals;
          _markers.clear();
          for (var hospital in _hospitalData) {
            _markers.add(
              Marker(
                markerId: MarkerId(hospital['name']),
                position: LatLng(hospital['lat'], hospital['lng']),
                infoWindow: InfoWindow(title: hospital['name']),
              ),
            );
          }
        });
      }
    }

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Finished searching for hospitals.",
          style: TextStyle(color: Colors.white), // Text color
        ),
        backgroundColor: Colors.green,
        // Background color
        behavior: SnackBarBehavior.floating,
        // Makes it float above content
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        duration: Duration(seconds: 10), // Duration before auto-dismiss
      ),
    );
  }

  Future<double> _fetchRouteDistance(double startLat, double startLng,
      double endLat, double endLng, String apiKey) async {
    final String directionsUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey';

    final response = await http.get(Uri.parse(directionsUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        return data['routes'][0]['legs'][0]['distance']['value'] /
            1000.0; // Convert to km
      }
    }
    return double.infinity;
  }

  Future<Map<String, String>> _fetchHospitalDetails(
      String placeId, String apiKey) async {
    final String detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_phone_number,international_phone_number&key=$apiKey';

    final response = await http.get(Uri.parse(detailsUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];
      return {
        'phone': result['formatted_phone_number'] ?? '',
        'telephone': result['international_phone_number'] ?? '',
      };
    }
    return {'phone': '', 'telephone': ''};
  }

  void _openGoogleMaps(double lat, double lng) {
    final Uri googleMapsUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    launchUrl(googleMapsUri);
  }

  void _callHospital(String? phone, String? telephone) {
    final String contact = phone?.isNotEmpty == true
        ? phone!
        : (telephone?.isNotEmpty == true ? telephone! : '');
    if (contact.isNotEmpty) {
      final Uri phoneUri = Uri.parse('tel:$contact');
      launchUrl(phoneUri);
    }
  }

  void _updateMarkers() {
    _markers.clear();
    for (var i = 0; i < _hospitalData.length; i++) {
      var hospital = _hospitalData[i];
      _markers.add(
        Marker(
          markerId: MarkerId(hospital['name']),
          position: LatLng(hospital['lat'], hospital['lng']),
          icon: BitmapDescriptor.defaultMarkerWithHue(i == _currentHospitalIndex
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: hospital['name']),
        ),
      );
    }
  }

  void _onHospitalSelected(int index) {
    setState(() {
      _currentHospitalIndex = index;
      _updateMarkers();
      _mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_hospitalData[index]['lat'], _hospitalData[index]['lng']),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hospital Locator')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _mapController.setMapStyle(mapTheme);
            },
            initialCameraPosition:
            CameraPosition(target: _initialPosition, zoom: 14.0),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          _hospitalData.isNotEmpty
              ? Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: SizedBox(
              height: 166,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _hospitalData.length,
                onPageChanged: (index) => _onHospitalSelected(index),
                itemBuilder: (context, index) {
                  final hospital = _hospitalData[index];
                  return Card(
                    color: index == _currentHospitalIndex
                        ? Colors.pink[100]
                        : Colors.white,
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(12.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                'Outpatient Department: ${hospital['opening_hours']}'),
                            Text(
                                'Accepting Emergencies: ${hospital['emergency']}'),
                            Text(
                                'Contact: ${hospital['phone'] ?? hospital['telephone']}'),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.directions,
                                      color: Colors.blue),
                                  onPressed: () => _openGoogleMaps(
                                      hospital['lat'], hospital['lng']),
                                ),
                                IconButton(
                                  icon:
                                  Icon(Icons.call, color: Colors.green),
                                  onPressed: () => _callHospital(
                                      hospital['phone'],
                                      hospital['telephone']),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
