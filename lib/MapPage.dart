import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:scooter_safety_application/components/GpsDataService.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:scooter_safety_application/firebase/authentication.dart";

class MapPage extends StatefulWidget {

  MapPage();

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  bool _mapInitialized = false;

  // Path list for the user's journey
  List<LatLng> _path = [];

  @override
  void initState() {
    super.initState();
    _fetchPathData(); // Fetch the path data when the page loads
  }

  // Fetch path data from Firestore (where path is stored as a list of maps)
  Future<void> _fetchPathData() async {
    try {
      print("Attempting to fetch data...");

      // Reference to the user's trip document
      DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthenticationHelper().uid)
          .collection('gps_data')
          .doc('trip_test')
          .get();

      print("Fetched trip data: ${tripSnapshot.data()}");

      if (tripSnapshot.exists) {
        List<dynamic> pathData = tripSnapshot['path'];

        // Debug: print the path data fetched
        print("Path data: $pathData");

        // Convert Firestore data to LatLng points
        setState(() {
          _path = pathData.map((point) => LatLng(point['latitude'], point['longitude'])).toList();
        });

        // Move the map to the first point in the path after updating the state
        if (_path.isNotEmpty && _mapInitialized) {
          _mapController.move(_path.first, 15.0); // Center the map on the first point with a zoom level of 15.0
        }

      } else {
        print("No trip data found for this userId and tripId.");
      }
    } catch (e) {
      print("Error fetching path data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Tracker')),
      body: _path.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _path.isNotEmpty ? _path.first : LatLng(0.0, 0.0), // Set the map center to the first path point
          initialZoom: 15.0,
          onMapReady: () {
            setState(() {
              _mapInitialized = true;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _path.isNotEmpty
                ? [
              Marker(
                point: _path.last, // Show marker at the most recent location
                width: 80.0,
                height: 80.0,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 50.0,
                ),
              ),
            ]
                : [],
          ),
          // Polyline layer for the path
          PolylineLayer(
            polylines: [
              Polyline(
                points: _path,
                strokeWidth: 4.0,
                color: Colors.blue, // Path color
              ),
            ],
          ),
        ],
      ),
    );
  }
}
