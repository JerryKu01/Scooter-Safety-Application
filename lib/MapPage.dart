import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooter_safety_application/firebase/authentication.dart';

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
  double _currentSpeed = 0.0; // To store the current speed

  @override
  void initState() {
    super.initState();
    _fetchPathData(); // Fetch the path data when the page loads
  }

// Fetch path data from Firestore (where path is stored as a list of maps)
  Future<void> _fetchPathData() async {
    try {
      print("Attempting to fetch data...");

      // Reference to the user's root document to check the 'is_in_trip' trigger
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthenticationHelper().uid)
          .get();

      if (userSnapshot.exists && userSnapshot['is_in_trip'] == true) {
        // If 'is_in_trip' is true, fetch the most recent trip
        QuerySnapshot tripQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthenticationHelper().uid)
            .collection('gps_data')
            .orderBy("start_time", descending: true)
            .limit(1)
            .get();

        if (tripQuerySnapshot.docs.isNotEmpty) {
          DocumentSnapshot tripSnapshot = tripQuerySnapshot.docs.first;

          print("Fetched trip data: ${tripSnapshot.data()}");

          List<dynamic> pathData = tripSnapshot['path'];

          // Debug: print the path data fetched
          print("Path data: $pathData");

          // Convert Firestore data to LatLng points
          setState(() {
            _path = pathData
                .map((point) => LatLng(point['latitude'], point['longitude']))
                .toList();
            _currentSpeed = pathData.last['speed']; // Get the latest speed value
          });

          // Move the map to the first point in the path after updating the state
          if (_path.isNotEmpty && _mapInitialized) {
            _mapController.move(
                _path.first, 15.0); // Center the map on the first point with a zoom level of 15.0
          }
        } else {
          // No trips found for the user
          setState(() {
            _path = [];
            _currentSpeed = 0.0;
          });
          print("No trip data found for this userId and tripId.");
        }
      } else {
        // 'is_in_trip' is false or user document doesn't exist
        setState(() {
          _path = [];
          _currentSpeed = 0.0;
        });
        print("No active trips found.");
      }
    } catch (e) {
      print("Error fetching path data: $e");
      setState(() {
        _path = [];
        _currentSpeed = 0.0;
      });
    }
  }

  // Refresh the data
  void _refreshData() {
    setState(() {
      _path.clear();
      _currentSpeed = 0.0;
      _mapInitialized = false;
    });
    _fetchPathData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Current Trip'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: _path.isEmpty
          ? Center(
        child: Text(
          'No active trips found',
          style: TextStyle(fontSize: 18.0),
        ),
      )
          : Column(
        children: [
          // Display the current speed in a card
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.speed,
                  color: Theme.of(context).primaryColor,
                  size: 40.0,
                ),
                title: Text(
                  'Current Speed',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${(_currentSpeed * 1.15078).toStringAsFixed(2)} mph',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          // Expanded map area
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _path.isNotEmpty ? _path.first : LatLng(0.0, 0.0),
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
                // Polyline layer for the path
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _path,
                      strokeWidth: 4.0,
                      color: Theme.of(context).primaryColor, // Path color
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: _path.isNotEmpty
                      ? [
                    Marker(
                      point: _path.last,
                      width: 80.0,
                      height: 80.0,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ),
                  ]
                      : [],
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
