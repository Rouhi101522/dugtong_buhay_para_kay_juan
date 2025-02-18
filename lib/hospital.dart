import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});
  @override
  _HospitalPageState createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  String mapTheme = '';
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(14.599512, 120.984222);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? _hospitalLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
    DefaultAssetBundle.of(context)
        .loadString('assets/styles/map_style.json')
        .then((value) {
      mapTheme = value;
    });
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation(); // Get the user's current location
    await _findNearestHospital(); // Always attempt to find the nearest hospital
    if (_hospitalLocation != null) {
      await _createRoute(_hospitalLocation!); // If a hospital is found, create the route
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: _initialPosition,
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );

      _mapController.animateCamera(
        CameraUpdate.newLatLng(_initialPosition),
      );
    });
  }

  // Find the nearest hospital using the Google Places API
  Future<void> _findNearestHospital() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Locating closest hospital. Thank you for your patience.'),
        duration: Duration(seconds: 7),
        backgroundColor: Colors.blueAccent,
      ),
    );

    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=medical+center+OR+hospital+OR+general+hospital+OR+ospital+OR+memorial+hospital+OR+doctors+OR+center+OR+Ospital+ng+Makati&location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=1000&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        double minDistance = double.infinity;
        LatLng? closestHospital;
        String? closestHospitalName;

        for (var hospital in data['results']) {
          final lat = hospital['geometry']['location']['lat'];
          final lng = hospital['geometry']['location']['lng'];
          final hospitalName = hospital['name'];

          // Print the hospital name and coordinates
          print('Hospital: $hospitalName, Lat: $lat, Lng: $lng');

          // Fetch the route to calculate the polyline distance
          final routeDistance = await _getRouteDistance(
              _initialPosition.latitude, _initialPosition.longitude, lat, lng);

          print('Route distance to $hospitalName: $routeDistance meters');

          // Check if this hospital's polyline path is closer
          if (routeDistance < minDistance) {
            minDistance = routeDistance;
            closestHospital = LatLng(lat, lng);
            closestHospitalName = hospitalName;
          }
        }

        print('Closest Hospital: $closestHospitalName, Distance: $minDistance meters');

        if (closestHospital != null) {
          _hospitalLocation = closestHospital;

          // Update the Snackbar with a success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hospital Found. Proceed with caution.'),
              duration: Duration(seconds: 5),
              backgroundColor: Colors.green,
            ),
          );

          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('hospital'),
                position: _hospitalLocation!,
                infoWindow: const InfoWindow(title: 'Closest Hospital'),
              ),
            );
          });
        }
      } else {
        print('No hospitals found in the vicinity.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hospitals found nearby.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      print('Error fetching nearby hospitals: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching hospitals.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Fetch route and calculate polyline path length
  Future<double> _getRouteDistance(
      double startLat, double startLng, double endLat, double endLng) async {
    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(points);

        // Calculate the total path distance
        double totalDistance = 0.0;
        for (int i = 0; i < decodedPoints.length - 1; i++) {
          totalDistance += _calculateDistance(
            decodedPoints[i].latitude,
            decodedPoints[i].longitude,
            decodedPoints[i + 1].latitude,
            decodedPoints[i + 1].longitude,
          );
        }

        return totalDistance;
      }
    }
    return double.infinity; // Return an infinite distance if no route found
  }

  // Calculate distance between two LatLng points in meters
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Earth radius in meters
    final phi1 = lat1 * (3.141592653589793 / 180); // Convert to radians
    final phi2 = lat2 * (3.141592653589793 / 180); // Convert to radians
    final deltaPhi = (lat2 - lat1) * (3.141592653589793 / 180);
    final deltaLambda = (lon2 - lon1) * (3.141592653589793 / 180);

    final a = (sin(deltaPhi / 2) * sin(deltaPhi / 2)) +
        cos(phi1) * cos(phi2) * (sin(deltaLambda / 2) * sin(deltaLambda / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  // Fetch route and draw polyline
  Future<void> _createRoute(LatLng hospitalLocation) async {
    final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? 'default_value';
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_initialPosition.latitude},${_initialPosition.longitude}&destination=${hospitalLocation.latitude},${hospitalLocation.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(points);

        setState(() {
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: decodedPoints,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      } else {
        print('No route found.');
      }
    } else {
      print('Error fetching route: ${response.body}');
    }
  }

  // Decode the polyline string into a list of LatLng points
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.setMapStyle(mapTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14.0,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
