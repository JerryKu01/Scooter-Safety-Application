// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class GpsData {
//   final double latitude;
//   final double longitude;
//   final DateTime timestamp;
//
//   GpsData({required this.latitude, required this.longitude, required this.timestamp});
//
//   factory GpsData.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return GpsData(
//       latitude: data['latitude'],
//       longitude: data['longitude'],
//       timestamp: (data['timestamp'] as Timestamp).toDate(),
//     );
//   }
// }
//
// class GpsDataService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//
//   // For Option A: Get the current location
//   Stream<GpsData> getCurrentLocationStream() {
//     return _db.collection('gps_data').doc('current_location').snapshots().map(
//           (doc) => GpsData.fromFirestore(doc),
//     );
//   }
//
//   // For Option B: Get a stream of GPS data points
//   Stream<List<GpsData>> getGpsDataStream() {
//     return _db
//         .collection('gps_data')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((querySnapshot) => querySnapshot.docs.map((doc) => GpsData.fromFirestore(doc)).toList());
//   }
// }
