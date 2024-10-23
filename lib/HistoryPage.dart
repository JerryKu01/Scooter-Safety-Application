import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:scooter_safety_application/firebase/authentication.dart';
import 'package:scooter_safety_application/tripDetailPage.dart';

class TripHistoryPage extends StatefulWidget {
  @override
  _TripHistoryPageState createState() => _TripHistoryPageState();
}

class _TripHistoryPageState extends State<TripHistoryPage> {
  final String userId = AuthenticationHelper().uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('gps_data')
            .orderBy('start_time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading trips'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final trips = snapshot.data!.docs;
          if (trips.isEmpty) {
            return Center(child: Text('No trips found'));
          }
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              final data = trip.data() as Map<String, dynamic>;

              final DateTime startTime = (data['start_time'] as Timestamp).toDate();
              final duration = data['duration'] ?? 0;
              final distance = data['distance'] ?? 0.0;
              final List<dynamic> pathData = data['path'] ?? [];

              // Convert pathData to LatLng list
              List<LatLng> path = pathData.map((point) {
                return LatLng(point['latitude'], point['longitude']);
              }).toList();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripDetailsPage(tripId: trip.id),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        // Map preview
                        ClipRRect(
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15.0)),
                          child: Container(
                            height: 150,
                            child: FlutterMap(
                              options: MapOptions(
                                interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
                                initialCenter: path.isNotEmpty ? path[0] : LatLng(0, 0),
                                initialZoom: 13.5,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  subdomains: ['a', 'b', 'c'],
                                ),
                                if (path.isNotEmpty)
                                  PolylineLayer(
                                    polylines: [
                                      Polyline(
                                        points: path,
                                        strokeWidth: 4.0,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        // Trip information
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Trip details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trip on ${startTime.toLocal().toString().split(' ')[0]}',
                                      style: TextStyle(
                                          fontSize: 18.0, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Icon(Icons.timer, size: 16.0),
                                        SizedBox(width: 4.0),
                                        Text(
                                          '${duration.toStringAsFixed(1)} mins',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.map, size: 16.0),
                                        SizedBox(width: 4.0),
                                        Text(
                                          '${distance.toStringAsFixed(2)} km',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, size: 16.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
