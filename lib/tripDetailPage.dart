import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:scooter_safety_application/firebase/authentication.dart';

class TripDetailsPage extends StatefulWidget {
  final String tripId;

  TripDetailsPage({required this.tripId});

  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final String userId = AuthenticationHelper().uid;
  Map<String, dynamic>? tripData;
  List<LatLng> _path = [];
  final MapController _mapController = MapController();
  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchTripData();
  }

  Future<void> _fetchTripData() async {
    try {
      DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('gps_data')
          .doc(widget.tripId)
          .get();

      if (tripSnapshot.exists) {
        final data = tripSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> pathData = data['path'];

        setState(() {
          tripData = data;
          _path = pathData
              .map((point) => LatLng(point['latitude'], point['longitude']))
              .toList();
        });

        if (_path.isNotEmpty && _mapInitialized) {
          _mapController.move(_path.first, 15.0);
        }
      } else {
        print("No trip data found.");
      }
    } catch (e) {
      print("Error fetching trip data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tripData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Trip Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final DateTime startTime = (tripData!['start_time'] as Timestamp).toDate();
    final DateTime endTime = (tripData!['end_time'] as Timestamp).toDate();
    final duration = tripData!['duration'] ?? 0;
    final distance = tripData!['distance'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trip on ${startTime.toLocal().toString().split(' ')[0]}'),
      ),
      body: Column(
        children: [
          // Trip metadata
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Start Time: ${startTime.toLocal()}'),
                Text('End Time: ${endTime.toLocal()}'),
                Text('Duration: ${duration.toStringAsFixed(1)} mins'),
                Text('Distance: ${distance.toStringAsFixed(2)} km'),
              ],
            ),
          ),
          // Map showing the trip path
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                onMapReady: () {
                  setState(() {
                    _mapInitialized = true;
                  });
                  if (_path.isNotEmpty) {
                    _mapController.move(_path.first, 15.0);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _path,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: _path.isNotEmpty
                      ? [
                    Marker(
                      point: _path.first,
                      width: 80.0,
                      height: 80.0,
                      child: Icon(
                        Icons.location_pin,
                        color: Colors.green,
                        size: 50.0,
                      ),
                    ),
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
