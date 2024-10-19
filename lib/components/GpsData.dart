import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scooter_safety_application/firebase/authentication.dart';

class GpsData {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  GpsData({required this.latitude, required this.longitude, required this.timestamp});

  factory GpsData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return GpsData(
      latitude: data['latitude'],
      longitude: data['longitude'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

class GpsDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // For Option A: Get the current location
  Future<List<Map<String, dynamic>>> getUserPath() async {
    try {
      DocumentSnapshot tripSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthenticationHelper().uid)
          .collection('gps_data')
          .doc('trip_test')
          .get();

      if (tripSnapshot.exists) {
        // Get the path as a list of maps
        List<dynamic> pathData = tripSnapshot['path'];

        // Convert to list of maps with latitude, longitude, and timestamp
        return pathData.map((point) => {
          'latitude': point['latitude'],
          'longitude': point['longitude'],
          'timestamp': point['timestamp'],
        }).toList();
      } else {
        print("No trip data found");
        return [];
      }
    } catch (e) {
      print("Error getting path data: $e");
      return [];
    }
  }


  // For Option B: Get a stream of GPS data points
  Stream<List<GpsData>> getGpsDataStream() {
    return _db
        .collection('gps_data')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => GpsData.fromFirestore(doc)).toList());
  }
}
